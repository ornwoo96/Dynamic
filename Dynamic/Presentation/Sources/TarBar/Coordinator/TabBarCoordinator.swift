//
//  TabBarCoordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit
import DynamicCore

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

public final class TabBarCoordinator: NSObject, Coordinator {
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    public var container: BMOInject = DIContainer.shared

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        guard let customCoordinator: CustomCoordinator = container.resolveValue(CodiKeys.custom.rawValue) else { return }
        childCoordinators.append(customCoordinator)
        let customViewController = customCoordinator.navigationController
        customCoordinator.start()
        
        
        guard let compositionalCoordinator: CompositionalCoordinator = container.resolveValue(CodiKeys.compo.rawValue) else { return }
        childCoordinators.append(compositionalCoordinator)
        let compositionalViewController = compositionalCoordinator.navigationController
        compositionalCoordinator.start()
        
        
        guard let swiftCoordinator: SwiftUICoordinator = container.resolveValue(CodiKeys.swift.rawValue) else { return }
        childCoordinators.append(swiftCoordinator)
        let swiftViewController = swiftCoordinator.navigationController
        swiftCoordinator.start()
        
        let initialViewController = TabBarController(customTab: customViewController,
                                                     compoTab: compositionalViewController,
                                                     swiftTab: swiftViewController)
        
        initialViewController.coordinator = self

        navigationController.pushViewController(initialViewController, animated: false)
    }
}
