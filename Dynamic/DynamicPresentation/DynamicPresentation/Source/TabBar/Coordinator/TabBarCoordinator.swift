//
//  TabBarCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit
import DynamicCore

public class TabBarCoordinator: Coordinator {
    override public func start() {
        guard let viewController = viewController,
              let parentCompositionalCoordinator: ParentCompositionalCoordinator = DIContainer.shared.resolveValue(CodiKeys.parentCompo.rawValue) else {
                  return
              }
        parentCompositionalCoordinator.start()

        navigationController?.pushViewController(viewController, animated: false)
    }
}
