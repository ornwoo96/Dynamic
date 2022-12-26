//
//  ParentCompositionalCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/24.
//

import UIKit

import DynamicCore

public class ParentCompositionalCoordinator: Coordinator {
    var childViewControllers: [ChildCompositionalViewController] = []
    
    override func start() {
        guard let viewController = viewController,
              let tabBarCoordinator: TabBarCoordinator = DIContainer.shared.resolveValue(CodiKeys.tabBar.rawValue) else { return }
        parentCoordinator = tabBarCoordinator
        setupParentCoordinator()
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    public func pushPickListView() {
        guard let coordinator: PickListCoordinator = DIContainer.shared.resolveValue(CodiKeys.pickList.rawValue) else { return }
        coordinator.navigationController = parentCoordinator?.navigationController
        coordinator.start()
    }
    
    public func hideNavigationBar() {
        guard let viewController = self.viewController as? ParentCompositionalViewController else { return }
        viewController.animateHideNavigationBar()
    }
    
    public func showNavigationBar() {
        guard let viewController = self.viewController as? ParentCompositionalViewController else { return }
        viewController.animateShowNavigationBar()
    }
    
    public func receiveFavoritesCountData(_ count: Int) {
        guard let viewController = viewController as? ParentCompositionalViewController else { return }
        viewController.setupFavoritesCountData(count)
    }
    
    private func setupParentCoordinator() {
        self.childViewControllers.forEach {
            guard let childCoordinator = $0.coordinator else { return }
            childCoordinator.parentCoordinator = self
            self.childCoordinators.append(childCoordinator)
        }
    }
}
