//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit
/// GIFOAnimator
public class GIFOImageView: UIImageView {
    private var animator: GIFOAnimator?
    private var animationLayer: CALayer?
    internal var frameFactory: GIFOFrameFactory?
    
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
    public func startAnimationWithDisplayLink() {
        animator?.startAnimation()
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
    public func stopAnimationWithDisplayLink() {
        animator?.stopAnimation()
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
    public func clearWithDisplayLink() {
        animator?.clear { [weak self] in
            self?.clearAnimationLayer()
        }
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
     - Parameters:
        - imageData: The Data of the GIF image.
        - cacheKey: The key to cache the image data.
        - size: The size to resize the image.
        - level: The level to reduce the number of frames.
        - isResizing: A Boolean value that indicates whether to resize the image.
        - animationOnReady: A block to be called when the animation is ready.
    */
    private func clearAnimationLayer() {
        DispatchQueue.main.async { [weak self] in
            self?.layer.setNeedsDisplay()
            self?.layer.contents = nil
        }
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
    func animationImageUpdate(image: UIImage) {
        self.layer.setNeedsDisplay()
        self.layer.contents = image.cgImage
    }
}
