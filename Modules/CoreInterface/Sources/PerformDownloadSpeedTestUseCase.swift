public struct SpeedResult {

}

public protocol PerformDownloadSpeedTestUseCase {
    associatedtype PartialResultSequence: AsyncSequence where PartialResultSequence.Element == SpeedResult

    func callAsFunction(_ server: Server) -> PartialResultSequence
}
