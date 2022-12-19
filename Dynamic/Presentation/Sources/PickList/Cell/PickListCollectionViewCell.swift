//
//  PickListCollectionViewCell.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/18.
//

import UIKit

class PickListCollectionViewCell: UICollectionViewCell {
    static let identifier = "PickListCollectionViewCell"
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var heartView: HeartView = {
        let view = HeartView()
        view.isHidden = false
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
    
    public func configure(_ imageData: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = UIImage.gifImageWithData(imageData)
        }
    }
    
    private func setupUI() {
        setupImageView()
        setupHeartView()
    }
    
    private func setupCell() {
        self.viewRadius(cornerRadius: 10)
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
