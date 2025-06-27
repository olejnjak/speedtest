public protocol FetchServersUseCase {
    func callAsFunction() async throws(FetchServersError) -> [Server]
}
