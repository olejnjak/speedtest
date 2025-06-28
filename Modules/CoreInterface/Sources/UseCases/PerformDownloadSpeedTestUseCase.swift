public struct SpeedResult {
    public let speed: Double

    public init(speed: Double) {
        self.speed = speed
    }
}

public struct DownloadSpeedTestError: Error {

}

public protocol PerformDownloadSpeedTestUseCase {
    func callAsFunction(_ server: Server) -> AsyncStream<Result<SpeedResult, DownloadSpeedTestError>>
}
