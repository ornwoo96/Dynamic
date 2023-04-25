//
//  PickListCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit
import DynamicCore

internal class PickListCoordinator: Coordinator {
    
    override func start() {
        guard let viewController = viewController else { return }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    internal func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
