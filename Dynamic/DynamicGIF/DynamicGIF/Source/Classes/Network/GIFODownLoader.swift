//
//  GIFODownLoader.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/03/07.
//

import UIKit

enum GIFODownLoaderError: Error {
    case invalidResponse
    case noData
    case invalidURL
    case failedRequest
}

internal class GIFODownloader {
    static func fetchImageData(_ url: String,
                               completion: @escaping (Result<Data, GIFODownLoaderError>) -> Void) {
        guard let stringToURL = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: stringToURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.failedRequest))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let imageData = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(imageData))
        }.resume()
    }
    
    static func getDataFromAsset(named fileName: String) throws -> Data? {
        guard let asset = NSDataAsset(name: fileName) else {
            throw GIFODownLoaderError.noData
        }
        
        return asset.data
    }
    
}
