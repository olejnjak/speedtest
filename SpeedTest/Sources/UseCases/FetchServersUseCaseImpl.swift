import CoreInterface

struct FetchServersUseCaseImpl: FetchServersUseCase {
    func callAsFunction() async throws(FetchServersError) -> [Server] {
        // TODO: Implement
        throw FetchServersError()
    }
}
