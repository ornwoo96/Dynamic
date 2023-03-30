//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

public class GIFOImageView: UIImageView {
    private var animator: GIFOAnimator?
    private var imageView = UIImageView()
    private var previousImage: CGImage?
    private var animationLayer: CALayer?
    private var index = 0
    let queue = DispatchQueue(label: "memoryCleanupQueue", qos: .background)

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
        animator = GIFOAnimator(index: index)
        animator?.delegate = self
        animator?.index = index
        stopAnimation(index: index)
        clearImageView(index: index)
        setupAnimationLayer()
        
        self.index = index
        self.animator?.index = index

        if GIFOImageCache.shared.checkCachedImage(forKey: cacheKey) {
            self.animator?.setupCachedImages(cacheKey: cacheKey) {
                print("\(index)번째 GIF Setup Cached Images 완료")
                animationOnReady?()
            }
        }
        
        Task {
            let image = try await GIFODownloader.fetchImageData(url)
            
            self.animator?.setupForAnimation(data: image,
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
    
    private func setupAnimationLayer() {
        DispatchQueue.main.async { [weak self] in
            self?.animationLayer = nil
            self?.animationLayer?.removeFromSuperlayer()
            let newLayer = CALayer()
            newLayer.frame = self?.bounds ?? CGRect(origin: .zero, size: .zero)
            self?.animationLayer = newLayer
            self?.layer.addSublayer((self?.animationLayer!)!)
        }
    }
    
    public func prepareForReuse() {
        clearImageView(index: index)
    }
    
    public func startAnimation() {
        animator?.startAnimation()
    }
    
    public func stopAnimation(index: Int) {
        animator?.stopAnimation()
        print("\(index) stop 완료")
    }
    
    public func clearImageView(index: Int) {
        self.clearAnimationLayer()
        animator?.clear {
        }
        
    }
    
    private func clearAnimationLayer() {
        
        self.animationLayer?.contents = nil
        self.animationLayer?.removeFromSuperlayer()
        self.animationLayer = nil
        
        guard let bool1 = self.animationLayer?.contents else {
            return
        }
        
        if bool1 as! Bool {
            print("\(self.index)번째캐싱된 메모리가 있네?")
        } else {
            
        }
        
        
    }
}

extension GIFOImageView: GIFOAnimatorImageUpdateDelegate {
    func animationStoped() {
        self.clearImageView(index: index)
    }
    
    func animationImageUpdate(image: UIImage) {
        
//        if ((self.animator?.isPaused) != nil) {
//            return
//        }
        
        self.setNeedsDisplay()
        self.animationLayer?.contents = image.cgImage
    }
}
