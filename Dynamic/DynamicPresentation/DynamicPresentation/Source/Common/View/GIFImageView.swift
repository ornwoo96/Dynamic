//
//  UIImageView+GIF.swift
//  DynamicPresentationTests
//
//  Created by 김동우 on 2023/01/05.
//

import UIKit
import DynamicGIF

public class GIFImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func clear() {
        DispatchQueue.main.async { [weak self] in
            self?.image = nil
        }
    }
    
    public func configure(url: String) {
        Task { [weak self] in
            let image = try await ImageCacheManager.shared.imageLoad(url)
            
            guard let imageData = UIImage.gifImageWithData(image) else {
                return
            }
            
            await MainActor.run {
                self?.image = imageData
            }
        }
    }
    
    public func configureWithFileName(name: String) {
        DispatchQueue.main.async { [weak self] in
            self?.image = UIImage(named: name)
        }
    }
}
