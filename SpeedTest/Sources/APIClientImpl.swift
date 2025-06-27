import CoreInterface
import Foundation

struct APIClientImpl: APIClient {
    var session = URLSession.shared

    private var jsonDecoder: JSONDecoder {
        .init()
    }

    func get<Result: Decodable>(
        _ url: URL,
        expectedStatusCodes: Range<Int>
    ) async throws(NetworkError) -> Result {
        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw UnexpectedStatusCode(got: nil)
            }

            guard expectedStatusCodes.contains(httpResponse.statusCode) else {
                throw UnexpectedStatusCode(got: httpResponse.statusCode)
            }

            return try jsonDecoder.decode(Result.self, from: data)
        } catch let error as DecodingError {
            throw .decoding(error)
        } catch let error as UnexpectedStatusCode {
            throw .unexpectedStatusCode(got: error.got, expected: expectedStatusCodes)
        } catch {
            throw .network(error)
        }
    }

    private struct UnexpectedStatusCode: Error {
        let got: Int?
    }
}
