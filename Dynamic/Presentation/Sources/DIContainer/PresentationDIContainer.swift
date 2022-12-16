//
//  MainDIContainer.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit

import DynamicCore
import DynamicDomain

public final class PresentationDIContainer: Containable {
    public var container: BMOInject = DIContainer.shared
    
    public init() {}
    
    public func register() {
        registerViewModels()
        registerViewControllers()
        registerCoordinators()
        registerTabBar()
    }
    
    private func registerViewModels() {
        registerCustomViewModel()
        registerCompositionalViewModel()
        registerSwiftUIViewModel()
        registerDetailViewModel()
        registerPickListViewModel()
    }
    
    private func registerViewControllers() {
        registerCustomViewController()
        registerSwiftUIViewController()
        registerCompositionalViewController()
        registerDetailViewController()
        registerPickListViewController()
    }
    
    private func registerCoordinators() {
        registerCustomCoordinator()
        registerCompositionalCoordinator()
        registerSwiftCoordinator()
        registerDetailCoordinator()
        registerPickListCoordinator()
    }
}

// MARK: Register - Coordinator
extension PresentationDIContainer {
    private func registerCustomCoordinator() {
        guard let viewController: CustomViewController = container.resolveValue(VCKeys.customVC.rawValue) else { return }
        let coordinator = CustomCoordinator.init(parentCoordinator: nil,
                                                 viewController: viewController)
        coordinator.navigationController = UINavigationController()
        container.registerValue(CodiKeys.custom.rawValue, coordinator)
    }
    
    private func registerCompositionalCoordinator() {
        guard let viewController: CompositionalViewController = container.resolveValue(VCKeys.compoVC.rawValue) else { return }
        let coordinator = CompositionalCoordinator(parentCoordinator: nil,
                                                   viewController: viewController)
        coordinator.navigationController = UINavigationController()
        container.registerValue(CodiKeys.compo.rawValue, coordinator)
    }
    
    private func registerSwiftCoordinator() {
        guard let viewController: SwiftUIViewController = container.resolveValue(VCKeys.swiftUI.rawValue) else { return }
        let coordinator = SwiftUICoordinator(parentCoordinator: nil,
                                             viewController: viewController)
        coordinator.navigationController = UINavigationController()
        container.registerValue(CodiKeys.swift.rawValue, coordinator)
    }
    
    private func registerDetailCoordinator() {
        guard let viewController: DetailViewController = container.resolveValue(VCKeys.detail.rawValue),
              let parentCoordinator: Coordinatable = DIContainer.shared.resolveValue(CodiKeys.custom.rawValue) else { return }
        let coordinator = DetailCoordinator(parentCoordinator: parentCoordinator,
                                            viewController: viewController)
        container.registerValue(CodiKeys.detail.rawValue, coordinator)
    }
    
    private func registerPickListCoordinator() {
        guard let viewController: PickListViewController = container.resolveValue(VCKeys.pickList.rawValue),
              let parentCoordinator: Coordinatable = DIContainer.shared.resolveValue(CodiKeys.custom.rawValue) else { return }
        let coordinator = PickListCoordinator(parentCoordinator: parentCoordinator,
                                              viewController: viewController)
        
        container.registerValue(CodiKeys.pickList.rawValue, coordinator)
    }
}

// MARK: Register - ViewController
extension PresentationDIContainer {
    private func registerCustomViewController() {
        guard let viewModel: CustomViewModel = container.resolveValue(VMKeys.customVM.rawValue) else { return }
        let viewController = CustomViewController(viewModel: viewModel)
        container.registerValue(VCKeys.customVC.rawValue, viewController)
    }
    
    private func registerCompositionalViewController() {
        guard let viewModel: CompositionalViewModel = container.resolveValue(VMKeys.compoVM.rawValue) else { return }
        let viewController = CompositionalViewController(viewModel: viewModel)
        container.registerValue(VCKeys.compoVC.rawValue, viewController)
    }
    
    private func registerSwiftUIViewController() {
        guard let viewModel: SwiftUIViewModel = container.resolveValue(VMKeys.swiftUIVM.rawValue) else { return }
        let viewController = SwiftUIViewController(viewModel: viewModel)
        container.registerValue(VCKeys.swiftUI.rawValue, viewController)
    }
    
    private func registerDetailViewController() {
        guard let viewModel: DetailViewModel = container.resolveValue(VMKeys.detail.rawValue) else { return }
        let viewController = DetailViewController(viewModel: viewModel)
        container.registerValue(VCKeys.detail.rawValue, viewController)
    }
    
    private func registerPickListViewController() {
        guard let viewModel: PickListViewModel = container.resolveValue(VMKeys.pickList.rawValue) else { return }
        let viewController = PickListViewController(viewModel: viewModel)
        container.registerValue(VCKeys.pickList.rawValue, viewController)
    }
}

// MARK: Register - ViewModel
extension PresentationDIContainer {
    private func registerCustomViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return }
        let viewModel = CustomViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.customVM.rawValue, viewModel)
    }
    
    private func registerCompositionalViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return }
        let viewModel = CompositionalViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.compoVM.rawValue, viewModel)
    }
    
    private func registerSwiftUIViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return }
        let viewModel = DynamicPresentation.SwiftUIViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.swiftUIVM.rawValue, viewModel)
    }
    
    private func registerDetailViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return }
        let viewModel = DetailViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.detail.rawValue, viewModel)
    }
    
    private func registerPickListViewModel() {
        let viewModel = PickListViewModel()
        container.registerValue(VMKeys.pickList.rawValue, viewModel)
    }
}

extension PresentationDIContainer {
    private func registerTabBar() {
        
        guard let customCoordinator: CustomCoordinator = container.resolveValue(CodiKeys.custom.rawValue),
              let compositionalCoordinator: CompositionalCoordinator = DIContainer.shared.resolveValue(CodiKeys.compo.rawValue),
              let swiftCoordinator: SwiftUICoordinator = container.resolveValue(CodiKeys.swift.rawValue) else { return }
        
        customCoordinator.navigationController = UINavigationController()
        compositionalCoordinator.navigationController = UINavigationController()
        swiftCoordinator.navigationController = UINavigationController()
        
        guard let customNavigationController: UINavigationController = customCoordinator.navigationController,
              let compositionalNavigationController: UINavigationController = compositionalCoordinator.navigationController,
              let swiftNavigationController: UINavigationController = swiftCoordinator.navigationController else { return }
    
        let initialViewController = TabBarController(customTab: customNavigationController,
                                                     compoTab: compositionalNavigationController,
                                                     swiftTab: swiftNavigationController)
        let tabBarCoordinator = TabBarCoordinator(parentCoordinator: nil,
                                                  viewController: initialViewController)
        
        initialViewController.coordinator = tabBarCoordinator
        tabBarCoordinator.viewController = initialViewController
        container.registerValue(CodiKeys.tabBar.rawValue, tabBarCoordinator)
    }
}
