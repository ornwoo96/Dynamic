//
//  Coordinator.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/16.
//

import UIKit

public class Coordinator: NSObject, Coordinatable {
    public var navigationController: UINavigationController? = nil
    var childCoordinators: [Coordinatable] = []
    weak var parentCoordinator: Coordinatable? = nil
    public var viewController: (HasCoordinatable & UIViewController)?
    
    override init() {
        super.init()
        navigationController?.delegate = self
    }
    
    init(parentCoordinator: Coordinatable?,
         viewController: HasCoordinatable & UIViewController) {
        super.init()
        self.parentCoordinator = parentCoordinator
        self.parentCoordinator?.childCoordinators.append(self)
        self.navigationController = parentCoordinator?.navigationController
        self.viewController = viewController
        self.viewController?.coordinator = self
    }
    
    func start() { }
    
    func childDidFinish(_ child: Coordinatable?, root: Coordinatable?) {
        guard let root = root,
              root.childCoordinators.isEmpty == false else {
            return
        }
        
        for (index, coordinator) in root.childCoordinators.enumerated() {
            if coordinator === child {
                root.childCoordinators.remove(at: index)
                break
            } else {
                childDidFinish(child, root: coordinator)
            }
        }
    }
}

extension Coordinator: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let coordinator = (fromViewController as? HasCoordinatable)?.coordinator {
            childDidFinish(coordinator, root: self)
        }
    }
}
