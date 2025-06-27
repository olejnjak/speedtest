import CoreInterface

struct ServerMapper {
    func callAsFunction(_ apiServer: APIServer) -> Server {
        .init(name: apiServer.provider)
    }

    func callAsFunction(_ apiServers: [APIServer]) -> [Server] {
        apiServers.map(callAsFunction)
    }
}
