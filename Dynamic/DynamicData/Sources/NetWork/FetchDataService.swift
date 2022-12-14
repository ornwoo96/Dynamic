//
//  FetchDataService.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/13.
//

import Foundation

import Combine

public class FetchDataService {
    
    let 
    
    func fetchImageEntity() {
        
        Task {
            do {
                let data = try await fetchGIFImage()
            } catch {
                print("디코딩 실패")
            }
            
            
        }
    }
    
    
    private func fetchGIFImage() async throws -> GiphyImageEntity {
        let randomImageURL = "https://api.giphy.com/v1/gifs/search?api_key=fUyNy20JVfRpEHP0UJEAJQk8mT3hyv4H&q=coding&limit=10&offset=0&rating=g&lang=en"
        guard let stringToURL = URL(string: randomImageURL) else {
            return GiphyImageEntity.empty
        }
        let (data, _ ) = try await URLSession.shared.data(from: stringToURL)
        let decodeData = try JSONDecoder().decode(GIPHYDataFromAPI.self, from: data)
        
        return decodeData.convertGiphyImageEntity()
    }
}
