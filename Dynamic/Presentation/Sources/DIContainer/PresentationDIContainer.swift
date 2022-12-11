//
//  MainDIContainer.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//


import Foundation
import UIKit

import DynamicCore
import DynamicDomain

public final class PresentationDIContainer: Containable {
    
    public var container: BMOInject = DIContainer.shared
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func register() {
        registerViewModels()
        registerViewControllers()
        registerCoordinators()
    }
    
    private func registerCoordinators() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        container.registerValue(CodiKeys.MainCodi.rawValue, mainCoordinator)
    }
    
    private func registerViewControllers() {
        guard let mainViewModel: MainViewModelProtocol = container.resolveValue(VMKeys.MainVM.rawValue) else { return }
        let mainViewController = MainViewController(mainViewModel: mainViewModel)
        container.registerValue(VCKeys.MainVC.rawValue, mainViewController)
    }
    
    private func registerViewModels() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.DynamicUC.rawValue) else { return }
        let mainViewModel = MainViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.MainVM.rawValue, mainViewModel)
    }
}
