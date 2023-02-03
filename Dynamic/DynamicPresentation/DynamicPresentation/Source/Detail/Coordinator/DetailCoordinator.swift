//
//  DetailCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit
import DynamicCore

class DetailCoordinator: Coordinator {
    var detailData: DetailModel?
    
    override func start() {
        guard let viewController: DetailViewController = viewController as? DetailViewController else {
            return
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func viewDismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }
}
