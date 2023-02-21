//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

// MARK: setup image data
// MARK: 캐싱 작업

public class GIFImageView2: UIImageView {
    private var animator = GIFAnimator()
    
    // Setup - GIF URL
    public func setupGIFImage(URL: URL,
                              size: CGSize,
                              loopCount: Int = 0,
                              contentMode: UIView.ContentMode,
                              level: GIFFrameReduceLevel = .highLevel,
                              isResizing: Bool = false) {
        
    }
    
    // Setup - GIF Data
    public func setupGIFImage(data: Data,
                              size: CGSize,
                              loopCount: Int = 0,
                              contentMode: UIView.ContentMode,
                              level: GIFFrameReduceLevel = .highLevel,
                              isResizing: Bool = false,
                              animationOnReady: (() -> Void)? = nil) {
        animator.delegate = self
        animator.setupForAnimation(data: data,
                                   size: size,
                                   loopCount: loopCount,
                                   contentMode: contentMode,
                                   level: level,
                                   isResizing: isResizing,
                                   animationOnReady: animationOnReady)
        
    }
    
    public func startAnimation() {
        animator.startAnimating()
    }
    
    public func clearImageView() {
        self.animator.stopAnimation()
        self.image = nil
        self.animator.clear()
    }
    
    private func setupImage(image: UIImage) {
        
    }
}

extension GIFImageView2: GIFAnimatorImageUpdateDelegate {
    func animationImageUpdate(_ image: CGImage) {
        DispatchQueue.main.async { [weak self] in
            self?.image = UIImage(cgImage: image)
        }
    }
}
