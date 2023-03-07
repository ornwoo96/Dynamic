//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

public class GIFOImageView: UIImageView {
    private var animator = GIFOAnimator()
    
    // Setup - GIF URL
    public func setupGIFImage(url: String,
                              cacheKey: String,
                              size: CGSize = CGSize(),
                              loopCount: Int = 0,
                              contentMode: UIView.ContentMode = .scaleAspectFill,
                              level: GIFFrameReduceLevel = .highLevel,
                              isResizing: Bool = false,
                              animationOnReady: (() -> Void)? = nil) {
        self.clearImage()
        animator.delegate = self
        
        if animator.checkCachingStatus() {
            
            animator.setupCachedImages(animationOnReady: animationOnReady)
            return
        }
        
        Task {
            let image = try await GIFODownloader.fetchImageData(url)

            self.animator.setupForAnimation(data: image,
                                            size: size,
                                            loopCount: loopCount,
                                            contentMode: contentMode,
                                            level: level,
                                            isResizing: isResizing,
                                            cacheKey: cacheKey,
                                            animationOnReady: animationOnReady)
        }
    }
    
    // Setup - GIF Name
    public func setupGIFImage(name: String,
                              cacheKey: String,
                              size: CGSize = CGSize(),
                              loopCount: Int = 0,
                              contentMode: UIView.ContentMode = .scaleAspectFill,
                              level: GIFFrameReduceLevel = .highLevel,
                              isResizing: Bool = false,
                              animationOnReady: (() -> Void)? = nil) {
        animator.delegate = self
        
        if animator.checkCachingStatus() {
            animator.setupCachedImages(animationOnReady: animationOnReady)
            return
        }
        do {
            guard let data = try GIFODownloader.getDataFromAsset(named: name) else {
                return
            }
            
            self.animator.setupForAnimation(data: data,
                                            size: size,
                                            loopCount: loopCount,
                                            contentMode: contentMode,
                                            level: level,
                                            isResizing: isResizing,
                                            cacheKey: cacheKey,
                                            animationOnReady: animationOnReady)
        } catch {
            print("")
        }
    }
    
    // Setup - GIF Data
    public func setupGIFImage(data: Data,
                              cacheKey: String,
                              size: CGSize = CGSize(),
                              loopCount: Int = 0,
                              contentMode: UIView.ContentMode = .scaleAspectFill,
                              level: GIFFrameReduceLevel = .highLevel,
                              isResizing: Bool = false,
                              animationOnReady: (() -> Void)? = nil) {
        animator.delegate = self
        
        if animator.checkCachingStatus() {
            
            animator.setupCachedImages(animationOnReady: animationOnReady)
            return
        }
        
        animator.setupForAnimation(data: data,
                                   size: size,
                                   loopCount: loopCount,
                                   contentMode: contentMode,
                                   level: level,
                                   isResizing: isResizing,
                                   cacheKey: cacheKey,
                                   animationOnReady: animationOnReady)
    }
    
    public func startAnimation() {
        animator.startAnimation()
    }
    
    public func stopAnimation() {
        animator.stopAnimation()
    }
    
    public func clearImageView() {
        DispatchQueue.main.async { [weak self] in
            self?.image = nil
            self?.animator.clear()
        }
    }
    
    private func clearImage() {
        DispatchQueue.main.async { [weak self] in
            self?.image = nil
        }
    }
}

extension GIFOImageView: GIFOAnimatorImageUpdateDelegate {
    func animationImageUpdate(_ image: CGImage) {
        DispatchQueue.main.async { [weak self] in
            self?.image = UIImage(cgImage: image)
        }
    }
}
