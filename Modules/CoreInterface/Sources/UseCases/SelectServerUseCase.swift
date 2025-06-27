import Foundation

public enum SelectServerError: Error {
    /// List of servers is empty
    case noServersProvided
}

public struct SelectServerResult {
    public let server: Server
    public let ping: TimeInterval

    public init(
        server: Server,
        ping: TimeInterval
    ) {
        self.server = server
        self.ping = ping
    }
}

public protocol SelectServerUseCase {
    /// Select server for speed test
    ///
    /// - Parameter servers: List of available servers, has to be non-empty
    /// - Returns: Closest server for speed test
    func callAsFunction(_ servers: [Server]) async throws(SelectServerError) -> SelectServerResult
}
