import SpeedTestUI
import SwiftUI

struct SpeedTestView: View {
    @State var viewModel: SpeedTestViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Ubiquity Speed Test")
                .font(.title)
                .bold()

            VStack {
                TachoView(
                    speed: viewModel.speed,
                    maxSpeed: viewModel.maxSpeed
                )

                ZStack {
                    HStack {
                        Text("0")
                        Spacer()
                        Text(String(viewModel.maxSpeed) + " Mbps") // TODO: Formatting
                    }

                    Text(String(viewModel.speed) + " Mbps") // TODO: Formatting
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)

            InfoRow(
                title: SpeedTestStrings.Localizable.server,
                content: viewModel.server
            )
            InfoRow(
                title: SpeedTestStrings.Localizable.ping,
                content: viewModel.ping
            )
            .padding(.bottom, 32)

            StartStopButton(
                state: viewModel.startStopState,
                action: viewModel.toggleTest
            )
        }
        .padding()
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text(error.title),
                message: Text(error.message)
            )
        }
    }
}

#Preview {
    SpeedTestView(viewModel: MockSpeedTestViewModel())
}
