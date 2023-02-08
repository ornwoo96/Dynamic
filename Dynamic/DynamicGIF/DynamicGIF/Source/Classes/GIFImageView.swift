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
}
