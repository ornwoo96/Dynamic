//
//  ParentCompositionalCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/24.
//

import UIKit

import DynamicCore

public class ParentCompositionalCoordinator: Coordinator {
    override func start() {
        guard let viewController = viewController,
              let tabBarCoordinator: TabBarCoordinator = DIContainer.shared.resolveValue(CodiKeys.tabBar.rawValue) else { return }
        parentCoordinator = tabBarCoordinator
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    public func pushPickListView() {
        guard let coordinator: PickListCoordinator = DIContainer.shared.resolveValue(CodiKeys.pickList.rawValue) else { return }
        coordinator.navigationController = parentCoordinator?.navigationController
        coordinator.start()
    }
}
