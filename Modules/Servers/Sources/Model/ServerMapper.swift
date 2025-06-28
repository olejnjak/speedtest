import CoreInterface

struct ServerMapper {
    func callAsFunction(_ apiServer: APIServer) -> Server {
        .init(
            name: apiServer.provider,
            url: apiServer.url,
            location: .init(
                latitude: apiServer.latitude,
                longitude: apiServer.longitude
            )
        )
    }

    func callAsFunction(_ apiServers: [APIServer]) -> [Server] {
        apiServers.map(callAsFunction)
    }
}
