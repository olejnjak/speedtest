import CoreInterface

final class AppDependency {
    var fetchServersUseCase: FetchServersUseCase { FetchServersUseCaseImpl() }
    var performDownloadSpeedTestUseCase: PerformDownloadSpeedTestUseCase { PerformDownloadSpeedTestUseCaseImpl() }
    var selectServerUseCase: SelectServerUseCase { SelectServerUseCaseImpl() }
}
