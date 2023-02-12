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
    private lazy var displayLink: CADisplayLink = { [unowned self] in
        let displayLink = CADisplayLink(target: self, selector: #selector(updateImage))
        displayLink.isPaused = true
        
        return displayLink
    }()
    private var index: Int = 0
    private var images: [UIImage] = []
    private var delegate: GIFAnimatorImageUpdateDelegate?
    private var frameFactory: GIFFrameFactory?
    
    // MARK: 1. frameFactory - setup
    func setupForAnimation(data: Data,
                           size: CGSize,
                           loopCount: Int = 0,
                           contentMode: UIView.ContentMode) {
        frameFactory = GIFFrameFactory(data: data,
                                       size: size,
                                       contentMode: contentMode,
                                       loopCount: loopCount)
        frameFactory?.setupFrames()
        setupDisplayRunLoop()
    }
    
    
    
    
    private func playGIF(data: Data) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else { return }
            images.append(UIImage(cgImage: image))
        }
    }
    
    @objc func updateFrame() {
        if (frameFactory?.totalFrameCount)! > 0 {
            let currentTime = CACurrentMediaTime()
            if currentFrameStartTime == 0.0 {
                currentFrameStartTime = currentTime
            }
            
            let elapsedTime = currentTime - currentFrameStartTime
            
            if elapsedTime >= frameDurationArray[currentFrameIndex] {
                currentFrameStartTime = currentTime
                currentFrameIndex = (currentFrameIndex + 1) % totalFrameCount
                if let imageSource = CGImageSourceCreateWithData(data as CFData, nil) {
                    if let imageRef = CGImageSourceCreateImageAtIndex(imageSource, currentFrameIndex, nil) {
                        self.image = UIImage(cgImage: imageRef)
                    }
                }
            }
        }
    }
    
    private func setupDisplayRunLoop() {
        displayLink.add(to: .main, forMode: .common)
    }
    
    @objc private func updateImage() {
        if index >= images.count {
            index = 0
        }
        delegate?.animationImageUpdate(self.images[index])
        index += 1
    }
    
    func startAnimating() {
        displayLink.isPaused = false
    }
    
    func clearAnimator() {
        displayLink.invalidate()
        index = 0
        images = []
    }
    
    func stopAnimation() {
        displayLink.isPaused = true
    }
}
