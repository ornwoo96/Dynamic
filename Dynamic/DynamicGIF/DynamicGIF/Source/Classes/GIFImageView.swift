//
//  GIFImageView.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

// MARK: setup image data
// MARK: 그다음 애니메이션 스타트, 중지
// MARK: 캐싱 작업

public class GIFImageView: UIImageView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: func으로 image setup - 필요 객체 : Data, Size
    
    
    public func clearImageView() {
        self.image = nil
    }
    
}

extension GIFImageView: GIFAnimatorImageUpdateDelegate {
    func animationImageUpdate(_ image: UIImage) {
        self.image = image
    }
}
