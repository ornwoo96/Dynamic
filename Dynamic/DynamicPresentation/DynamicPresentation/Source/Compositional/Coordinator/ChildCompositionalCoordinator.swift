//
//  CompositionalCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

import DynamicCore

internal class ChildCompositionalCoordinator: Coordinator {
    internal override func start() {
        guard let viewController = viewController,
              let tabBarCoordinator: TabBarCoordinator = DIContainer.shared.resolveValue(CodiKeys.tabBar.rawValue) else { return }
        parentCoordinator = tabBarCoordinator
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    internal func presentDetailView(_ viewController: UIViewController,
                                  _ detailData: DetailModel) {
        guard let coordinator: DetailCoordinator = DIContainer.shared.resolveValue(CodiKeys.detail.rawValue) else { return }
        coordinator.detailData = detailData
        coordinator.viewController?.modalPresentationStyle = .formSheet
        self.parentCoordinator?.viewController?.present(coordinator.viewController ?? UIViewController(), animated: true)
    }
    
    internal func passFavoritesCountDataToParent(_ count: Int) {
        guard let parentCoordinator = self.parentCoordinator as? ParentCompositionalCoordinator else { return }
        parentCoordinator.receiveFavoritesCountData(count)
    }
    
    internal func pushPickListView() {
        guard let coordinator: PickListCoordinator = DIContainer.shared.resolveValue(CodiKeys.pickList.rawValue) else { return }
        coordinator.navigationController = parentCoordinator?.navigationController
        coordinator.start()
    }
    
    internal func hideNavigationBar() {
        guard let parentCoordinator = self.parentCoordinator as? ParentCompositionalCoordinator else { return }
        parentCoordinator.setupCompositionalNavigationBarState(state: .hide)
    }
    
    internal func showNavigationBar() {
        guard let parentCoordinator = self.parentCoordinator as? ParentCompositionalCoordinator else { return }
        parentCoordinator.setupCompositionalNavigationBarState(state: .show)
    }
}
