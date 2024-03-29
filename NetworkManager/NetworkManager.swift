//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Oko-osi Korede on 20/03/2024.
//

import Foundation

public class NetworkManager {
    public let shared = NetworkManager()
    
    private init() { }
    
    
    public func performRequest<T: Codable>(endpoint: String,
                                           apiMethod: HTTPMethod = .GET) async -> Result<T?, NetworkRequestError> {
        
        return .success(nil)
    }
}
