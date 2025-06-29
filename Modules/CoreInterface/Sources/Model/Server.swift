import CoreLocation
import Foundation

public struct Server {
    public let name: String
    public let url: URL
    public let location: CLLocation
    public let maxMbps: Int

    public init(
        name: String,
        url: URL,
        location: CLLocation,
        maxMbps: Int
    ) {
        self.name = name
        self.url = url
        self.location = location
        self.maxMbps = maxMbps
    }
}
