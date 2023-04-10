//
//  GIFOImageView+UIImage.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/04/08.
//

import UIKit
/// It displays a GIF animation using `UIImageView.image` and `UIImage.animatedImage`.
extension GIFOImageView {
    /**
     Set up GIF image with UIImage from the image URL. **Tip: Suitable for large amounts of GIF usage.**
        image URL으로 GIF Image 생성 **Tip.많은 양의 GIF 사용 시 적합**
     
     - Parameters:
        - url: The URL of the GIF image.
        - cacheKey: The key to cache the image data.
        - size: The size to resize the image.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready.
    */
    public func setupGIFImageWithUIImage(url: String,
                                         cacheKey: String,
                                         size: CGSize = CGSize(),
                                         level: GIFFrameReduceLevel = .highLevel,
                                         isResizing: Bool = false,
                                         animationOnReady: (() -> Void)? = nil) {
        clearWithUIImage()
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
    
    /**
     Set up GIF image with UIImage from the image data. **Tip: Suitable for large amounts of GIF usage.**
        image Data로 GIF Image 생성 **Tip.많은 양의 GIF 사용 시 적합**
     
     - Parameters:
        - imageData: The data of the GIF image.
        - cacheKey: The key to cache the image data.
        - size: The size to resize the image.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready.
    */
    public func setupGIFImageWithUIImage(imageData: Data,
                                         cacheKey: String,
                                         size: CGSize = CGSize(),
                                         level: GIFFrameReduceLevel = .highLevel,
                                         isResizing: Bool = false,
                                         animationOnReady: (() -> Void)? = nil) {
        checkCachedImageWithUIImage(forKey: cacheKey, animationOnReady: animationOnReady)
        setupForAnimationWithUIImage(imageData: imageData,
                                     cacheKey: cacheKey,
                                     size: size,
                                     level: level,
                                     isResizing: isResizing,
                                     animationOnReady: animationOnReady)
    }
    
    /**
     Set up GIF image with UIImage from the image name. **Tip: Suitable for large amounts of GIF usage.**
        image name으로 GIF Image 생성 **Tip.많은 양의 GIF 사용 시 적합**
     
     - Parameters:
        - imageName: The name of the GIF image.
        - cacheKey: The key to cache the image data.
        - size: The size to resize the image.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready.
    */
    public func setupGIFImageWithUIImage(imageName: String,
                                         cacheKey: String,
                                         size: CGSize = CGSize(),
                                         level: GIFFrameReduceLevel = .highLevel,
                                         isResizing: Bool = false,
                                         animationOnReady: (() -> Void)? = nil) {
        checkCachedImageWithUIImage(forKey: cacheKey, animationOnReady: animationOnReady)
        
        do {
            guard let imageData = try GIFODownloader.getDataFromAsset(named: imageName) else {
                return
            }
            
            setupForAnimationWithUIImage(imageData: imageData,
                                         cacheKey: cacheKey,
                                         size: size,
                                         level: level,
                                         isResizing: isResizing,
                                         animationOnReady: animationOnReady)
        } catch {
            
        }
    }
    
    /**
     This function initializes and frees the memory of the GIF image frames stored in the frameFactory, as well as initializes and releases the memory of the image in the UIImageView.
        이 함수는 frameFactory가 가지고 있는 GIF Image Frame, UIImageView 내부 image 초기화 및 메모리 해제 해주는 함수 입니다.
    */
    public func clearWithUIImage() {
        frameFactory?.clearFactoryWithUIImage {
            DispatchQueue.main.async { [weak self] in
                self?.image = nil
            }
        }
    }
    
    
    ///This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
    /// 이 함수는 FrameFactory 생성, AnimatedImage 를 UIImageView 내부의 image에 주입시키는 작업을 하는 함수입니다.
    ///
    /// - Parameters:
    ///    - imageData: The Data of the GIF image.
    ///    - cacheKey: The key to cache the image data.
    ///    - size: The size to resize the image.
    ///    - level: The level to reduce the number of frames.
    ///    - isResizing: A Boolean value that indicates whether to resize the image.
    ///    - animationOnReady: A block to be called when the animation is ready.
    private func setupForAnimationWithUIImage(imageData: Data,
                                              cacheKey: String,
                                              size: CGSize,
                                              level: GIFFrameReduceLevel,
                                              isResizing: Bool,
                                              animationOnReady: (() -> Void)? = nil) {
        frameFactory = GIFOFrameFactory(data: imageData,
                                        size: size,
                                        isResizing: isResizing)
        
        frameFactory?.getGIFImageWithUIImage(cacheKey: cacheKey,
                                             level: level) { image in
            DispatchQueue.main.async { [weak self] in
                self?.image = nil
                self?.image = image
            }
            animationOnReady?()
        }
    }
    
    
    /// This function checks if a cached image exists, and if a cached GIF image exists, injects it into the image property of a UIImageView.
    /// 이 함수는 캐시 GIF 이미지가 있는지 확인하고 캐시 GIF 이미지가 존재하면 UIImageView에 주입시키는 함수 입니다.
    /// 
    /// - Parameters:
    ///    - cacheKey: The key to cache the image data.
    ///    - animationOnReady: A block to be called when the animation is ready.
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
