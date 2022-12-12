//
//  TarBarController.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

final class TabBarController: UITabBarController {
    var coordinator: Coordinator?
    let customTab: UINavigationController
    let compoTab: UINavigationController
    let swiftTab: UINavigationController
    
    init(customTab: UINavigationController,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        self.viewControllers = [customTab, compoTab, swiftTab]
        self.tabBar.isHidden = true
    }
    
}
