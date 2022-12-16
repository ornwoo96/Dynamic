//
//  SwiftUICoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

import DynamicCore

public class SwiftUICoordinator: Coordinator {
    override func start() {
        guard let viewController = viewController,
              let tabBarCoordinator: TabBarCoordinator = DIContainer.shared.resolveValue(CodiKeys.tabBar.rawValue) else {
            return
        }
        parentCoordinator = tabBarCoordinator
        navigationController?.pushViewController(viewController, animated: true)
    }
}
