//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

public class GIFOImageView: UIImageView {
    private var animator: GIFOAnimator?
    private var animationLayer: CALayer?
    private var frameFactory: GIFOFrameFactory?
    
    // Setup - GIF URL
    public func setupGIFImageWithDisplayLink(url: String,
                                             cacheKey: String,
                                             size: CGSize = CGSize(),
                                             loopCount: Int = 0,
                                             level: GIFFrameReduceLevel = .highLevel,
                                             isResizing: Bool = false,
                                             animationOnReady: (() -> Void)? = nil) {
        clearGIFOFrameData()
        animator = GIFOAnimator()
        animator?.delegate = self
        checkCachedImages(.GIFFrame,
                          cacheKey,
                          animationOnReady: animationOnReady)
        
        Task { [weak self] in
            let image = try await GIFODownloader.fetchImageData(url)
            
            self?.animator?.setupForAnimation(data: image,
                                              size: size,
                                              loopCount: loopCount,
                                              level: level,
                                              isResizing: isResizing,
                                              cacheKey: cacheKey) {
                self?.startAnimation()
                animationOnReady?()
            }
        }
    }
    
    
    public func startAnimation() {
        animator?.startAnimation()
    }
    
    public func stopAnimation() {
        animator?.stopAnimation()
    }
    
    public func clearGIFOFrameData() {
        animator?.clear { [weak self] in
            self?.clearAnimationLayer()
        }
    }
    
    public func prepareForReuse() {
        DispatchQueue.main.async {
            self.image = nil
        }
    }
    
    private func clearAnimationLayer() {
        DispatchQueue.main.async { [weak self] in
            self?.layer.setNeedsDisplay()
            self?.layer.contents = nil
            self?.layer.removeFromSuperlayer()
        }
    }
    
    private func checkCachedImages(_ type: GIFOImageCacheManager.CacheType,
                                   _ key: String,
                                   animationOnReady: (() -> Void)? = nil) {
        if GIFOImageCacheManager.shared.checkCachedImage(type,forKey: key) {
            self.animator?.setupCachedImages(cacheKey: key) {
                self.startAnimation()
                animationOnReady?()
            }
        }
    }
}

extension GIFOImageView: GIFOAnimatorImageUpdateDelegate {
    func animationImageUpdate(image: UIImage) {
        self.layer.setNeedsDisplay()
        self.layer.contents = image.cgImage
    }
}

extension GIFOImageView {
    public func setupGIFImageWithAnimation(url: String,
                                           cacheKey: String,
                                           size: CGSize = CGSize(),
                                           level: GIFFrameReduceLevel = .highLevel,
                                           isResizing: Bool = false,
                                           animationOnReady: (() -> Void)? = nil) {
        clearGIFOFrameData()
        
        if let image = GIFOImageCacheManager.shared.getGIFUIImage(forKey: cacheKey) {
            DispatchQueue.main.async { [weak self] in
                self?.image = nil
                self?.image = image
            }
            animationOnReady?()
            return
        }
        
        Task { [weak self] in
            let image = try await GIFODownloader.fetchImageData(url)
            
            self?.frameFactory = GIFOFrameFactory(data: image,
                                                  size: size,
                                                  isResizing: isResizing)
            
            self?.frameFactory?.setupGIFImageFramesWithUIImage(cacheKey: cacheKey,
                                                               level: level) { [weak self] image in
                DispatchQueue.main.async {
                    self?.image = nil
                    self?.image = image
                }
                animationOnReady?()
            }
        }
    }
    
    public func clearUIImageData() {
        frameFactory?.clearFactoryWithUIImage {
            DispatchQueue.main.async {
                self.image = nil
            }
        }
    }
}
