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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
}
