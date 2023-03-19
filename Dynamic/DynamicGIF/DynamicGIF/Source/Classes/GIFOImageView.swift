//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

public class GIFOImageView: UIView {
    private var animator: GIFOAnimator = GIFOAnimator(index: 0)
    private var animationContainerLayer = CALayer()
    private var animationLayer = CALayer()
    private var previousImage: CGImage?
    
    // Setup - GIF URL
    public func setupGIFImage(index: Int,
                              url: String,
                              cacheKey: String,
                              size: CGSize = CGSize(),
                              loopCount: Int = 0,
                              contentMode: UIView.ContentMode = .scaleAspectFill,
                              level: GIFFrameReduceLevel = .highLevel,
                              isResizing: Bool = false,
                              animationOnReady: (() -> Void)? = nil) {
        clearImageView(index: index)
        animator.delegate = self
        animator.index = index
        setupAnimationLayer()

        if GIFOImageCache.shared.checkCachedImage(forKey: cacheKey) {
            self.animator.setupCachedImages(cacheKey: cacheKey) {
                print("\(index)번째 GIF Setup Cached Images 완료")
                animationOnReady?()
            }
        }
        
        Task {
            let image = try await GIFODownloader.fetchImageData(url)
            
            self.animator.setupForAnimation(data: image,
                                            size: size,
                                            loopCount: loopCount,
                                            contentMode: contentMode,
                                            level: level,
                                            isResizing: isResizing,
                                            cacheKey: cacheKey) {
                print("\(index)번째 GIF create and setup 완료")
                self.startAnimation()
                print("\(index)번째 GIF Animation func 실행")
                animationOnReady?()
            }
        }
    }
    
    // Setup - GIF Name
//    public func setupGIFImage(name: String,
//                              cacheKey: String,
//                              size: CGSize = CGSize(),
//                              loopCount: Int = 0,
//                              contentMode: UIView.ContentMode = .scaleAspectFill,
//                              level: GIFFrameReduceLevel = .highLevel,
//                              isResizing: Bool = false,
//                              animationOnReady: (() -> Void)? = nil) {
//        animator.delegate = self
//
//        if animator.checkCachingStatus() {
//            animator.setupCachedImages(animationOnReady: animationOnReady)
//            return
//        }
//
//        do {
//            guard let data = try GIFODownloader.getDataFromAsset(named: name) else {
//                return
//            }
//
//            self.animator.setupForAnimation(data: data,
//                                            size: size,
//                                            loopCount: loopCount,
//                                            contentMode: contentMode,
//                                            level: level,
//                                            isResizing: isResizing,
//                                            cacheKey: cacheKey,
//                                            animationOnReady: animationOnReady)
//        } catch {
//            print("")
//        }
//    }
//
//    // Setup - GIF Data
//    public func setupGIFImage(data: Data,
//                              cacheKey: String,
//                              size: CGSize = CGSize(),
//                              loopCount: Int = 0,
//                              contentMode: UIView.ContentMode = .scaleAspectFill,
//                              level: GIFFrameReduceLevel = .highLevel,
//                              isResizing: Bool = false,
//                              animationOnReady: (() -> Void)? = nil) {
//        animator.delegate = self
//
//        if animator.checkCachingStatus() {
//
//            animator.setupCachedImages(animationOnReady: animationOnReady)
//            return
//        }
//
//        animator.setupForAnimation(data: data,
//                                   size: size,
//                                   loopCount: loopCount,
//                                   contentMode: contentMode,
//                                   level: level,
//                                   isResizing: isResizing,
//                                   cacheKey: cacheKey,
//                                   animationOnReady: animationOnReady)
//    }
    
    public func prepareForReuse() {
        
    }
    
    public func startAnimation() {
        animator.startAnimation()
    }
    
    public func stopAnimation(index: Int) {
        animator.stopAnimation()
        print("\(index) stop 완료")
    }
    
    public func clearImageView(index: Int) {
        animator.clear()
        print("\(index)번째 GIF ImageView clear")
    }
    
    private func setupAnimationLayer() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            self?.animationContainerLayer.frame = strongSelf.bounds
            self?.animationContainerLayer.backgroundColor = .init(red: 0, green: 0, blue: 1, alpha: 0.5)
            self?.layer.addSublayer(strongSelf.animationContainerLayer)
            
            self?.animationLayer.frame = strongSelf.bounds
            self?.animationContainerLayer.addSublayer(strongSelf.animationLayer)
        }
    }
}

extension GIFOImageView: GIFOAnimatorImageUpdateDelegate {
    func animationImageUpdate(_ image: CGImage) {
        DispatchQueue.main.async { [weak self] in
            //            self?.animationLayer.contents = nil
            //
            //            self?.animationLayer.setNeedsDisplay()
            //
            //            self?.animationLayer.contents = image
            
            guard let self = self else { return }
            
            // Create a new CALayer
            let newLayer = CALayer()
            newLayer.frame = self.frame
            newLayer.contentsGravity = .resizeAspect
            newLayer.contentsScale = UIScreen.main.scale
//            newLayer.contents = image
            
            // Add the new CALayer and remove the old one
            self.animationContainerLayer.addSublayer(newLayer)
            self.animationLayer.removeFromSuperlayer()
            self.animationLayer = newLayer
            
            // Set the new layer to display immediately
            self.animationContainerLayer.displayIfNeeded()
        }
    }
}
