//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

public class GIFImageView: UIImageView {
    
    var gifImage: GIFImage?

    // Data로 setup
    public func setupImage(GIFData: Data) {
        gifImage?.animate(withGIFData: GIFData)
    }
    
    public func setupImage(GIFUrl: String) {
        gifImage?.animate(withGIFData: GIFUrl)
    }
    
    public func setupImage(GIFFileName: String) {
        gifImage?.animate(GIFName: GIFFileName)
    }
    
}
