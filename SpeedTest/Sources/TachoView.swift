import SwiftUI

struct HalfCircle: Shape {
    var progress = Progress(totalUnitCount: 1, completedUnitCount: 1)

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: min(rect.width / 2, rect.height),
            startAngle: .degrees(-180),
            endAngle: .degrees(-180 + 180 * progress.fractionCompleted),
            clockwise: false
        )
        return path
    }
}


struct Needle: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        let needleCenter = CGPoint(x: rect.midX, y: rect.maxY)

        var path = Path()
        path.addArc(
            center: needleCenter,
            radius: min(rect.width, rect.height) / 10,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        path.closeSubpath()

        let needleHeight = rect.height / 20
        let needleWidth = rect.width / 2 * 0.85

        path.addRect(
            .init(
                x: needleCenter.x - needleWidth,
                y: needleCenter.y - needleHeight / 2,
                width: needleWidth,
                height: needleHeight
            )
        )

        return path
    }
}

struct TachoView: View {
    let progress: Progress

    var body: some View {
        ZStack {
            HalfCircle()
                .stroke(Color.gray, lineWidth: 8)

            HalfCircle(progress: progress)
                .stroke(Color.blue, lineWidth: 8)

            Needle()
                .fill(Color.red)
                .rotationEffect(.degrees(180 * progress.fractionCompleted), anchor: .bottom)
        }
        .animation(.linear, value: progress)
        .aspectRatio(2, contentMode: .fit)
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var speed: Double = 0

    TachoView(progress: .init(totalUnitCount: 1000, completedUnitCount: .init(speed)))
        .frame(width: 200, height: 100)
        .task {
            while true {
                for _ in 0..<1000 {
                    speed += 1
                    try? await Task.sleep(for: .milliseconds(1))
                }

                for _ in 0..<1000 {
                    speed -= 1
                    try? await Task.sleep(for: .milliseconds(1))
                }
            }
        }
}

extension Progress {
    convenience init(totalUnitCount: Int64, completedUnitCount: Int64) {
        self.init(totalUnitCount: totalUnitCount)
        self.completedUnitCount = completedUnitCount
    }

    var isCompleted: Bool { totalUnitCount == completedUnitCount }
}
