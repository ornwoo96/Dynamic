//
//  CustomCollectionViewCell.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/14.
//

import UIKit

import DynamicCore

public struct CustomCellItem {
    let favorite: Bool
    let imageUrl: String
}

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
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
    }
    
    public func configure(_ item: CustomCellItem) {
        Task {
            let image = try await ImageCacheManager.shared.imageLoad(item.imageUrl)
            await MainActor.run { [weak self] in
                self?.imageView.image = nil
                self?.imageView.image = UIImage.gifImageWithData(image)
                self?.animateHeartView(item.favorite)
            }
        }
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
        self.setGradientWithArrayThreeColor(UIColor.randomGradientSeries,
                                            CGSize(width: xValueRatio(200),
                                                   height: yValueRatio(300)))
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
    
    private func animateHeartView(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            if bool == false {
                self?.heartView.isHidden = true
            } else {
                self?.heartView.isHidden = false
            }
        }
    }
    
    public func checkHeartViewIsHidden() -> Bool {
        if heartView.isHidden == true {
            DispatchQueue.main.async { [weak self] in
                self?.heartView.isHidden = false
            }
            return true
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.heartView.isHidden = true
            }
            return false
        }
    }
}
