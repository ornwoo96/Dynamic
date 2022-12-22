//
//  ImageCacheManager.swift
//  DynamicCore
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation

public enum ImageDownloadError: String, Error {
    case invalidServerResponse = "invalidServerResponse"
}

public final class ImageCacheManager {
    public static let shared: ImageCacheManager = .init()
    
    private let cachedImages = NSCache<NSURL, NSData>()
    
    private func matchImage(_ url: String) -> Data? {
        guard let nsUrl = NSURL(string: url) else {
            return nil
        }
        
        guard let nsData = cachedImages.object(forKey: nsUrl) else {
            return nil
        }
        
        return Data(referencing: nsData)
    }
    
    public func imageLoad(_ url: String) async throws -> Data {
        if let cachedImage = matchImage(url) {
            return cachedImage
        }
        
        let data = try await self.fetchImageData(url)
        
        guard let nsUrl = NSURL(string: url) else { return Data() }
        let nsData = NSData(data: data)
        cachedImages.setObject(nsData, forKey: nsUrl)
        
        return data
    }
    
    private func fetchImageData(_ url: String) async throws -> Data {
        guard let stringToURL = URL(string: url) else {
            return Data()
        }
        
        let (data, response) = try await URLSession.shared.data(from: stringToURL)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw ImageDownloadError.invalidServerResponse
        }
        
        return data
    }
}
