import Foundation

struct SpeedFormatter {
    private let maxSpeedFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .none
        nf.maximumFractionDigits = 0
        return nf
    }()

    private let speedFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .none
        nf.maximumFractionDigits = 1
        nf.minimumFractionDigits = 1
        return nf
    }()

    func maxSpeedString(_ speed: Double) -> String {
        if speed >= 1000 {
            return maxSpeedFormatter.string(from: .init(value: speed / 1000)).map { $0 + " Gbps" } ?? ""
        }

        return maxSpeedFormatter.string(from: .init(value: speed)).map { $0 + " Mbps" } ?? ""
    }

    func speedString(_ speed: Double) -> String {
        speedFormatter.string(from: .init(value: speed)).map { $0 + " Mbps" } ?? ""
    }
}
