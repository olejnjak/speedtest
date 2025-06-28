import CoreInterface

protocol PingRemoteDataSource {
    func ping(_ server: Server) async throws
}
