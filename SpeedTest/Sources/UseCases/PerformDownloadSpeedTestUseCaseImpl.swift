import CoreInterface

struct PerformDownloadSpeedTestUseCaseImpl: PerformDownloadSpeedTestUseCase {
    func callAsFunction(_ server: Server) -> AsyncStream<Result<SpeedResult, DownloadSpeedTestError>> {
        .init { _ in
            // TODO: Implement
        }
    }
}
