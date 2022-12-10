//
//  MainCoordinator.swift
//  Presentation
//
//  Created by 김동우 on 2022/12/10.
//

import UIKit

import Core
import Domain

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

public final class MainCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        print("Coordinator start!")
        guard let viewController: MainViewController = DIContainer.shared.resolveValue("MainViewController") else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
