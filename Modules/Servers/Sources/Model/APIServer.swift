import Foundation

struct APIServer: Decodable {
    let url: URL
    let latitude: Double
    let longitude: Double
    let provider: String
    let speedMbps: Int
}
