import Foundation

public enum NetworkError: Error {
    case invalidURL(String)
    case network(Error)
    case decoding(DecodingError)
    case unexpectedStatusCode(got: Int?, expected: Range<Int>)
}

public struct EmptyResponse: Decodable { }

public protocol APIClient {
    func get<Result: Decodable>(
        _ url: URL,
        expectedStatusCodes: Range<Int>
    ) async throws(NetworkError) -> Result
}

public extension APIClient {
    func get<Result: Decodable>(
        _ urlString: String,
        expectedStatusCodes: Range<Int> = 200..<300,
        result: Result.Type = Result.self
    ) async throws(NetworkError) -> Result {
        guard let url = URL(string: urlString) else {
            throw .invalidURL(urlString)
        }

        return try await get(url, expectedStatusCodes: expectedStatusCodes)
    }
}
