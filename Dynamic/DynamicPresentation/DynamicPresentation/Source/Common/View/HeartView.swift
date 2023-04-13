//
//  HeartView.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/17.
//

import UIKit
import DynamicGIF

public class HeartView: UIView {
    private lazy var blackBackgroundLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.heartViewBackgroundBlackColor
        return view
    }()
    
    private lazy var heartImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    internal var isFavorite = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBlackBackgroundView()
        setupHeartImageView()
    }
    
    private func setupBlackBackgroundView() {
        self.addSubview(blackBackgroundLayerView)
        blackBackgroundLayerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blackBackgroundLayerView.topAnchor.constraint(equalTo: self.topAnchor),
            blackBackgroundLayerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blackBackgroundLayerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blackBackgroundLayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupHeartImageView() {
        blackBackgroundLayerView.addSubview(heartImageView)
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            heartImageView.widthAnchor.constraint(equalToConstant: xValueRatio(60)),
            heartImageView.heightAnchor.constraint(equalToConstant: yValueRatio(60))
        ])
    }
    
    public func setupHeartViewImage(bool: Bool) {
        isFavorite = bool
        
        if isFavorite {
            self.showHeartView()
        } else {
            self.hideHeartView()
        }
    }
    
    private func showHeartView() {
        DispatchQueue.main.async { [weak self] in
            let image = UIImage(named: "heart")
            self?.isHidden = false
            self?.heartImageView.image = image
        }
    }
    
    private func hideHeartView() {
        DispatchQueue.main.async { [weak self] in
            self?.isHidden = true
            self?.heartImageView.image = nil
        }
    }
}
