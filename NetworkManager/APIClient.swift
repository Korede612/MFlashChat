//
//  APIClient.swift
//  NetworkManager
//
//  Created by Oko-osi Korede on 20/03/2024.
//

import Foundation
import Combine

struct APIClient {
    
    // MARK: - Properties
    
    var baseURL: String!
    var networkDispatcher: NetworkDispatcher!
    
    // MARK: - Initializer
    
    init(baseURL: String = BuildConfiguration.shared.baseURL,
         networkDispatcher: NetworkDispatcher = NetworkDispatcher()
    ) {
        self.baseURL = baseURL
        self.networkDispatcher = networkDispatcher
    }
    
    /// Dispatches a Request and returns a publisher
    /// - Parameter request: Request to Dispatch
    /// - Returns: A publisher containing decoded data or an error
    func dispatch<R: Request>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(
                outputType: R.ReturnType.self,
                failure: NetworkRequestError.badRequest).eraseToAnyPublisher()
        }
        typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>
        let requestPublisher: RequestPublisher = networkDispatcher.dispatch(request: urlRequest)
        return requestPublisher.eraseToAnyPublisher()
    }
}
