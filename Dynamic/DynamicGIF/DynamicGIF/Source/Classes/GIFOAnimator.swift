//
//  GIFAnimator.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/11.
//

import UIKit
import ImageIO

internal protocol GIFOAnimatorImageUpdateDelegate {
    func animationImageUpdate(image: UIImage)
}

internal class GIFOAnimator {
    private var currentFrameIndex = 0
    private var lastFrameTime: Double = 0.0
    private var loopCount: Int = 0
    private var currentLoop: Int = 0
    private var displayLink: CADisplayLink?
    private var frameFactory: GIFOFrameFactory?
    internal var isPaused = false
    internal var delegate: GIFOAnimatorImageUpdateDelegate?
    internal var currentImage: GIFOFrame?
    
    internal func setupForAnimation(data: Data,
                                    size: CGSize,
                                    loopCount: Int,
                                    contentMode: UIView.ContentMode,
                                    level: GIFFrameReduceLevel,
                                    isResizing: Bool,
                                    cacheKey: String,
                                    animationOnReady: @escaping () -> Void) {
        frameFactory = nil
        frameFactory = GIFOFrameFactory(data: data,
                                        size: size,
                                        contentMode: contentMode,
                                        isResizing: isResizing)
        self.loopCount = loopCount
        frameFactory?.setupGIFImageFramesWithGIFOFrame(cacheKey: cacheKey,
                                                      level: level) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setupDisplayLink()
            animationOnReady()
        }
    }
    
    private func setupDisplayLink() {
        let gifDisplay = CADisplayLink(target: self, selector: #selector(updateFrame))
        gifDisplay.preferredFramesPerSecond = 10
        gifDisplay.isPaused = true
        gifDisplay.add(to: .current, forMode: .common)
        displayLink = gifDisplay
    }
    
    internal func setupCachedImages(cacheKey: String,
                                    animationOnReady: @escaping () -> Void) {
        frameFactory?.setupCachedImageFramesWithGIFOFrame(cacheKey: cacheKey) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setupDisplayLink()
            animationOnReady()
        }
    }
    
    @objc private func updateFrame() {
        guard !isPaused else {
            return
        }
        
        guard let frames = frameFactory?.animationGIFOFrames else {
            return
        }
        
        guard let elapsedTime = displayLink?.timestamp else {
            return
        }
        
        if currentFrameIndex >= frames.count {
            currentFrameIndex = 0
            currentLoop += 1
        }
        
        let elapsed = elapsedTime - lastFrameTime
        
        guard elapsed >= frames[currentFrameIndex].duration else {
            return
        }
        
        
        if loopCount != 0 && currentLoop >= loopCount {
            currentFrameIndex = 0
            stopAnimation()
            return
        }
        
        guard let currentImage = frameFactory?.animationGIFOFrames?[currentFrameIndex].image else {
            return
        }
        
        delegate?.animationImageUpdate(image: currentImage)
        
        guard let displayLinkLastFrameTime = displayLink?.timestamp else {
            return
        }
        
        currentFrameIndex += 1
        lastFrameTime = displayLinkLastFrameTime
    }
    
    internal func startAnimation() {
        guard let displayLink = self.displayLink else {
            return
        }
        isPaused = false
        displayLink.isPaused = false
    }
    
    internal func clear(completion: @escaping ()->Void) {
        guard let displayLink = self.displayLink else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isPaused = true
            displayLink.isPaused = true
            displayLink.invalidate()
            self?.frameFactory?.clearFactory() {
                completion()
            }
        }
    }
    
    internal func stopAnimation() {
        guard let displayLink = self.displayLink else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.isPaused = true
            displayLink.isPaused = true
        }
    }
}
