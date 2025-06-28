import CoreInterface

public func createFetchServersUseCase(
    serversRepository: ServersRepository
) -> FetchServersUseCase {
    FetchServersUseCaseImpl(
        serversRepository: serversRepository
    )
}

private struct FetchServersUseCaseImpl: FetchServersUseCase {
    let serversRepository: ServersRepository

    func callAsFunction() async throws(FetchServersError) -> [Server] {
        let servers = try await fetchServers()

        if servers.isEmpty {
            throw .serversEmpty
        }

        return servers
    }

    // MARK: - Private helpers

    private func fetchServers() async throws(FetchServersError) -> [Server] {
        do {
            return try await serversRepository.servers()
        } catch {
            throw .fetchFailed
        }
    }
}
