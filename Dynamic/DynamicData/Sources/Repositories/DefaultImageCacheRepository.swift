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
    
    private func matchImage(_ url: String) -> Data? {
        guard let nsUrl = NSURL(string: url) else {
            return nil
        }
        
        guard let nsData = ImageCacheManager.shared.object(forKey: nsUrl) else {
            return nil
        }
        
        return Data(referencing: nsData)
    }
    
    public func imageLoad(_ url: String) async throws -> Data {
        // MARK: 코어 데이터에 이미지가 있을 경우 -> true
        // MARK: 코어 데이터에 이미지가 없을 경우 -> false
        
        
        
        
        // MARK: 저장된 이미지가 있을경우
        if let cachedImage = matchImage(url) {
            return cachedImage
        }
        
        // MARK: 저장된 이미지가 없을 경우
        let data = try await manager.fetchImageData(url)
        
        guard let nsUrl = NSURL(string: url) else { return Data() }
        let nsData = NSData(data: data)
        ImageCacheManager.shared.setObject(nsData, forKey: nsUrl)
        
        return data
    }
}
