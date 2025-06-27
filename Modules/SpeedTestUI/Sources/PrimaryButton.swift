import SwiftUI

public struct StartStopButton: View {
    public enum State {
        case start, stop

        fileprivate var title: String {
            switch self {
            case .start: SpeedTestUIStrings.start
            case .stop: SpeedTestUIStrings.stop
            }
        }

        @discardableResult
        public mutating func toggle() -> State {
            switch self {
            case .start: self = .stop
            case .stop: self = .start
            }

            return self
        }
    }

    public let state: State
    public let action: () -> Void

    public var body: some View {
        Button(action: action) {
            Text(state.title.uppercased())
                .font(.callout)
                .bold()
                .foregroundStyle(SpeedTestUIAsset.Colors.foregroundSecondary.swiftUIColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(foregroundStyle())
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .animation(.linear, value: state)
    }

    // MARK: - Initializers

    public init(
        state: State,
        action: @escaping () -> Void
    ) {
        self.state = state
        self.action = action
    }

    // MARK: - Private helpers

    private func foregroundStyle() -> some ShapeStyle {
        let colors = switch state {
        case .start: [
            SpeedTestUIAsset.Colors.start1.swiftUIColor,
            SpeedTestUIAsset.Colors.start2.swiftUIColor,
        ]
        case .stop: [
            SpeedTestUIAsset.Colors.stop1.swiftUIColor,
            SpeedTestUIAsset.Colors.stop2.swiftUIColor,
        ]
        }

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    @Previewable @State var state = StartStopButton.State.start

    StartStopButton(state: state) {
        state.toggle()
    }
    .padding()
}
