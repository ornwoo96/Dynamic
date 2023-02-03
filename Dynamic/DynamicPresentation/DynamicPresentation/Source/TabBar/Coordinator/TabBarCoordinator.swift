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
              let parentCustomCoordinator: ParentCustomCoordinator = DIContainer.shared.resolveValue(CodiKeys.parentCustom.rawValue),
              let parentCompositionalCoordinator: ParentCompositionalCoordinator = DIContainer.shared.resolveValue(CodiKeys.parentCompo.rawValue),
              let swiftCoordinator: SwiftUICoordinator = DIContainer.shared.resolveValue(CodiKeys.swift.rawValue) else { return }
        parentCustomCoordinator.start()
        parentCompositionalCoordinator.start()
        swiftCoordinator.start()

        navigationController?.pushViewController(viewController, animated: false)
    }
}
