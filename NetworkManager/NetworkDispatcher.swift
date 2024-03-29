//
//  NetworkDispatcher.swift
//  NetworkManager
//
//  Created by Oko-osi Korede on 20/03/2024.
//

import Combine
struct NetworkDispatcher {
    
    // MARK: - Properties
    
    private let urlSession: URLSession!
    
    // MARK: - Initializer
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Dispatches a URLRequest and returns a publisher
    /// - Parameter request: URLRequest
    /// - Returns: A publisher with the provided decoded data or an error
    func dispatch<ReturnType: Codable>(request: URLRequest) async -> Result<ReturnType, NetworkRequestError> {
        //Log Request
        do {
                // Perform the network request asynchronously
            let (data, response) = try await self.urlSession.data(for: request)
                
                // Check if the response is valid
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    return .failure(.invalidRequest)
                }
                
                // Decode the JSON response
                let decoder = JSONDecoder()
                let result = try decoder.decode(ReturnType.self, from: data)
                return .success(result)
            } catch {
                // Handle request failure or decoding error
                return .failure(.serverError)
            }
    }
}

// MARK: - Helpers

extension NetworkDispatcher {
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    /// Parses URLSession Publisher errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}
