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
    internal var frameFactory: GIFOFrameFactory?
    
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
        
        GIFODownloader.fetchImageData(url) { result in
            switch result {
            case .success(let imageData):
                self.setupForAnimationWithDisplayLink(imageData: imageData,
                                                      cacheKey: cacheKey,
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
    
    private func setupForAnimationWithDisplayLink(imageData: Data,
                                                  cacheKey: String,
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
                                    cacheKey: cacheKey) {
            self.animator?.startAnimation()
            animationOnReady?()
        }
    }
    
    
    public func startAnimationWithDisplayLink() {
        animator?.startAnimation()
    }
    
    public func stopAnimationWithDisplayLink() {
        animator?.stopAnimation()
    }
    
    public func clearGIFOFrameData() {
        animator?.clear { [weak self] in
            self?.clearAnimationLayer()
        }
    }
    
    private func clearAnimationLayer() {
        DispatchQueue.main.async { [weak self] in
            self?.layer.setNeedsDisplay()
            self?.layer.contents = nil
        }
    }
    
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
    func animationImageUpdate(image: UIImage) {
        self.layer.setNeedsDisplay()
        self.layer.contents = image.cgImage
    }
}
