//
//  FetchDataService.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/13.
//

import Foundation

import Combine

public class NetworkManager {
    public func fetchGIPHYDatas() async throws -> GiphyImageEntity {
        let randomImageURL = "https://api.giphy.com/v1/gifs/search?api_key=fUyNy20JVfRpEHP0UJEAJQk8mT3hyv4H&q=coding&limit=40&offset=0&rating=g&lang=en"
        guard let stringToURL = URL(string: randomImageURL) else {
            return GiphyImageEntity.empty
        }
        let (data, _ ) = try await URLSession.shared.data(from: stringToURL)
        let decodeData = try JSONDecoder().decode(GIPHYFromAPIEntity.self, from: data)
        
        return decodeData.convertGiphyImageEntity()
    }
    
    public func fetchImageData(_ url: String) async throws -> Data {
        guard let stringToURL = URL(string: url) else { return Data() }
        
        let (data, _) = try await URLSession.shared.data(from: stringToURL)
        
        return data
    }
}

extension NetworkManager {
    enum BaseURL: String {
        case base = ""
    }
}
