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
                                             contentMode: UIView.ContentMode = .scaleAspectFill,
                                             level: GIFFrameReduceLevel = .highLevel,
                                             isResizing: Bool = false,
                                             animationOnReady: (() -> Void)? = nil) {
        clearGIFOFrameData()
        animator = GIFOAnimator()
        animator?.delegate = self
        checkCachedImagesWithGIFOFrame(cacheKey, animationOnReady: animationOnReady)
        
        Task { [weak self] in
            let image = try await GIFODownloader.fetchImageData(url)
            
            self?.animator?.setupForAnimation(data: image,
                                              size: size,
                                              loopCount: loopCount,
                                              contentMode: contentMode,
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
    
    private func clearAnimationLayer() {
        DispatchQueue.main.async { [weak self] in
            self?.layer.setNeedsDisplay()
            self?.layer.contents = nil
            self?.layer.removeFromSuperlayer()
        }
    }
    
    private func checkCachedImagesWithGIFOFrame(_ key: String,
                                                animationOnReady: (() -> Void)? = nil) {
        if GIFOImageCache.shared.checkCachedImageWithGIFOFrame(forKey: key) {
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
                                           loopCount: Int = 0,
                                           contentMode: UIView.ContentMode = .scaleAspectFill,
                                           level: GIFFrameReduceLevel = .highLevel,
                                           isResizing: Bool = false,
                                           animationOnReady: (() -> Void)? = nil) {
        clearGIFOFrameData()
        Task { [weak self] in
            let image = try await GIFODownloader.fetchImageData(url)
            
            self?.frameFactory = GIFOFrameFactory(data: image,
                                                  size: size,
                                                  contentMode: contentMode,
                                                  isResizing: isResizing)
            
            self?.frameFactory?.setupGIFImageFramesWithUIImage(cacheKey: cacheKey,
                                                               level: level) {
                let frames = self?.frameFactory?.animationUIImageFrames
                let duration = self?.frameFactory?.animationTotalDuration
                self?.animationImages = frames
                self?.animationDuration = duration ?? 0.0
                self?.startAnimating()
                animationOnReady?()
            }
        }
    }
    
    private func checkCachedImagesWithUIImage(_ key: String,
                                              animationOnReady: (() -> Void)? = nil) {
        if GIFOImageCache.shared.checkCachedImageWithUIImage(forKey: key) {
            self.animator?.setupCachedImages(cacheKey: key) {
                self.startAnimation()
                animationOnReady?()
            }
        }
    }
    
    public func clearUIImageData() {
        frameFactory?.clearFactoryWithUIImage {
            DispatchQueue.main.async {
                self.animationImages = nil
                self.image = nil
            }
        }
    }
}
