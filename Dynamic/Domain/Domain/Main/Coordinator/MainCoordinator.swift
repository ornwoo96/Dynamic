//
//  MainCoordinator.swift
//  Domain
//
//  Created by 김동우 on 2022/12/09.
//

import UIKit


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
        // DIContainer 생성 및 사용
        
    }
    
}
