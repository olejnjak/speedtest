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
                TachoView(progress: viewModel.speedProgress)

                ZStack(alignment: .top) {
                    HStack {
                        Text("0")
                        Spacer()
                        Text(viewModel.maxSpeedText)
                    }

                    VStack {
                        Text(viewModel.speedText)

                        ProgressView()
                            .opacity(viewModel.isTestRunning ? 1 : 0)
                    }
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
