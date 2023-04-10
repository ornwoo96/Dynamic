//
//  GIFOAnimator.swift
//  GIFO
//
//  Created by BMO on 2023/02/11.
//

import UIKit
import ImageIO

/// This protocol is called when the image of a GIF animation is updated in the `GIFOAnimator` class.
internal protocol GIFOAnimatorImageUpdateDelegate {
    func animationImageUpdate(image: UIImage)
}

/// The `GIFOAnimator` class is responsible for managing and handling GIF animations.
internal class GIFOAnimator {
    
    /// The index of the current frame being displayed in the animation.
    private var currentFrameIndex = 0
    
    /// The time at which the last frame was displayed, in seconds.
    private var lastFrameTime: Double = 0.0
    
    /// The number of times the animation should loop. A value of 0 means to loop indefinitely.
    private var loopCount: Int = 0
    
    /// The number of loops that have been completed so far.
    private var currentLoop: Int = 0
    
    /// An instance of CADisplayLink that manages the timing of the animation.
    private var displayLink: CADisplayLink?
    
    /// An instance of GIFOFrameFactory that creates frames for the animation.
    private var frameFactory: GIFOFrameFactory?
    
    /// A Boolean value that indicates whether the animation is currently paused.
    internal var isPaused = false
    
    /// An object that conforms to the GIFOAnimatorImageUpdateDelegate protocol, which is notified whenever a new frame is ready to be displayed.
    internal var delegate: GIFOAnimatorImageUpdateDelegate?
    
    /// This function initializes the animator with the provided GIF image data, size, loop count, and other optional values.
    ///
    /// - Parameters:
    ///    - data: The data of the GIF image.
    ///    - size: The size of the GIF image.
    ///    - loopCount: The number of times to repeat the GIF animation. If 0, the animation will repeat indefinitely.
    ///    - level: The level of frame reduction for the GIF animation.
    ///    - isResizing: A Boolean value indicating whether to resize the GIF image.
    ///    - cacheKey: The key to cache the GIF image data.
    ///    - isCache: A Boolean value indicating whether to cache the GIF image data.
    ///    - animationOnReady: A block to be called when the animation is ready to be played.
    internal func setupForAnimation(data: Data,
                                    size: CGSize,
                                    loopCount: Int,
                                    level: GIFFrameReduceLevel,
                                    isResizing: Bool,
                                    cacheKey: String,
                                    isCache: Bool,
                                    animationOnReady: @escaping () -> Void) {
        frameFactory = nil
        frameFactory = GIFOFrameFactory(data: data,
                                        size: size,
                                        isResizing: isResizing,
                                        isCache: isCache)
        setupDisplayLink()
        self.loopCount = loopCount
        frameFactory?.setupGIFImageFramesWithGIFOFrame(cacheKey: cacheKey,
                                                       level: level,
                                                       animationOnReady: animationOnReady)
    }
    
    /// This function creates a `CADisplayLink` object.
    public func setupDisplayLink() {
        let gifDisplay = CADisplayLink(target: self, selector: #selector(updateFrame))
        gifDisplay.preferredFramesPerSecond = 10
        gifDisplay.isPaused = true
        gifDisplay.add(to: .main, forMode: .common)
        displayLink = gifDisplay
    }
    
    /// This function sets up the cached image frames with the provided cache key and calls the given block when the animation is ready to be displayed.
    ///
    /// - Parameters:
    ///    - cacheKey: The key to cache the image data.
    ///    - animationOnReady: A block to be called when the animation is ready.
    internal func setupCachedImages(cacheKey: String,
                                    animationOnReady: @escaping () -> Void) {
        frameFactory?.setupCachedImageFramesWithGIFOFrame(cacheKey: cacheKey) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setupDisplayLink()
            animationOnReady()
        }
    }
    
    /// This is a method that updates each frame of an animation using a display link object.
    @objc private func updateFrame() {
        checkIsPaused()
        updateLoopCount()
        checkElapsedTime()
        checkLoopCount()
        updateCurrentImageToDelegate()
        updateCurrentFrameIndex()
    }
    
    /// This is a function that checks whether the animation is paused or not.
    private func checkIsPaused() {
        guard !isPaused else {
            return
        }
    }
    
    /// This is a function that updates the current loop count.
    private func updateLoopCount() {
        guard let frameCount = frameFactory?.animationGIFOFrames?.count else {
            return
        }
        
        if currentFrameIndex >= frameCount {
            currentFrameIndex = 0
            currentLoop += 1
        }
    }
    
    /// This function checks if the elapsed time since the last frame update has exceeded the duration of the current frame.
    private func checkElapsedTime() {
        guard let frames = frameFactory?.animationGIFOFrames else {
            return
        }
        
        guard let elapsedTime = displayLink?.timestamp else {
            return
        }
        
        let elapsed = elapsedTime - lastFrameTime
        
        guard elapsed >= frames[currentFrameIndex].duration else {
            return
        }
    }
    
    /// This function is responsible for stopping the animation when the current loop count reaches the specified loop count.
    private func checkLoopCount() {
        if loopCount != 0 && currentLoop >= loopCount {
            currentFrameIndex = 0
            stopAnimation()
            return
        }
    }
    
    /// This function updates the current image to the delegate by getting the image from the frame at the current frame index.
    private func updateCurrentImageToDelegate() {
        guard let currentImage = frameFactory?.animationGIFOFrames?[currentFrameIndex].image else {
            return
        }
        
        delegate?.animationImageUpdate(image: currentImage)
    }
    
    /// This function updates the current frame index using the timestamp of the display link.
    private func updateCurrentFrameIndex() {
        guard let displayLinkLastFrameTime = displayLink?.timestamp else {
            return
        }
        currentFrameIndex += 1
        lastFrameTime = displayLinkLastFrameTime
    }
    
    
    /// This function starts the animation by setting the isPaused property to false and unpausing the displayLink.
    internal func startAnimation() {
        guard let displayLink = self.displayLink else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.isPaused = false
            displayLink.isPaused = false
        }
    }
    
    /// This function stops the animation, clears the frame factory
    internal func clear(completion: @escaping ()->Void) {
        guard let displayLink = self.displayLink else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isPaused = true
            displayLink.isPaused = true
            displayLink.invalidate()
            self?.frameFactory?.clearFactoryWithGIFOFrame(completion: completion)
        }
    }
    
    /// This function stops the animation
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
