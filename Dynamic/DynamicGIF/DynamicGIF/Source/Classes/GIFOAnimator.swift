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
    func animationStoped()
}

internal class GIFOAnimator {
    private var currentFrameIndex = 0
    private var loopCount: Int = 0
    private var currentLoop: Int = 0
    private var timer: Timer?
    internal var delegate: GIFOAnimatorImageUpdateDelegate?
    private var frameFactory: GIFOFrameFactory?
    internal var isPaused = false
    
    private let frameDuration = 0.1
    
    internal var currentImage: GIFOFrame?
    
    internal var isAnimationStoped: Bool = false {
        didSet {
            if self.isAnimationStoped {
                delegate?.animationStoped()
            }
        }
    }
    
    var index = 0
    
    init(index: Int) {
        self.index = index
    }
    
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
        
        frameFactory?.setupGIFImageFrames(cacheKey: cacheKey,
                                          level: level,
                                          animationOnReady: animationOnReady)
    }
    
    internal func setupCachedImages(cacheKey: String,
                                    animationOnReady: @escaping () -> Void) {
        frameFactory?.setupCachedImageFrames(cacheKey: cacheKey, animationOnReady: animationOnReady)
    }
    
    @objc private func updateFrame() {
        if isPaused {
            self.frameFactory?.clearFactory {
                return
            }
        }
        
        guard let frames = frameFactory?.animationFrames else {
            return
        }
        
        if currentFrameIndex >= frames.count {
            currentFrameIndex = 0
            currentLoop += 1
        }
        
        if loopCount != 0 && currentLoop >= loopCount {
            currentFrameIndex = 0
            stopAnimation()
            return
        }
        
        guard let currentImage = frameFactory?.animationFrames[currentFrameIndex].image else {
            return
        }
        
        delegate?.animationImageUpdate(image: currentImage)
        
        
        currentFrameIndex += 1
    }
    
    internal func startAnimation() {
        timer = nil
        isPaused = false
        
        let newTimer = Timer(timeInterval: frameDuration,
                             target: self,
                             selector: #selector(updateFrame),
                             userInfo: nil,
                             repeats: true)
        timer = newTimer
        
        guard let timer = self.timer else {
            return
        }
        
        RunLoop.current.add(timer, forMode: .common)
        print("\(index)번째 Timer Start")
    }
    
    internal func clear(completed: @escaping ()->Void) {
        DispatchQueue.main.async { [weak self] in
            
            guard let timer = self?.timer else {
                print("timer not found - Clear")
                return
            }
            
            self?.isPaused = true
            timer.invalidate()
            self?.frameFactory?.clearFactory(completed: completed)
            self?.frameFactory = nil
        }
    }
    
    internal func stopAnimation() {
        guard let timer = self.timer else {
            print("\(index)timer not found - stopAnimation")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isPaused = true
            timer.invalidate()
            self?.isAnimationStoped = true
        }
    }
}
