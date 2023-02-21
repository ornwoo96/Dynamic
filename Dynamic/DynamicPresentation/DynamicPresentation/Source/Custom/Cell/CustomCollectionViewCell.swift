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
    
    private lazy var gifImageView: GIFImageView2 = {
        let imageView = GIFImageView2()
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
        clear()
    }
    
    public func configure(_ item: CustomCellItem) {
        //        gifImageView.configure(url: item.imageUrl)
        configure(url: item.imageUrl)
        heartView.setupHeartViewImage(bool: item.favorite)
        setupCellGradient()
    }
    
    private func configure(url: String) {
        DispatchQueue.global(qos: .background).async {
            Task {
                let image = try await ImageCacheManager.shared.imageLoad(url)
                
                self.gifImageView.setupGIFImage(data: image,
                                                 size: CGSize(),
                                                 contentMode: .scaleAspectFill) { [weak self] in
                    self?.delay()
                }
            }
        }
    }
    
    
    private func delay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.gifImageView.startAnimation()
        }
    }
    
    public func clear() {
//        gifImageView.clear()
        gifImageView.clearImageView()
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
        contentView.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupHeartView() {
        gifImageView.addSubview(heartView)
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
