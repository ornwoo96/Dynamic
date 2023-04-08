//
//  GIFOImageView+UIImage.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/04/08.
//

import UIKit

extension GIFOImageView {
    public func setupGIFImageWithUIImage(url: String,
                                         cacheKey: String,
                                         size: CGSize = CGSize(),
                                         level: GIFFrameReduceLevel = .highLevel,
                                         isResizing: Bool = false,
                                         animationOnReady: (() -> Void)? = nil) {
        clearDataWithUIImage()
        checkCachedImageWithUIImage(forKey: cacheKey, animationOnReady: animationOnReady)
        
        GIFODownloader.fetchImageData(url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.setupForAnimationWithUIImage(imageData: imageData,
                                                   cacheKey: cacheKey,
                                                   size: size,
                                                   level: level,
                                                   isResizing: isResizing,
                                                   animationOnReady: animationOnReady)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func setupForAnimationWithUIImage(imageData: Data,
                                              cacheKey: String,
                                              size: CGSize,
                                              level: GIFFrameReduceLevel,
                                              isResizing: Bool,
                                              animationOnReady: (() -> Void)? = nil) {
        self.frameFactory = GIFOFrameFactory(data: imageData,
                                              size: size,
                                              isResizing: isResizing)
        
        self.frameFactory?.getGIFImageWithUIImage(cacheKey: cacheKey,
                                                   level: level) { image in
            DispatchQueue.main.async { [weak self] in
                self?.image = nil
                self?.image = image
            }
            animationOnReady?()
        }
    }
    
    public func prepareForReuse() {
        DispatchQueue.main.async { [weak self] in
            self?.image = nil
        }
    }
    
    public func clearDataWithUIImage() {
        frameFactory?.clearFactoryWithUIImage {
            DispatchQueue.main.async { [weak self] in
                self?.image = nil
            }
        }
    }
    
    private func checkCachedImageWithUIImage(forKey cacheKey: String,
                                             animationOnReady: (() -> Void)? = nil) {
        if let image = GIFOImageCacheManager.shared.getGIFUIImage(forKey: cacheKey) {
            DispatchQueue.main.async { [weak self] in
                self?.image = nil
                self?.image = image
            }
            animationOnReady?()
        }
    }
}
