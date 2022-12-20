//
//  ImageCacheRepository.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import DynamicDomain

public class DefaultImageCacheRepository: ImageCacheRepository {
    private let manager: NetworkManager
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    public func imageLoad(_ url: String) async throws -> Data {
        if let cachedImage = matchImage(url) {
            return cachedImage
        }
        let data = try await manager.fetchImageData(url)
        
        guard let nsUrl = NSURL(string: url) else { return Data() }
        let nsData = NSData(data: data)
        ImageCacheManager.shared.setObject(nsData, forKey: nsUrl)
        
        return data
    }
    
    private func matchImage(_ url: String) -> Data? {
        guard let nsUrl = NSURL(string: url) else {
            return nil
        }
        
        guard let nsData = ImageCacheManager.shared.object(forKey: nsUrl) else {
            return nil
        }
        
        return Data(referencing: nsData)
    }
}
