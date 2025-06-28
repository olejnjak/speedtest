import Foundation

public enum NetworkError: Error {
    case invalidURL(String)
    case network(Error)
    case decoding(DecodingError)
    case encoding(EncodingError)
    case unexpectedStatusCode(got: Int?, expected: Range<Int>)
}

public struct EmptyResponse: Decodable { }

public protocol APIClient {
    func data(from url: URL) async throws(NetworkError) -> Data

    func get<Result: Decodable>(
        _ url: URL,
        expectedStatusCodes: Range<Int>
    ) async throws(NetworkError) -> Result

    func post<Result: Decodable>(
        _ url: URL,
        body: Data?,
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

    func post<Payload: Encodable, Result: Decodable>(
        _ urlString: String,
        body: Payload,
        encoder: JSONEncoder = .init(),
        expectedStatusCodes: Range<Int> = 200..<300
    ) async throws(NetworkError) -> Result {
        guard let url = URL(string: urlString) else {
            throw .invalidURL(urlString)
        }

        do {
            let data = try encoder.encode(body)

            return try await post(
                url,
                body: data,
                expectedStatusCodes: expectedStatusCodes
            )
        } catch let error as EncodingError {
            throw .encoding(error)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw .network(error)
        }
    }

    func post<Result: Decodable>(
        _ urlString: String,
        encoder: JSONEncoder = .init(),
        expectedStatusCodes: Range<Int> = 200..<300,
        result: Result.Type = Result.self
    ) async throws(NetworkError) -> Result {
        guard let url = URL(string: urlString) else {
            throw .invalidURL(urlString)
        }

        return try await post(
            url,
            body: nil,
            expectedStatusCodes: expectedStatusCodes
        )
    }
}
