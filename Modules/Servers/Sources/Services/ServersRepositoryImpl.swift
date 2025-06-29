import CoreInterface
import Foundation

public func createServersRepository(
    apiClient: APIClient
) -> ServersRepository {
    ServersRepositoryImpl(
        apiClient: apiClient,
        pingRemoteDataSource: createHTTPPingRemoteDataSource(apiClient: apiClient),
        serversRepositoryLocalDataSource: createServersRepositoryLocalDataSource()
    )
}

private final actor ServersRepositoryImpl: ServersRepository {
    private enum Constants {
        static let tokenExpirationTreshold = Duration.seconds(30)
    }

    let apiClient: APIClient
    let pingRemoteDataSource: PingRemoteDataSource
    let serversRepositoryLocalDataSource: ServersRepositoryLocalDataSource
    let clock = ContinuousClock()

    private let serverMapper = ServerMapper()

    // MARK: - Initializers

    init(
        apiClient: APIClient,
        pingRemoteDataSource: PingRemoteDataSource,
        serversRepositoryLocalDataSource: ServersRepositoryLocalDataSource
    ) {
        self.apiClient = apiClient
        self.pingRemoteDataSource = pingRemoteDataSource
        self.serversRepositoryLocalDataSource = serversRepositoryLocalDataSource
    }

    // MARK: - Actions

    func servers() async throws(NetworkError) -> [Server] {
        let apiServers = try await apiClient.get(
            "https://sp-dir.uwn.com/api/v2/servers?secured=only",
            result: [APIServer].self
        )

        return serverMapper(apiServers)
    }

    func ping(_ server: Server) async throws -> TimeInterval {
        try await measure {
            try await pingRemoteDataSource.ping(server)
        }
    }

    func download(_ server: Server, mb: Int) async throws -> TimeInterval {
        var urlComponents = URLComponents(
            url: server.url.appending(path: "download"),
            resolvingAgainstBaseURL: true
        )
        var queryItems = urlComponents?.queryItems ?? .init()
        queryItems.append(.init(
            name: "size",
            value: .init(mb * 1_000_000)
        ))
        queryItems.append(.init(
            name: "token",
            value: try await tokens()
        ))
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL(server.url.absoluteString)
        }

        return try await measure {
            _ = try await apiClient.data(from: url)
        }
    }

    // MARK: - Private helpers

    private func measure(
        _ action: () async throws -> Void
    ) async rethrows -> TimeInterval {
        let duration = try await clock.measure {
            try await action()
        }

        let (seconds, attoSeconds) = duration.components
        return .init(.init(seconds) + Double(attoSeconds) / 1_000_000_000_000_000_000)
    }

    private func tokens() async throws(NetworkError) -> String {
        let start = clock.now

        if let currentToken = currentToken() {
            return currentToken
        }

        let tokensResponse = try await apiClient.post(
            "https://sp-dir.uwn.com/api/v1/tokens",
            result: TokensResponse.self
        )

        serversRepositoryLocalDataSource.token = .init(
            token: tokensResponse.token,
            expiration: start.advanced(by: .seconds(tokensResponse.ttl))
        )

        return tokensResponse.token
    }

    private func currentToken() -> String? {
        guard let currentToken = serversRepositoryLocalDataSource.token else {
            return nil
        }

        let ttl = clock.now.duration(to: currentToken.expiration)

        if ttl > Constants.tokenExpirationTreshold {
            return currentToken.token
        }

        serversRepositoryLocalDataSource.token = nil

        return nil
    }

    private struct TokensResponse: Decodable {
        let token: String
        let ttl: Int
    }
}
