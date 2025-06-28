import CoreInterface
import Observation
import OSLog
import SpeedTestUI

struct PresentableError: Identifiable {
    var id: String { "T:\(title), M:\(message)" }

    let title: String
    let message: String
}

protocol SpeedTestViewModel {
    var speed: Double { get }
    var maxSpeed: Double { get }

    var server: InfoRow.Content { get }
    var ping: InfoRow.Content { get }

    var isTestRunning: Bool { get }
    var error: PresentableError? { get set }

    func startTest()
    func stopTest()
}

final class MockSpeedTestViewModel: SpeedTestViewModel {
    var speed: Double = 100
    var maxSpeed: Double = 1000
    
    var server: InfoRow.Content = .none
    var ping: InfoRow.Content = .none
    
    var isTestRunning: Bool = false
    var error: PresentableError?

    func startTest() {

    }

    func stopTest() {

    }
}

extension SpeedTestViewModel {
    var startStopState: StartStopButton.State {
        isTestRunning ? .stop : .start
    }

    func toggleTest() {
        isTestRunning ? stopTest() : startTest()
    }
}

func createSpeedTestViewModel(
    fetchServersUseCase: FetchServersUseCase,
    selectServerUseCase: SelectServerUseCase,
    speedTestUseCase: PerformDownloadSpeedTestUseCase
) -> SpeedTestViewModel {
    SpeedTestViewModelImpl(
        fetchServersUseCase: fetchServersUseCase,
        selectServersUseCase: selectServerUseCase,
        speedTestUseCase: speedTestUseCase
    )
}

@Observable
private final class SpeedTestViewModelImpl: SpeedTestViewModel {
    private(set) var speed: Double = 100
    private(set) var maxSpeed: Double = 1000

    var error: PresentableError?

    private(set) var server: InfoRow.Content = .none
    private(set) var ping: InfoRow.Content = .none

    private(set) var isTestRunning: Bool = false

    private let fetchServersUseCase: FetchServersUseCase
    private let selectServerUseCase: SelectServerUseCase
    private let speedTestUseCase: PerformDownloadSpeedTestUseCase

    // MARK: - Initializers

    init(
        fetchServersUseCase: FetchServersUseCase,
        selectServersUseCase: SelectServerUseCase,
        speedTestUseCase: PerformDownloadSpeedTestUseCase
    ) {
        self.fetchServersUseCase = fetchServersUseCase
        self.selectServerUseCase = selectServersUseCase
        self.speedTestUseCase = speedTestUseCase
    }

    // MARK: - Actions

    func startTest() {
        isTestRunning = true
        server = .loading
        ping = .loading

        Task {
            defer { isTestRunning = false }

            do {
                let servers = try await fetchServersUseCase()
                let serverResult = try await selectServerUseCase(servers)

                server = .string(serverResult.server.name)
                ping = .string(String(serverResult.ping)) // TODO: Correct time formatting

                for try await speed in speedTestUseCase(serverResult.server) {
                    updateSpeedResult(speed)
                }
            } catch {
                // TODO: Concrete errors
                server = .none
                ping = .none

                self.error = .init(
                    title: "Error",
                    message: String(describing: error)
                )
            }
        }
    }

    func stopTest() {
        // TODO: Real implementation
        isTestRunning = false
        server = .none
        ping = .none
    }

    // MARK: - Private helpers

    private func updateSpeedResult(_ speedResult: Result<SpeedResult, DownloadSpeedTestError>) {
        switch speedResult {
        case .success(let result):
            speed = result.speed
            // TODO: Calculate average speed
        case .failure(let error):
            Logger.speedTest.error("Got speed test result failure: \(error)")
            // TODO: Handle error
        }
    }
}
