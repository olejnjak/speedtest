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
    var speedText: String { get }
    var maxSpeedText: String { get }
    var speedProgress: Progress { get }

    var server: InfoRow.Content { get }
    var ping: InfoRow.Content { get }

    var isTestRunning: Bool { get }
    var error: PresentableError? { get set }

    func startTest()
    func stopTest()
}

final class MockSpeedTestViewModel: SpeedTestViewModel {
    var speedText = "0 Mbps"
    var maxSpeedText = "1 Gbps"
    var speedProgress = Progress(totalUnitCount: 1000)

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
    var speedText: String { speedFormatter.speedString(speed) }
    var maxSpeedText: String { speedFormatter.maxSpeedString(maxSpeed) }

    var speedProgress: Progress {
        .init(
            totalUnitCount: .init(maxSpeed),
            completedUnitCount: .init(speed)
        )
    }

    private var speed: Double = 0
    private var numberOfPartialResults = 0
    private var maxSpeed: Double = 1000

    var error: PresentableError?

    private(set) var server: InfoRow.Content = .none
    private(set) var ping: InfoRow.Content = .none

    private(set) var isTestRunning: Bool = false

    private let speedFormatter = SpeedFormatter()
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
        numberOfPartialResults = 0

        Task {
            defer { isTestRunning = false }

            do {
                let servers = try await fetchServersUseCase()
                let serverResult = try await selectServerUseCase(servers)

                server = .string(serverResult.server.name)
                ping = .string(String(format: "%.2f ms", serverResult.ping * 1000))
                maxSpeed = .init(serverResult.server.maxMbps)

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
            let numberOfPartialResultsDouble = Double(numberOfPartialResults)
            speed = (speed * numberOfPartialResultsDouble + result.speed) / (numberOfPartialResultsDouble + 1)
            numberOfPartialResults += 1
        case .failure(let error):
            Logger.speedTest.error("Got speed test result failure: \(error)")
            // TODO: Handle error
        }
    }
}
