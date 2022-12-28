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
        registerParentCustomViewModel()
        registerSwiftUIViewModel()
        registerDetailViewModel()
        registerPickListViewModel()
        registerParentCompositionalViewModel()
    }
    
    private func registerViewControllers() {
        registerParentCustomViewController()
        registerSwiftUIViewController()
        registerCompositionalViewController()
        registerDetailViewController()
        registerPickListViewController()
    }
    
    private func registerCoordinators() {
        registerParentCustomCoordinator()
        registerParentCompositionalCoordinator()
        registerSwiftCoordinator()
        registerDetailCoordinator()
        registerPickListCoordinator()
    }
}

// MARK: Register - ViewModel
extension PresentationDIContainer {
    private func registerParentCustomViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return }
        let viewModel = ParentCustomViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.parentCustom.rawValue, viewModel)
    }
    
    private func registerParentCompositionalViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return }
        let parentViewModel = ParentCompositionalViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.parentCompo.rawValue, parentViewModel)
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
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return }
        let viewModel = PickListViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.pickList.rawValue, viewModel)
    }
    
    private func createChildCompositionViewModel(_ categorys: [ChildCompositionalViewModel.Category]) -> [ChildCompositionalViewModel] {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return []}
        var viewModelArray: [ChildCompositionalViewModel] = []
        for _ in categorys {
            let viewModel = ChildCompositionalViewModel(dynamicUseCase: dynamicUseCase)
            viewModelArray.append(viewModel)
        }
        
        return viewModelArray
    }
    
    private func createCustomViewModel(_ categorys: [CustomViewModel.Category]) -> [CustomViewModel] {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.dynamicUC.rawValue) else { return []}
        var viewModelArray: [CustomViewModel] = []
        for _ in categorys {
            let viewModel = CustomViewModel(dynamicUseCase: dynamicUseCase)
            viewModelArray.append(viewModel)
        }
        
        return viewModelArray
    }
}

// MARK: Register - ViewController
extension PresentationDIContainer {
    private func registerParentCustomViewController() {
        guard let viewModel: ParentCustomViewModel = container.resolveValue(VMKeys.parentCustom.rawValue) else { return }
        let viewController = ParentCustomViewController(viewModel: viewModel)
        container.registerValue(VCKeys.parentCustom.rawValue, viewController)
    }
    
    private func registerCompositionalViewController() {
        guard let parentViewModel: ParentCompositionalViewModel = container.resolveValue(VMKeys.parentCompo.rawValue) else { return }
        let parentCompositionalViewController = ParentCompositionalViewController(viewModel: parentViewModel)
        container.registerValue(VCKeys.parentCompo.rawValue, parentCompositionalViewController)
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
    
    private func createCategoryViewControllers() -> [ChildCompositionalViewController] {
        let categorys = ChildCompositionalViewModel.categorys
        let viewModels = createChildCompositionViewModel(categorys)
        var categoryViewControllers: [ChildCompositionalViewController] = []
        var viewModelCount = 0
        categorys.forEach {
            let viewController = ChildCompositionalViewController(
                viewModel: viewModels[viewModelCount],
                category: $0
            )
            categoryViewControllers.append(viewController)
            viewModelCount += 1
        }
        return setupCompositionalViewControllerContainCoordinator(categoryViewControllers)
    }
    
    private func createCustomCategoryViewControllers() -> [CustomViewController] {
        let categorys = CustomViewModel.categorys
        let viewModels = createCustomViewModel(categorys)
        var categoryViewControllers: [CustomViewController] = []
        var viewModelCount = 0
        categorys.forEach {
            let viewController = CustomViewController(
                viewModel: viewModels[viewModelCount],
                category: $0
            )
            categoryViewControllers.append(viewController)
            viewModelCount += 1
        }
        return setupCustomViewControllerContainCoordinator(categoryViewControllers)
    }
}

// MARK: Register - Coordinator
extension PresentationDIContainer {
    private func registerParentCustomCoordinator() {
        guard let viewController: ParentCustomViewController = container.resolveValue(VCKeys.parentCustom.rawValue) else { return }
        let coordinator = ParentCustomCoordinator.init(parentCoordinator: nil,
                                                       viewController: viewController)
        let viewControllers: [CustomViewController] = createCustomCategoryViewControllers()
        coordinator.navigationController = UINavigationController()
        coordinator.childViewControllers = viewControllers
        container.registerValue(CodiKeys.parentCustom.rawValue, coordinator)
    }
    
    private func registerParentCompositionalCoordinator() {
        guard let viewController: ParentCompositionalViewController = container.resolveValue(VCKeys.parentCompo.rawValue) else { return }
        let coordinator = ParentCompositionalCoordinator(parentCoordinator: nil,
                                                         viewController: viewController)
        let viewControllers: [ChildCompositionalViewController] = createCategoryViewControllers()
        coordinator.navigationController = UINavigationController()
        coordinator.childViewControllers = viewControllers
        container.registerValue(CodiKeys.parentCompo.rawValue, coordinator)
    }
    
    private func registerSwiftCoordinator() {
        guard let viewController: SwiftUIViewController = container.resolveValue(VCKeys.swiftUI.rawValue) else { return }
        let coordinator = SwiftUICoordinator(parentCoordinator: nil,
                                             viewController: viewController)
        coordinator.navigationController = UINavigationController()
        container.registerValue(CodiKeys.swift.rawValue, coordinator)
    }
    
    private func registerDetailCoordinator() {
        guard let viewController: DetailViewController = container.resolveValue(VCKeys.detail.rawValue) else { return }
        let coordinator = DetailCoordinator(parentCoordinator: nil,
                                            viewController: viewController)
        container.registerValue(CodiKeys.detail.rawValue, coordinator)
    }
    
    private func registerPickListCoordinator() {
        guard let viewController: PickListViewController = container.resolveValue(VCKeys.pickList.rawValue) else { return }
        let coordinator = PickListCoordinator(parentCoordinator: nil,
                                              viewController: viewController)
        
        container.registerValue(CodiKeys.pickList.rawValue, coordinator)
    }
    
    private func setupCompositionalViewControllerContainCoordinator(_ viewControllers: [ChildCompositionalViewController]) -> [ChildCompositionalViewController] {
        var viewControllerArray: [ChildCompositionalViewController] = []
        viewControllers.forEach {
            let coordinator = ChildCompositionalCoordinator(parentCoordinator: nil,
                                                            viewController: $0)
            $0.coordinator = coordinator
            coordinator.navigationController = UINavigationController()
            viewControllerArray.append($0)
        }
        
        return viewControllerArray
    }
    
    private func setupCustomViewControllerContainCoordinator(_ viewControllers: [CustomViewController]) -> [CustomViewController]{
        var viewControllerArray: [CustomViewController] = []
        viewControllers.forEach {
            let coordinator = CustomCoordinator(parentCoordinator: nil, viewController: $0)
            $0.coordinator = coordinator
            coordinator.navigationController = UINavigationController()
            viewControllerArray.append($0)
        }
        
        return viewControllerArray
    }
}


extension PresentationDIContainer {
    private func registerTabBar() {
        guard let customCoordinator: ParentCustomCoordinator = container.resolveValue(CodiKeys.parentCustom.rawValue),
              let compositionalCoordinator: ParentCompositionalCoordinator = DIContainer.shared.resolveValue(CodiKeys.parentCompo.rawValue),
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
