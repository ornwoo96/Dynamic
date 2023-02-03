//
//  TarBarController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

public final class TabBarController: UITabBarController, HasCoordinatable {
    public var coordinator: Coordinator?
    private let customTab: UINavigationController
    private let compoTab: UINavigationController
    private let swiftTab: UINavigationController
    
    private lazy var tabBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var customTabButton: TabBarItem = {
        let button = TabBarItem()
        button.tag = 0
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        button.DotView.isHidden = false
        button.DotView.backgroundColor = .systemBlue
        button.textLabel.text = "U"
        let cgrect = CGRect(x: .zero, y: .zero, width: xValueRatio(50), height: yValueRatio(50))
        let gradient = UIImage.gradientImage(bounds: cgrect, colors: [.tabItemBlueLeft, .tabItemBlueRight])
        button.textLabel.textColor = UIColor(patternImage: gradient)
        return button
    }()
    
    private lazy var compoTabButton: TabBarItem = {
        let button = TabBarItem()
        button.tag = 1
        button.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        button.DotView.isHidden = true
        button.DotView.backgroundColor = .tabItemRedLeft
        button.textLabel.text = "C"
        let cgrect = CGRect(x: .zero, y: .zero, width: xValueRatio(50), height: yValueRatio(50))
        let gradient = UIImage.gradientImage(bounds: cgrect, colors: [.tabItemRedLeft, .tabItemRedMiddle, .tabItemRedRight])
        button.textLabel.textColor = UIColor(patternImage: gradient)
        return button
    }()
    
    private lazy var swiftTabButton: TabBarItem = {
        let button = TabBarItem()
        button.tag = 2
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        button.DotView.isHidden = true
        button.DotView.backgroundColor = .tabItemYellowMiddle
        button.textLabel.text = "S"
        let cgrect = CGRect(x: .zero, y: .zero, width: xValueRatio(50), height: yValueRatio(50))
        let gradient = UIImage.gradientImage(bounds: cgrect, colors: [.tabItemYellowMiddle, .yellow])
        button.textLabel.textColor = UIColor(patternImage: gradient)
        return button
    }()
    
    public init(customTab: UINavigationController,
                compoTab: UINavigationController,
                swiftTab: UINavigationController) {
        self.customTab = customTab
        self.compoTab = compoTab
        self.swiftTab = swiftTab
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
        setupCompoTabButton()
        setupCustomTabButton()
        setupSwiftTabButton()
    }
    
    private func setupTabBar() {
        self.viewControllers = [customTab, compoTab, swiftTab]
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
        gradient.locations = [0.0, 0.5, 0.7]
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.homeAlphaBlackColor3.cgColor,
            UIColor.black.cgColor
        ]
        view.layer.addSublayer(gradient)
    }
    
    private func setupCompoTabButton() {
        tabBarBackgroundView.addSubview(compoTabButton)
        compoTabButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compoTabButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            compoTabButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -yValueRatio(40)),
            compoTabButton.widthAnchor.constraint(equalToConstant: xValueRatio(50)),
            compoTabButton.heightAnchor.constraint(equalToConstant: yValueRatio(55))
        ])
    }
    
    private func setupCustomTabButton() {
        tabBarBackgroundView.addSubview(customTabButton)
        customTabButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xValueRatio(80)),
            customTabButton.centerYAnchor.constraint(equalTo: compoTabButton.centerYAnchor),
            customTabButton.widthAnchor.constraint(equalToConstant: xValueRatio(50)),
            customTabButton.heightAnchor.constraint(equalToConstant: yValueRatio(55))
        ])
    }
    
    private func setupSwiftTabButton() {
        tabBarBackgroundView.addSubview(swiftTabButton)
        swiftTabButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            swiftTabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xValueRatio(80)),
            swiftTabButton.centerYAnchor.constraint(equalTo: compoTabButton.centerYAnchor),
            swiftTabButton.widthAnchor.constraint(equalToConstant: xValueRatio(48)),
            swiftTabButton.heightAnchor.constraint(equalToConstant: yValueRatio(55))
        ])
    }
    
    
    private func itemDidSelected(_ tag: Int) {
        if tag == 0 {
            customTabButton.DotView.isHidden = false
            compoTabButton.DotView.isHidden = true
            swiftTabButton.DotView.isHidden = true
        } else if tag == 1 {
            customTabButton.DotView.isHidden = true
            compoTabButton.DotView.isHidden = false
            swiftTabButton.DotView.isHidden = true
        } else {
            customTabButton.DotView.isHidden = true
            compoTabButton.DotView.isHidden = true
            swiftTabButton.DotView.isHidden = false
        }
    }
    
    @objc private func itemTapped(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        itemDidSelected(sender.tag)
    }
}
