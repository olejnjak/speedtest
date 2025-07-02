import Foundation
import OSLog

public extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "UbiquitySpeedTest"

    static let location = Logger(
        subsystem: subsystem,
        category: "Location"
    )

    static let speedTest = Logger(
        subsystem: subsystem,
        category: "SpeedTest"
    )

    static let icmpPing = Logger(
        subsystem: subsystem,
        category: "ICMPPing"
    )
}
