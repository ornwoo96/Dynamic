//
//  CustomCollectionViewCell.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/14.
//

import UIKit
import DynamicGIF

public struct CustomCellItem {
    let favorite: Bool
    let imageUrl: String
}

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    private var cellGradientLayer = CAGradientLayer()
    
    private lazy var imageView: GIFOImageView = {
        let imageView = GIFOImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var heartView: HeartView = {
        let view = HeartView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.clearImageView(index: 0)
    }
    
    public func configure(_ item: CustomCellItem, index: Int) {
        print(item.imageUrl)
        configure(url: item.imageUrl, index: index)
        heartView.setupHeartViewImage(bool: item.favorite)
        setupCellGradient()
    }
    
    private func configure(url: String,
                           index: Int) {
        
        DispatchQueue.global(qos: .background).async {
            
            self.imageView.setupGIFImage(index: index,
                                         url: url,
                                         cacheKey: url,
                                         size: CGSize(width: 100, height: 100),
                                         loopCount: 0,
                                         contentMode: UIView.ContentMode.scaleAspectFill,
                                         level: .highLevel,
                                         isResizing: false)
        }
    }
    
    public func clear(index: Int) {
        imageView.clearImageView(index: index)
        heartView.isHidden = true
        heartView.setupHeartViewImage(bool: false)
    }
    
    private func setupCellGradient() {
        cellGradientLayer.isOpaque = true
        cellGradientLayer.frame = CGRect(
            origin: .zero,
            size: CGSize(width: xValueRatio(1),
                         height: yValueRatio(1)))
    }
    
    private func setupUI() {
        setupBackgroundView()
        setupImageView()
        setupHeartView()
    }
    
    private func setupCell() {
        self.viewRadius(cornerRadius: 10)
    }
    
    private func setupBackgroundView() {
        cellGradientLayer.colors = UIColor.randomGradientSeries
        cellGradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: xValueRatio(200),
                                                                     height: yValueRatio(500)))
        layer.addSublayer(cellGradientLayer)
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupHeartView() {
        imageView.addSubview(heartView)
        heartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public func checkHeartViewIsHidden() -> Bool {
        if heartView.isHidden == true {
            heartView.setupHeartViewImage(bool: true)
            return true
        } else {
            heartView.setupHeartViewImage(bool: false)
            return false
        }
    }
}
