import Observation
import SpeedTestUI

protocol SpeedTestViewModel {
    var speed: Double { get }
    var maxSpeed: Double { get }

    var server: InfoRow.Content { get }
    var ping: InfoRow.Content { get }

    var isTestRunning: Bool { get }

    func startTest()
    func stopTest()
}

final class MockSpeedTestViewModel: SpeedTestViewModel {
    var speed: Double = 100
    var maxSpeed: Double = 1000
    
    var server: InfoRow.Content = .none
    var ping: InfoRow.Content = .none
    
    var isTestRunning: Bool = false

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

func createSpeedTestViewModel() -> SpeedTestViewModel {
    SpeedTestViewModelImpl()
}

@Observable
private final class SpeedTestViewModelImpl: SpeedTestViewModel {
    let speed: Double = 100
    let maxSpeed: Double = 1000

    private(set) var server: InfoRow.Content = .none
    private(set) var ping: InfoRow.Content = .none

    private(set) var isTestRunning: Bool = false

    func startTest() {
        // TODO: Real implementation
        isTestRunning = true
        server = .loading
        ping = .loading
    }

    func stopTest() {
        // TODO: Real implementation
        isTestRunning = false
        server = .none
        ping = .none
    }
}
