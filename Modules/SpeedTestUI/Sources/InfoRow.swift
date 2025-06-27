import SwiftUI

public struct InfoRow: View {
    public enum Content: Equatable {
        case none, loading, string(String)
    }

    private let title: String
    private let content: Content

    public var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                .font(.body)
                .foregroundStyle(SpeedTestUIAsset.Colors.foregroundPrimary.swiftUIColor)

            content
                .font(.body)
        }
        .animation(.easeInOut, value: content)
    }

    // MARK: - Initializers

    public init(
        title: String,
        content: Content
    ) {
        self.title = title
        self.content = content
    }
}

extension InfoRow.Content: View {
    public var body: some View {
        switch self {
        case .none: textLabel("---")
        case .loading: ProgressView()
        case .string(let string): textLabel(string)
        }
    }

    @ViewBuilder
    private func textLabel(_ text: String) -> some View {
        Text(text)
            .opacity(0.5)
            .foregroundStyle(SpeedTestUIAsset.Colors.foregroundPrimary.swiftUIColor)
    }
}

#Preview {
    VStack {
        InfoRow(title: "Title", content: .none)
        InfoRow(title: "Title", content: .loading)
        InfoRow(title: "Title", content: .string("String"))
    }
    .padding()
}
