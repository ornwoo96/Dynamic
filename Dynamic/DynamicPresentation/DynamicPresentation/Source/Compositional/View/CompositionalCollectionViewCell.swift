//
//  CompositionalCollectionViewCell.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import UIKit
import GIFO

internal class CompositionalCellItem: BaseCellItem {
    let url: String
    let favorite: Bool
    let width: CGFloat
    let height: CGFloat
    
    init(url: String,
         favorite: Bool,
         width: CGFloat,
         height: CGFloat) {
        self.url = url
        self.favorite = favorite
        self.width = width
        self.height = height
    }
}

internal class CompositionalCollectionViewCell: UICollectionViewCell {
    internal static let identifier = "CompositionalCollectionViewCell"
    private var cellGradientLayer = CAGradientLayer()
    
    internal lazy var gifImageView: GIFOImageView = {
        let imageView = GIFOImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var heartView: HeartView = {
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
    
    internal func configure(_ item: CompositionalCellItem) {
        self.setupCellGradient()
        self.gifImageView.setupGIFImageWithUIImage(url: item.url, cacheKey: item.url)
        self.heartView.setupHeartViewImage(bool: item.favorite)
    }
    
    internal func clear() {
        gifImageView.clearWithUIImage()
        heartView.isHidden = true
        heartView.setupHeartViewImage(bool: false)
    }
    
    private func setupCellGradient() {
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
    
    internal func checkHeartViewIsHidden() -> Bool {
        if heartView.isHidden == true {
            heartView.setupHeartViewImage(bool: true)
            return true
        } else {
            heartView.setupHeartViewImage(bool: false)
            return false
        }
    }
}

