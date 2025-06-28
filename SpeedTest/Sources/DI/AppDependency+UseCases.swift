import CoreInterface
import Servers

extension AppDependency {
    var fetchServersUseCase: FetchServersUseCase {
        createFetchServersUseCase(serversRepository: serversRepository)
    }

    var performDownloadSpeedTestUseCase: PerformDownloadSpeedTestUseCase {
        PerformDownloadSpeedTestUseCaseImpl()
    }

    @MainActor
    var selectServerUseCase: SelectServerUseCase {
        createSelectServerUseCase(
            serversRepository: serversRepository
        )
    }
}
