import CoreInterface

struct PerformDownloadSpeedTestUseCaseImpl: PerformDownloadSpeedTestUseCase {
    private enum Constants {
        static let maxTestDuration = 15
        static let fileSizeMB = 5
    }

    let serversRepository: ServersRepository

    private let clock = ContinuousClock()

    func callAsFunction(
        _ server: Server
    ) -> AsyncStream<Result<SpeedResult, DownloadSpeedTestError>> {
        .init { continuation in
            Task {
                let start = clock.now

                while start.duration(to: clock.now) < .seconds(Constants.maxTestDuration) {
                    do {
                        let chunkTime = try await serversRepository.download(
                            server,
                            mb: Constants.fileSizeMB
                        )
                        let speedMbps = Double(Constants.fileSizeMB * 8) / chunkTime
                        continuation.yield(.success(.init(speed: speedMbps)))
                    } catch {
                        continuation.yield(.failure(.init()))
                    }
                }

                continuation.finish()
            }
        }
    }
}
