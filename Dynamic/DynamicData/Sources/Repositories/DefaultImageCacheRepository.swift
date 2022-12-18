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
    private let coreDataManager: CoreDataManagerRepository
    
    init(manager: NetworkManager,
         coreDataManager: CoreDataManagerRepository) {
        self.manager = manager
        self.coreDataManager = coreDataManager
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
    
    public func imageLoad(_ url: String,
                          _ id: String) async throws -> (Data, Bool) {
        
        let bool = try await coreDataManager.checkGIFImageDataIsExist(id)
        
        if let cachedImage = matchImage(url) {
            return (cachedImage, bool)
        }
        let data = try await manager.fetchImageData(url)
        
        guard let nsUrl = NSURL(string: url) else { return (Data(), false) }
        let nsData = NSData(data: data)
        ImageCacheManager.shared.setObject(nsData, forKey: nsUrl)
        
        return (data, bool)
    }
}
