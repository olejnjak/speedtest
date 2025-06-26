import SpeedTestUI
import SwiftUI

struct SpeedTestView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Ubiquity Speed Test")
                .font(.title)
                .bold()

            VStack {
                TachoView(speed: 100, maxSpeed: 1000)

                ZStack {
                    HStack {
                        Text("0")
                        Spacer()
                        Text("1 Gbps")
                    }

                    Text("100 Mbps")
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)

            InfoRow(title: SpeedTestStrings.server, content: .none)
            InfoRow(title: SpeedTestStrings.ping, content: .none)
                .padding(.bottom, 32)

            StartStopButton(state: .start) { _ in
                // TODO: Implement
            }
        }
        .padding()
    }
}

#Preview {
    SpeedTestView()
}
