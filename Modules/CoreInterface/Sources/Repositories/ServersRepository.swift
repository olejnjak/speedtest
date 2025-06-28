import Foundation

public protocol ServersRepository {
    func servers() async throws(NetworkError) -> [Server]
    func ping(_ server: Server) async throws -> TimeInterval
}
