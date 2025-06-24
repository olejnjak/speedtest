public struct Server {

}

public struct FetchServersError: Error {

}

public protocol FetchServersUseCase {
    func callAsFunction() async throws(FetchServersError) -> [Server]
}
