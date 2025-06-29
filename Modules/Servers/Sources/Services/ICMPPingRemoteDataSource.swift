import CoreInterface
import Foundation
import ICMPPing

func createICMPPingRemoteDataSource() -> PingRemoteDataSource {
    ICMPPingRemoteDataSource()
}

private struct ICMPPingRemoteDataSource: PingRemoteDataSource {
    func ping(_ server: Server) async throws {
        struct MissingHost: Error {

        }

        guard let host = server.url.host() else {
            throw MissingHost()
        }

        _ = try ICMPPing.ping(
            address: .init(
                host,
                port: .init(server.url.port ?? 80)
            )
        )
    }
}
