import Foundation

struct Token {
    let token: String
    let expiration: ContinuousClock.Instant
}

protocol ServersRepositoryLocalDataSource: AnyObject {
    var token: Token? { get set }
}

func createServersRepositoryLocalDataSource() -> ServersRepositoryLocalDataSource {
    ServersRepositoryLocalDataSourceImpl()
}

private final class ServersRepositoryLocalDataSourceImpl: ServersRepositoryLocalDataSource {
    var token: Token?
}
