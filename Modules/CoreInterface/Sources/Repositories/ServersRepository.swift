import Foundation

public protocol ServersRepository {
    func servers() async throws(NetworkError) -> [Server]
    func ping(_ server: Server) async throws -> TimeInterval
    func download(_ server: Server, mb: Int) async throws -> TimeInterval
}
