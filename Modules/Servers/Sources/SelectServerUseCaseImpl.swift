import CoreInterface
import CoreLocation

@MainActor
public func createSelectServerUseCase() -> SelectServerUseCase {
    SelectServerUseCaseImpl(
        getLocationUseCase: createGetLocationUseCase()
    )
}

private struct SelectServerUseCaseImpl: SelectServerUseCase {
    private let getLocationUseCase: GetLocationUseCase

    // MARK: - Initializers

    init(
        getLocationUseCase: GetLocationUseCase
    ) {
        self.getLocationUseCase = getLocationUseCase
    }

    // MARK: - Actions

    func callAsFunction(
        _ servers: [Server]
    ) async throws(SelectServerError) -> SelectServerResult {
        guard servers.isEmpty == false else {
            throw .noServersProvided
        }

        guard let location = await getLocationUseCase() else {
            throw .unableToGetLocation
        }

        // TODO: Real implementation
        try? await Task.sleep(for: .seconds(1))

        return .init(server: servers[0], ping: 1)
    }
}
