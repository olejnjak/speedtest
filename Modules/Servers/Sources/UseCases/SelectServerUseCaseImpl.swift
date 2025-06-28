import CoreInterface
import CoreLocation

@MainActor
public func createSelectServerUseCase(
    serversRepository: ServersRepository
) -> SelectServerUseCase {
    SelectServerUseCaseImpl(
        getLocationUseCase: createGetLocationUseCase(),
        serversRepository: serversRepository
    )
}

private struct SelectServerUseCaseImpl: SelectServerUseCase {
    private enum Constants {
        static let numberOfClosestServers = 5
    }

    let getLocationUseCase: GetLocationUseCase
    let serversRepository: ServersRepository

    // MARK: - Actions

    func callAsFunction(
        _ servers: [Server]
    ) async throws(SelectServerError) -> SelectServerResult {
        guard servers.isEmpty == false else {
            throw .noServersProvided
        }

        guard let location = await getLocationUseCase() else {
            throw .unableToGetLocation
        }

        let toPing = findClosestServers(servers, location: location)

        guard let serverForTest = await findBestServer(toPing) else {
            throw .unableToPingAnyServer
        }

        return serverForTest
    }

    // MARK: - Private helpers

    private func findClosestServers(
        _ servers: [Server],
        location: CLLocation
    ) -> [Server] {
        guard servers.count > Constants.numberOfClosestServers else {
            return servers
        }

        struct ServerWithDistance {
            let server: Server
            let distance: Double
        }

        let withDistance = servers.map { server in
            return ServerWithDistance(
                server: server,
                distance: server.location.distance(from: location)
            )
        }

        return withDistance.sorted { $0.distance < $1.distance }
            .prefix(5)
            .map(\.server)
    }

    /// Pings all `servers` and returns the server with the best ping
    /// - Parameter servers: Servers to ping
    /// - Return Server with the best ping, `nil` if no ping succeeded
    private func findBestServer(
        _ servers: [Server]
    ) async -> SelectServerResult? {
        guard servers.count > 0 else {
            return nil
        }

        var withPing = [SelectServerResult]()

        for server in servers {
            if let ping = try? await serversRepository.ping(server) {
                withPing.append(.init(server: server, ping: ping))
            }
        }

        return withPing.min { $0.ping < $1.ping }
    }
}
