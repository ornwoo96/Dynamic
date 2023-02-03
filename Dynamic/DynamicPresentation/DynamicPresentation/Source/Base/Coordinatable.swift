//
//  Coordinatable.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/16.
//

import UIKit

protocol Coordinatable: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinatable] { get set }
    var parentCoordinator: Coordinatable? { get }
    var viewController: (HasCoordinatable & UIViewController)? { get }
    func start()
}
