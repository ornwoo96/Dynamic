//
//  CompositionalCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

import DynamicCore

public final class CompositionalCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        print("Coordinator start!")
        guard let viewController: CompositionalViewController = DIContainer.shared.resolveValue(VCKeys.CompoVC.rawValue) else { return }
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    public func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
