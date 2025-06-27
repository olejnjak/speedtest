import CoreInterface

struct SelectServerUseCaseImpl: SelectServerUseCase {
    func callAsFunction(_ servers: [Server]) async throws(SelectServerError) -> SelectServerResult {
        // TODO: Implement
        throw SelectServerError.noServersProvided
    }
}
