//
//  CustomCollectionViewCell.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/14.
//

import UIKit

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
    
    public func configure(_ viewModel: CustomViewModel,
                          _ cellIndexPath: IndexPath) {
        Task { [weak self] in
            do {
                let imageData = try await viewModel.retrieveImageData(cellIndexPath)
                self?.imageView.image = UIImage.gifImageWithData(imageData)
            } catch {
                print("Cell 이미지불러오기 - 실패")
            }
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
    
    public func animateHeartView() {
        if heartView.isHidden == false {
            heartView.isHidden = true
        } else {
            heartView.isHidden = false
        }
    }
}
