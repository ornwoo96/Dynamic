//
//  GIFAnimator.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/11.
//

import UIKit
import ImageIO

protocol GIFAnimatorImageUpdateDelegate {
    func animationImageUpdate(_ image: CGImage)
}

class GIFAnimator {
    private var currentFrameIndex = 0
    private var currentFrameStartTime: Double = 0.0
    private var lastFrameTime: Double = 0.0
    private var loopCount: Int = 0
    private var currentLoop: Int = 0
    private lazy var displayLink: CADisplayLink = { [unowned self] in
        let displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink.isPaused = true
        
        return displayLink
    }()
    
    internal var delegate: GIFAnimatorImageUpdateDelegate?
    private var frameFactory: GIFFrameFactory?
    
    func setupForAnimation(data: Data,
                           size: CGSize,
                           loopCount: Int = 0,
                           contentMode: UIView.ContentMode,
                           level: GIFFrameReduceLevel,
                           isResizing: Bool,
                           animationOnReady: (() -> Void)? = nil) {
        startAnimating()
        frameFactory = nil
        frameFactory = GIFFrameFactory(data: data,
                                       size: size,
                                       contentMode: contentMode,
                                       isResizing: isResizing)
        self.loopCount = loopCount
        frameFactory?.setupGIFImageFrames(level: level) { [weak self] in
            self?.setupDisplayRunLoop(onReady: animationOnReady)
        }
    }
    
    @objc func updateFrame() {
        guard let frames = frameFactory?.animationFrames else {
            return
        }
        
        currentFrameIndex += 1
        
        if currentFrameIndex >= frames.count {
            currentFrameIndex = 0
            currentLoop += 1
        }
        
        let elapsed = displayLink.timestamp - lastFrameTime
        
        guard elapsed >= frames[currentFrameIndex].duration else { return }
        
        
        if loopCount == 0 {
            currentFrameIndex = 0
        } else if currentLoop >= loopCount {
            currentFrameIndex = 0
            stopAnimation()
            return
        }
        
        guard let currentImage = frames[currentFrameIndex].image else {
            return
        }
        
        delegate?.animationImageUpdate(currentImage)
        
        lastFrameTime = displayLink.timestamp
    }
    
    private func setupDisplayRunLoop(onReady: (() -> Void)? = nil) {
        displayLink.add(to: .main, forMode: .common)
        onReady?()
    }
    
    func startAnimating() {
        displayLink.isPaused = false
    }
    
    func clear() {
        displayLink.invalidate()
    }
    
    func stopAnimation() {
        displayLink.isPaused = true
    }
    
    
}
