//
//  GIFAnimator.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/11.
//

import UIKit
import ImageIO

internal protocol GIFOAnimatorImageUpdateDelegate {
    func animationImageUpdate(_ image: CGImage)
}

internal class GIFOAnimator {
    private var currentFrameIndex = 0
    private var lastFrameTime: Double = 0.0
    private var loopCount: Int = 0
    private var currentLoop: Int = 0
    private var displayLink: CADisplayLink?
    internal var delegate: GIFOAnimatorImageUpdateDelegate?
    private var frameFactory: GIFOFrameFactory?
    
    internal func setupForAnimation(data: Data,
                                    size: CGSize,
                                    loopCount: Int,
                                    contentMode: UIView.ContentMode,
                                    level: GIFFrameReduceLevel,
                                    isResizing: Bool,
                                    cacheKey: String,
                                    animationOnReady: (() -> Void)? = nil) {
        frameFactory = nil
        frameFactory = GIFOFrameFactory(data: data,
                                        size: size,
                                        contentMode: contentMode,
                                        isResizing: isResizing,
                                        cacheKey: cacheKey)
        self.loopCount = loopCount
        
        frameFactory?.setupGIFImageFrames(level: level) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setupDisplayLink()
            animationOnReady?()
        }
    }
    
    private func setupDisplayLink() {
        let gifDisplay = CADisplayLink(target: self, selector: #selector(updateFrame))
        gifDisplay.preferredFramesPerSecond = 10
        gifDisplay.isPaused = true
        gifDisplay.add(to: .current, forMode: .common)
        self.displayLink = gifDisplay
    }
    
    internal func setupCachedImages(animationOnReady: (() -> Void)? = nil) {
        frameFactory?.setupGIFImageFrames { [weak self] in
            guard let strongSelf = self else { return }
//            strongSelf.setupDisplayLink()
            animationOnReady?()
        }
    }
    
    @objc private func updateFrame() {
        guard let frames = frameFactory?.animationFrames else {
            return
        }
        
        guard let elapsedTime = displayLink?.timestamp else {
            return
        }
        
        let elapsed = elapsedTime - lastFrameTime
        
        guard elapsed >= frames[currentFrameIndex].duration else {
            return
        }
        
        currentFrameIndex += 1
        
        if currentFrameIndex >= frames.count {
            currentFrameIndex = 0
            currentLoop += 1
        }
        
        if loopCount != 0 && currentLoop >= loopCount {
            currentFrameIndex = 0
            stopAnimation()
            return
        }
        
        guard let currentImage = frames[currentFrameIndex].image else {
            return
        }
        
        delegate?.animationImageUpdate(currentImage)
        
        guard let displayLinkLastFrameTime = displayLink?.timestamp else {
            return
        }
        
        lastFrameTime = displayLinkLastFrameTime
    }
    
    internal func startAnimation() {
        guard let displayLink = self.displayLink else {
            print("displayLink not found - startAnimation")
            return
        }
        
        DispatchQueue.main.async {
            displayLink.isPaused = false
        }
    }
    
    internal func clear() {
        guard let displayLink = self.displayLink else {
            print("displayLink not found - clear")
            return
        }
        
        displayLink.invalidate()
        frameFactory?.clearFactory()
    }
    
    internal func stopAnimation() {
        guard let displayLink = self.displayLink else {
            print("displayLink not found - stopAnimation")
            return
        }
        DispatchQueue.main.async {
            displayLink.isPaused = true
        }
    }
    
    internal func checkCachingStatus() -> Bool {
        guard let bool = frameFactory?.isCached else { return false }
        return bool
    }
}
