//
//  CustomCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

import DynamicCore

public final class CustomCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        guard let viewController: CustomViewController = DIContainer.shared.resolveValue(VCKeys.CustomVC.rawValue) else { return }
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}
