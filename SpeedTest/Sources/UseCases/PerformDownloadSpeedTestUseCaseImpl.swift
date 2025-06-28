import CoreInterface

struct PerformDownloadSpeedTestUseCaseImpl: PerformDownloadSpeedTestUseCase {
    func callAsFunction(_ server: Server) -> AsyncStream<Result<SpeedResult, DownloadSpeedTestError>> {
        .init { continuation in
            Task {
                for i in [100, 110, 120, 90, 130] {
                    continuation.yield(.success(.init(speed: .init(i))))
                    try? await Task.sleep(for: .seconds(1))
                }
                continuation.finish()
            }
        }
    }
}
