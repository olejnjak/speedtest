import CoreInterface
import Servers

extension AppDependency {
    var fetchServersUseCase: FetchServersUseCase {
        createFetchServersUseCase(serversRepository: serversRepository)
    }

    var performDownloadSpeedTestUseCase: PerformDownloadSpeedTestUseCase {
        PerformDownloadSpeedTestUseCaseImpl()
    }

    var selectServerUseCase: SelectServerUseCase {
        createSelectServerUseCase()
    }
}
