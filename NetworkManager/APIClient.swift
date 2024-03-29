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
    
    func dispatch<R: Request>(_ request: R) -> AnyPublisher<R.ReturnType?, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: baseURL) else {
            return Fail(outputType: R.ReturnType?.self, failure: NetworkRequestError.badRequest)
                .eraseToAnyPublisher()
        }
        
        return Future<R.ReturnType?, NetworkRequestError> { promise in
            Task.init {
                    let result: Result<R.ReturnType, NetworkRequestError> = await networkDispatcher.dispatch(request: urlRequest)
                    promise(.success(result as? R.ReturnType))
            }
        }
        .eraseToAnyPublisher()
    }
}
