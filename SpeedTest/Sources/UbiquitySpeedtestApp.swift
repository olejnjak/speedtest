import SwiftUI

@main
struct UbiquitySpeedtestApp: App {
    var body: some Scene {
        WindowGroup {
            SpeedTestView(viewModel: createSpeedTestViewModel())
        }
    }
}
