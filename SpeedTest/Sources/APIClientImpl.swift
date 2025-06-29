import CoreInterface
import Foundation

struct APIClientImpl: APIClient {
    var session = URLSession(configuration: .ephemeral)

    private var jsonDecoder: JSONDecoder {
        .init()
    }

    func data(from url: URL) async throws(NetworkError) -> Data {
        do {
            return try await session.data(from: url).0
        } catch {
            throw .network(error)
        }
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

    func post<Result>(
        _ url: URL,
        body: Data?,
        expectedStatusCodes: Range<Int>
    ) async throws(NetworkError) -> Result where Result : Decodable {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            let (data, response) = try await session.data(for: request)

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
