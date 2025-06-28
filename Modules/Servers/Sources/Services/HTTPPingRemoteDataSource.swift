import CoreInterface

func createHTTPPingRemoteDataSource(
    apiClient: APIClient
) -> PingRemoteDataSource {
    HTTPPingRemoteDataSource(
        apiClient: apiClient
    )
}

private struct HTTPPingRemoteDataSource: PingRemoteDataSource {
    let apiClient: APIClient

    func ping(_ server: CoreInterface.Server) async throws {
        _ = try await apiClient.get(
            server.url.appending(path: "ping"),
            expectedStatusCodes: 200..<201
        ) as EmptyResponse
    }
}
