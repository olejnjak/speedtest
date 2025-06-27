import SwiftUI

@main
struct UbiquitySpeedtestApp: App {
    private let appDependencies = AppDependency()

    var body: some Scene {
        WindowGroup {
            SpeedTestView(viewModel: createSpeedTestViewModel(
                fetchServersUseCase: appDependencies.fetchServersUseCase,
                selectServerUseCase: appDependencies.selectServerUseCase,
                speedTestUseCase: appDependencies.performDownloadSpeedTestUseCase
            ))
        }
    }
}
