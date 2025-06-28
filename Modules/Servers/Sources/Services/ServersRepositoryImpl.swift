import CoreInterface
import Foundation

public func createServersRepository(
    apiClient: APIClient
) -> ServersRepository {
    ServersRepositoryImpl(
        apiClient: apiClient,
        pingRemoteDataSource: createHTTPPingRemoteDataSource(apiClient: apiClient)
    )
}

private struct ServersRepositoryImpl: ServersRepository {
    let apiClient: APIClient
    let pingRemoteDataSource: PingRemoteDataSource
    let serverMapper = ServerMapper()
    var clock: any Clock<Duration> = ContinuousClock()

    // MARK: - Actions

    func servers() async throws(NetworkError) -> [Server] {
        let apiServers = try await apiClient.get(
            "https://sp-dir.uwn.com/api/v2/servers?secured=only",
            result: [APIServer].self
        )

        return serverMapper(apiServers)
    }

    func ping(_ server: Server) async throws -> TimeInterval {
        let duration = try await clock.measure {
            try await pingRemoteDataSource.ping(server)
        }

        let (seconds, attoSeconds) = duration.components
        return .init(.init(seconds) + Double(attoSeconds) / 1_000_000_000_000_000_000)
    }
}
