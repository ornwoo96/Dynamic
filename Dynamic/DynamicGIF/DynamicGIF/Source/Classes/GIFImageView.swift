//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

public class GIFImageView: UIImageView {
    var gifImage: GIFImage?
    var size: CGSize?
    
    init(size: CGSize,
         gifImage: GIFImage? = nil) {
        super.init(frame: .zero)
        let image = GIFImage(size: size)
        self.size = size
        self.gifImage = gifImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupImage(GIFData: Data) {
        gifImage?.animate(withGIFData: GIFData)
    }
    
    public func setupImage(GIFUrl: String) {
        gifImage?.animate(withGIFUrl: GIFUrl)
    }
    
    public func setupImage(GIFFileName: String) {
        gifImage?.animate(GIFName: GIFFileName)
    }
    
    public func clearImageView() {
        self.image = nil
    }
    
    private var displayLink: CADisplayLink?
    private var index: Int = 0
    private var images: [UIImage] = []
    
    func playGIF(data: Data) {
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
        index += 1
    }
    
    func stopGIF() {
        displayLink?.invalidate()
        displayLink = nil
        index = 0
        images = []
    }
}
