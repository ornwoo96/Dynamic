//
//  CustomCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

import DynamicCore

public class CustomCoordinator: Coordinator {
    override func start() {
        guard let viewController = viewController,
              let tabBarCoordinator: TabBarCoordinator = DIContainer.shared.resolveValue(CodiKeys.tabBar.rawValue) else {
            return
        }
        parentCoordinator = tabBarCoordinator
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    public func pushPickListView() {
        guard let coordinator: PickListCoordinator = DIContainer.shared.resolveValue(CodiKeys.pickList.rawValue) else { return }
        coordinator.start()
    }
    
    public func presentDetailView(_ detailData: DetailModel) {
        guard let coordinator: DetailCoordinator = DIContainer.shared.resolveValue(CodiKeys.detail.rawValue) else { return }
        coordinator.detailData = detailData
        coordinator.start()
    }
}
