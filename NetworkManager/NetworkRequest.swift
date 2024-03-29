//
//  NetworkRequest.swift
//  NetworkManager
//
//  Created by Oko-osi Korede on 20/03/2024.
//

import Foundation
public protocol Request {
    associatedtype ReturnType: Codable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var queryParams: [String: String]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
}

/// Sets default values for the properties
extension Request {
    
    var method: HTTPMethod { return .GET }
    var contentType: String { return "application/json" }
    var queryParams: [String: String]? { return nil }
    var body: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
}

extension Request {
    /// Serializes an HTTP dictionary to a JSON Data Object
    /// - Parameter params: HTTP Parameters dictionary
    /// - Returns: Encoded JSON
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    /// Transforms a disctionary to QueryParams
    /// - Parameter queryParams: Query Parameters Dictionary
    /// - Returns: Transformed QueryParams
    func addQueryItems(queryParams: [String: Any]?) -> [URLQueryItem]? {
        guard let queryParams = queryParams else {
            return nil
        }
        return queryParams.map({URLQueryItem(name: $0.key, value: "\($0.value)")})
    }
    
    /// Transforms a Request into a standard URL request
    /// - Parameter baseURL: API Base URL to be used
    /// - Returns: A ready to use URLRequest
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headers
        
        /// Set your Common Headers here
        /// Like: api secret key for authorization header
        /// Or set your content type
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.setValue("*/*", forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        return request
    }
}
