//
//  TarBarController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

internal final class TabBarController: UITabBarController, HasCoordinatable {
    public var coordinator: Coordinator?
    
    private let compoTab: UINavigationController
    
    private lazy var tabBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    public init(compoTab: UINavigationController) {
        self.compoTab = compoTab
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        setupTabBar()
        setupGradient()
        setupTabBarBackgroundView()
    }
    
    private func setupTabBar() {
        self.viewControllers = [compoTab]
        self.tabBar.isHidden = true
    }
    
    private func setupTabBarBackgroundView() {
        view.addSubview(tabBarBackgroundView)
        tabBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarBackgroundView.heightAnchor.constraint(equalToConstant: yValueRatio(90)),
            tabBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.maxY-yValueRatio(190)),
                                size: CGSize(width: calculateXMax(),
                                             height: yValueRatio(190)))
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.locations = [0.0, 0.7, 0.9]
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.homeAlphaBlackColor3.cgColor,
            UIColor.black.cgColor
        ]
        view.layer.addSublayer(gradient)
    }
}
