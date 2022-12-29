//
//  FetchDataService.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/13.
//

import Foundation
import DynamicDomain

public class NetworkManager {
    private var baseURL: BaseURL { .base }
    private var urlSession = URLSession.shared
    
    func request(path: String,
                 parameters: [String: Any],
                 method: Method) async throws -> (GIPHYFromAPIEntity, URLResponse) {
        var urlComponents = URLComponents(string: baseURL.rawValue)
        urlComponents?.path = path
        urlComponents?.queryItems = parameters.map { .init(name: $0, value: $1 as? String) }
        
        guard let url = urlComponents?.url else {
            throw NetworkManagerError.urlError
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = method.rawValue
        
        let (data, urlResponse) = try await urlSession.data(for: requestUrl)
        
        let decodeData = try JSONDecoder().decode(GIPHYFromAPIEntity.self, from: data)
        
        return (decodeData, urlResponse)
    }
    
    public func requestImageData(_ url: String) async throws -> (Data, URLResponse) {
        guard let stringToURL = URL(string: url) else {
            throw NetworkManagerError.urlError
        }
        
        let (data, urlResponse) = try await urlSession.data(from: stringToURL)
        
        return (data, urlResponse)
    }
}

extension NetworkManager {
    enum BaseURL: String {
        case base = "https://api.giphy.com/v1/gifs/"
    }
    
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    enum NetworkManagerError: Error {
        case urlError
        case networkError
        case decodeError
    }
}
