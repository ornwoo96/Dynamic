//
//  GIFAnimator.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/11.
//

import UIKit
import ImageIO

protocol GIFAnimatorImageUpdateDelegate {
    func animationImageUpdate()
}

class GIFAnimator {
    private var displayLink: CADisplayLink?
    private var index: Int = 0
    private var images: [UIImage] = []
    private var delegate: GIFAnimatorImageUpdateDelegate?
    
    private func playGIF(data: Data) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else { return }
            images.append(UIImage(cgImage: image))
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateImage))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateImage() {
        if index >= images.count {
            index = 0
        }
        self.image = images[index]
        delegate?.animationImageUpdate()
        index += 1
    }
    
    func clearAnimator() {
        displayLink?.invalidate()
        displayLink = nil
        index = 0
        images = []
    }
}
