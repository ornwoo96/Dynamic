//
//  CustomNavigationBar.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit

final class CustomNavigationBar: UIView {
    internal var mainNavigationBar = MainNavigationBar()
    internal var favoritesNavigationBar = FavoritesNavigationBar()
    
    internal enum CustomNavigationBarType {
        case main
        case favorites
    }
    
    init(_ custom: CustomNavigationBarType) {
        super.init(frame: .zero)
        setupCustomType(custom)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomType(_ custom: CustomNavigationBarType) {
        switch custom {
        case .main:
            setupMainUI()
        case .favorites:
            setupFavoritesUI()
        }
    }
    
    private func setupMainUI() {
        self.addSubview(mainNavigationBar)
        mainNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainNavigationBar.topAnchor.constraint(equalTo: self.topAnchor),
            mainNavigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainNavigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainNavigationBar.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupFavoritesUI() {
        self.addSubview(favoritesNavigationBar)
        favoritesNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoritesNavigationBar.topAnchor.constraint(equalTo: self.topAnchor),
            favoritesNavigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            favoritesNavigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            favoritesNavigationBar.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
