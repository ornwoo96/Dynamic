//
//  TabBarItem.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

final class TabBarItem: UIButton {
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: xValueRatio(45), weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var DotView: UIView = {
        let view = UIView()
        view.viewRadius(cornerRadius: xValueRatio(4))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupItemImageView()
        setupDotView()
    }
    
    private func setupItemImageView() {
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupDotView() {
        addSubview(DotView)
        DotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            DotView.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            DotView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            DotView.widthAnchor.constraint(equalToConstant: xValueRatio(8)),
            DotView.heightAnchor.constraint(equalToConstant: yValueRatio(8))
        ])
    }
    
}
