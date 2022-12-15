//
//  ImageCacheRepository.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import DynamicDomain

// MARK: 이미지 캐싱 알고리즘 이미지 요청 -> 이미지 cache에서 같은 이미지 데이터 찾기
// MARK: 있을시 ->
// MARK: 없을시 ->

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
