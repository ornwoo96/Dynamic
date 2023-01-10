//
//  FetchDataService.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/13.
//

import Foundation
import DynamicDomain

public class NetworkManager {
    private var baseURL: BaseURL { .GIPHYBase }
    private var urlSession = URLSession.shared
    
    public init() {}
    
    public func request(path: String,
                        parameters: [String: Any],
                        method: Method) async throws -> (Data, URLResponse) {
        var urlComponents = URLComponents(string: baseURL.rawValue)
        urlComponents?.path = path
        urlComponents?.queryItems = parameters.map { .init(name: $0, value: $1 as? String) }
        
        guard let url = urlComponents?.url else {
            throw NetworkManagerError.urlError
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = method.rawValue
        
        let (data, urlResponse) = try await urlSession.data(for: requestUrl)
        
        return (data, urlResponse)
    }
}

extension NetworkManager {
    public enum BaseURL: String {
        case GIPHYBase = "https://api.giphy.com/v1/gifs/"
    }
    
    public enum Method: String {
        case post = "POST"
        case get = "GET"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    public enum NetworkManagerError: Error {
        case urlError
        case networkError
        case decodeError
    }
}
