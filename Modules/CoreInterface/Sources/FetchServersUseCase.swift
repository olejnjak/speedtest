public struct Server {
    public let name: String
}

public struct FetchServersError: Error {

}

public protocol FetchServersUseCase {
    func callAsFunction() async throws(FetchServersError) -> [Server]
}
