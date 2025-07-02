import CoreInterface
import Foundation
import OSLog
import SimplePing

func createICMPPingRemoteDataSource() -> PingRemoteDataSource {
    ICMPPingRemoteDataSource()
}

private struct ICMPPingRemoteDataSource: PingRemoteDataSource {
    func ping(_ server: Server) async throws {
        try await AsyncSimplePing(server: server)()
    }
}

@MainActor
private final class AsyncSimplePing: NSObject, SimplePingDelegate {
    private let server: Server
    private var pinger: SimplePing?
    private var continuation: UnsafeContinuation<Void, Error>?

    // MARK: - Initializers

    init(server: Server) {
        self.server = server
    }

    // MARK: - SimplePing delegate

    nonisolated func simplePing(
        _ pinger: SimplePing,
        didFailWithError error: any Error
    ) {
        Logger.icmpPing.error("ICMP ping did fail with error: \(error)")

        Task {
            await finish(.failure(error))
        }
    }

    nonisolated func simplePing(
        _ pinger: SimplePing,
        didReceiveUnexpectedPacket packet: Data
    ) {
        struct UnexpectedData: Error { }

        Task {
            await finish(.failure(UnexpectedData()))
        }
    }

    nonisolated func simplePing(
        _ pinger: SimplePing,
        didReceivePingResponsePacket packet: Data,
        sequenceNumber: UInt16
    ) {
        Task {
            await finish(.success(()))
        }
    }

    nonisolated func simplePing(
        _ pinger: SimplePing,
        didStartWithAddress address: Data
    ) {
        Logger.icmpPing.debug("ICMP ping did start")
        pinger.send(with: nil)
    }

    nonisolated func simplePing(
        _ pinger: SimplePing,
        didSendPacket packet: Data,
        sequenceNumber: UInt16
    ) {
        Logger.icmpPing.debug("ICMP ping did send packet \(sequenceNumber)")
    }

    nonisolated func simplePing(
        _ pinger: SimplePing,
        didFailToSendPacket packet: Data,
        sequenceNumber: UInt16,
        error: any Error
    ) {
        Logger.icmpPing.error("ICMP ping failed to send packet \(sequenceNumber), error: \(error)")

        Task {
            await finish(.failure(error))
        }
    }

    // MARK: - Actions

    func callAsFunction() async throws {
        struct MissingHost: Error {

        }

        guard let host = server.url.host() else {
            throw MissingHost()
        }

        try await withUnsafeThrowingContinuation { c in
            continuation = c
            pinger = .init(hostName: host)
            pinger?.delegate = self
            pinger?.start()
        }
    }

    // MARK: - Private helpers

    private func finish(_ result: Result<Void, Error>) {
        continuation?.resume(with: result)
        continuation = nil
        pinger?.stop()
        pinger = nil
    }
}
