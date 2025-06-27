import CoreInterface

public func createSelectServerUseCase() -> SelectServerUseCase {
    SelectServerUseCaseImpl()
}

private struct SelectServerUseCaseImpl: SelectServerUseCase {
    func callAsFunction(_ servers: [Server]) async throws(SelectServerError) -> SelectServerResult {
        guard servers.isEmpty == false else {
            throw SelectServerError.noServersProvided
        }

        // TODO: Real implementation
        try? await Task.sleep(for: .seconds(1))

        return .init(server: servers[0], ping: 1)
    }
}
