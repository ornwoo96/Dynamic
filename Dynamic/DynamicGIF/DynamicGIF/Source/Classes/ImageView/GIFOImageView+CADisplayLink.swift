//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit
/// It displays high-quality GIF images using `CADisplayLink`.
public class GIFOImageView: UIImageView {
    
    /// An object that holds a CADisplayLink.
    private var animator: GIFOAnimator?
    
    /// An object that creates the required GIF frames.
    internal var frameFactory: GIFOFrameFactory?
    
    /**
     Set up GIF image with  `CADisplayLink` from the image URL.  **Tip: It is suitable for displaying high-quality images.**
        이미지 URL,  `CADisplayLink` 와 함께 GIF 이미지를 설정합니다.  **Tip: 고품질의 GIF 이미지를 표시할 때 적합합니다.**
     
     - Parameters:
        - url: The URL of the GIF image.
        - cacheKey: The key to cache the image data.
        - isCache: A Boolean value that indicates whether to cache the image data. The default value is true.
        - size: A CGSize object to resize the image. The default value is CGSize().
        - loopCount: The number of times the animation should be repeated. 0 means infinite. The default value is 0.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready. The default value is nil.
    */
    public func setupGIFImageWithDisplayLink(url: String,
                                             cacheKey: String,
                                             isCache: Bool = true,
                                             size: CGSize = CGSize(),
                                             loopCount: Int = 0,
                                             level: GIFFrameReduceLevel = .highLevel,
                                             isResizing: Bool = false,
                                             animationOnReady: (() -> Void)? = nil) {
        createAnimator()

        checkCachedImages(.GIFFrame,
                          cacheKey,
                          animationOnReady: animationOnReady)
        
        GIFODownloader.fetchImageData(url) { result in
            switch result {
            case .success(let imageData):
                self.setupForAnimationWithDisplayLink(imageData: imageData,
                                                      cacheKey: cacheKey,
                                                      isCache: isCache,
                                                      size: size,
                                                      loopCount: loopCount,
                                                      level: level,
                                                      isResizing: isResizing,
                                                      animationOnReady: animationOnReady)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Set up GIF image with `CADisplayLink` from the image Data. **Tip: It is suitable for displaying high-quality images.**
        이미지 Data, `CADisplayLink` 와 함께 GIF 이미지를 설정합니다. **Tip: 고품질의 GIF 이미지를 표시할 때 적합합니다.**
     
     - Parameters:
        - data: The Data of the GIF image.
        - cacheKey: The key to cache the image data.
        - isCache: A Boolean value that indicates whether to cache the image data. The default value is true.
        - size: A CGSize object to resize the image. The default value is CGSize().
        - loopCount: The number of times the animation should be repeated. 0 means infinite. The default value is 0.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready. The default value is nil.
    */
    public func setupGIFImageWithDisplayLink(imageData: Data,
                                             cacheKey: String,
                                             isCache: Bool = true,
                                             size: CGSize = CGSize(),
                                             loopCount: Int = 0,
                                             level: GIFFrameReduceLevel = .highLevel,
                                             isResizing: Bool = false,
                                             animationOnReady: (() -> Void)? = nil) {
        createAnimator()
        
        checkCachedImages(.GIFFrame,
                          cacheKey,
                          animationOnReady: animationOnReady)
        
        setupForAnimationWithDisplayLink(imageData: imageData,
                                         cacheKey: cacheKey,
                                         isCache: isCache,
                                         size: size,
                                         loopCount: loopCount,
                                         level: level,
                                         isResizing: isResizing,
                                         animationOnReady: animationOnReady)
    }
    
    /**
     Set up GIF image with `CADisplayLink` from the image Name. **Tip: It is suitable for displaying high-quality images.**
        이미지 name, `CADisplayLink` 와 함께 GIF 이미지를 설정합니다. **Tip: 고품질의 GIF 이미지를 표시할 때 적합합니다.**

     - Parameters:
        - imageName: The Name of the GIF image.
        - cacheKey: The key to cache the image data.
        - isCache: A Boolean value that indicates whether to cache the image data. The default value is true.
        - size: A CGSize object to resize the image. The default value is CGSize().
        - loopCount: The number of times the animation should be repeated. 0 means infinite. The default value is 0.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready. The default value is nil.
    */
    public func setupGIFImageWithDisplayLink(imageName: String,
                                             cacheKey: String,
                                             isCache: Bool = true,
                                             size: CGSize = CGSize(),
                                             loopCount: Int = 0,
                                             level: GIFFrameReduceLevel = .highLevel,
                                             isResizing: Bool = false,
                                             animationOnReady: (() -> Void)? = nil) {
        createAnimator()

        checkCachedImages(.GIFFrame,
                          cacheKey,
                          animationOnReady: animationOnReady)
        do {
            guard let imageData = try GIFODownloader.getDataFromAsset(named: imageName) else {
                print("이미지를 찾을 수 없어요")
                return
            }
            
            setupForAnimationWithDisplayLink(imageData: imageData,
                                             cacheKey: cacheKey,
                                             isCache: isCache,
                                             size: size,
                                             loopCount: loopCount,
                                             level: level,
                                             isResizing: isResizing,
                                             animationOnReady: animationOnReady)
        } catch {
            print("이미지 불러오기 실패")
        }
    }
    
    /**
    This function is used to create a FrameFactory object and inject an AnimatedImage into the image property of a UIImageView.
    */
    public func startAnimationWithDisplayLink() {
        animator?.startAnimation()
    }
    
    /**
     This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
        이 함수는 FrameFactory 생성, AnimatedImage 를 UIImageView 내부의 image에 주입시키는 작업을 하는 함수입니다.
    */
    public func stopAnimationWithDisplayLink() {
        animator?.stopAnimation()
    }
    
    /**
     This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
        이 함수는 FrameFactory 생성, AnimatedImage 를 UIImageView 내부의 image에 주입시키는 작업을 하는 함수입니다.
    */
    public func clearWithDisplayLink() {
        animator?.clear { [weak self] in
            self?.clearAnimationLayer()
        }
    }
    
    /// This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
    ///    이 함수는 FrameFactory 생성, AnimatedImage 를 UIImageView 내부의 image에 주입시키는 작업을 하는 함수입니다.
    private func createAnimator() {
        clearWithDisplayLink()
        animator = GIFOAnimator()
        animator?.delegate = self
    }
    
    /**
     This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
        이 함수는 FrameFactory 생성, AnimatedImage 를 UIImageView 내부의 image에 주입시키는 작업을 하는 함수입니다.
     - Parameters:
        - imageData: The Data of the GIF image.
        - cacheKey: The key to cache the image data.
        - size: The size to resize the image.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready.
    */
    private func setupForAnimationWithDisplayLink(imageData: Data,
                                                  cacheKey: String,
                                                  isCache: Bool,
                                                  size: CGSize = CGSize(),
                                                  loopCount: Int = 0,
                                                  level: GIFFrameReduceLevel = .highLevel,
                                                  isResizing: Bool = false,
                                                  animationOnReady: (() -> Void)? = nil) {
        animator?.setupForAnimation(data: imageData,
                                    size: size,
                                    loopCount: loopCount,
                                    level: level,
                                    isResizing: isResizing,
                                    cacheKey: cacheKey,
                                    isCache: isCache) {
            self.animator?.startAnimation()
            animationOnReady?()
        }
    }
    
    /**
     This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
        이 함수는 FrameFactory 생성, AnimatedImage 를 UIImageView 내부의 image에 주입시키는 작업을 하는 함수입니다.
    */
    private func clearAnimationLayer() {
        DispatchQueue.main.async { [weak self] in
            self?.layer.setNeedsDisplay()
            self?.layer.contents = nil
        }
    }
    
    /// This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
    ///    이 함수는 FrameFactory 생성, AnimatedImage 를 UIImageView 내부의 image에 주입시키는 작업을 하는 함수입니다.
    ///
    /// - Parameters:
    ///    - imageData: The Data of the GIF image.
    ///    - key: The key to cache the image data.
    ///    - animationOnReady: A block to be called when the animation is ready.
    private func checkCachedImages(_ type: GIFOImageCacheManager.CacheType,
                                   _ key: String,
                                   animationOnReady: (() -> Void)? = nil) {
        if GIFOImageCacheManager.shared.checkCachedImage(type,forKey: key) {
            self.animator?.setupCachedImages(cacheKey: key) {
                self.startAnimationWithDisplayLink()
                animationOnReady?()
            }
        }
    }
}

extension GIFOImageView: GIFOAnimatorImageUpdateDelegate {
    /// This function creates a FrameFactory object and injects an AnimatedImage into the image property of a UIImageView.
    ///
    /// - Parameter image: The delegated Image
    func animationImageUpdate(image: UIImage) {
        self.layer.setNeedsDisplay()
        self.layer.contents = image.cgImage
    }
}
