//
//  GIFAnimator.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/11.
//

import UIKit
import ImageIO

protocol GIFAnimatorImageUpdateDelegate {
    func animationImageUpdate(_ image: UIImage)
}

class GIFAnimator {
    private var currentFrameIndex = 0
    private var currentFrameStartTime: Double = 0.0
    private var loopCount: Int = 0
    private var currentLoop: Int = 0
    private lazy var displayLink: CADisplayLink = { [unowned self] in
        let displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink.isPaused = true
        
        return displayLink
    }()
    
    private var delegate: GIFAnimatorImageUpdateDelegate?
    private var frameFactory: GIFFrameFactory?
    
    func setupForAnimation(data: Data,
                           size: CGSize,
                           loopCount: Int = 0,
                           contentMode: UIView.ContentMode,
                           level: GIFFrameReduceLevel = .highLevel) {
        frameFactory = GIFFrameFactory(data: data,
                                       size: size,
                                       contentMode: contentMode)
        self.loopCount = loopCount
        frameFactory?.setupGIFImageFrames(level: level)
        setupDisplayRunLoop()
    }
    
    @objc func updateFrame() {
        guard let animationFrameCount = frameFactory?.animationFrames.count else { return }
        
        if currentFrameIndex >= animationFrameCount {
            currentFrameIndex = 0
            currentLoop += 1
        }
        
        // MARK: CurrentFrameIndex 값이 GIFFrame.count 값 보다 크거나 같으면 loop 추가 로직
        
        if loopCount != 0 && currentLoop >= loopCount {
            stopAnimation()
            return
        }
        
    }
    
    private func setupDisplayRunLoop() {
        displayLink.add(to: .main, forMode: .common)
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
