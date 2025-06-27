public protocol ServersRepository {
    func servers() async throws(NetworkError) -> [Server]
}
