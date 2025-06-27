import CoreInterface
import Foundation

public func createServersRepository(
    apiClient: APIClient
) -> ServersRepository {
    ServersRepositoryImpl(apiClient: apiClient)
}

private final class ServersRepositoryImpl: ServersRepository {
    private let apiClient: APIClient
    private let serverMapper = ServerMapper()

    // MARK: - Interface

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    // MARK: - Actions

    func servers() async throws(NetworkError) -> [Server] {
        let apiServers = try await apiClient.get(
            "https://sp-dir.uwn.com/api/v2/servers?secured=only",
            result: [APIServer].self
        )

        return serverMapper(apiServers)
    }
}
