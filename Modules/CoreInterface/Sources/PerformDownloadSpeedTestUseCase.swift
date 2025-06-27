public struct SpeedResult {

}

public struct DownloadSpeedTestError: Error {

}

public protocol PerformDownloadSpeedTestUseCase {
    func callAsFunction(_ server: Server) -> AsyncStream<Result<SpeedResult, DownloadSpeedTestError>>
}
