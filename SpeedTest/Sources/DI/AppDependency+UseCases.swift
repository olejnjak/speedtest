import CoreInterface
import Servers

extension AppDependency {
    var fetchServersUseCase: FetchServersUseCase {
        createFetchServersUseCase(serversRepository: serversRepository)
    }

    var performDownloadSpeedTestUseCase: PerformDownloadSpeedTestUseCase {
        PerformDownloadSpeedTestUseCaseImpl(serversRepository: serversRepository)
    }

    @MainActor
    var selectServerUseCase: SelectServerUseCase {
        createSelectServerUseCase(
            serversRepository: serversRepository
        )
    }
}
