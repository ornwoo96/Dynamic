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
        registerParentCompositionalViewModel()
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
        registerParentCompositionalCoordinator()
        registerSwiftCoordinator()
        registerDetailCoordinator()
        registerPickListCoordinator()
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
        let childViewModel = ChildCompositionalViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.compoVM.rawValue, childViewModel)
    }
    
    private func registerParentCompositionalViewModel() {
        let parentViewModel = ParentCompositionalViewModel()
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
}

// MARK: Register - ViewController
extension PresentationDIContainer {
    private func registerCustomViewController() {
        guard let viewModel: CustomViewModel = container.resolveValue(VMKeys.customVM.rawValue) else { return }
        let viewController = CustomViewController(viewModel: viewModel)
        container.registerValue(VCKeys.customVC.rawValue, viewController)
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
        guard let viewModel: ChildCompositionalViewModel = container.resolveValue(VMKeys.compoVM.rawValue) else { return []}
        let categorys: [ChildCompositionalViewModel.Category] = [.Coding, .Cats, .Christmas, .Dogs, .Memes, .Oops]
        var categoryViewControllers: [ChildCompositionalViewController] = []
        categorys.forEach {
            let viewController = ChildCompositionalViewController(viewModel: viewModel,
                                                                  category: $0)
            categoryViewControllers.append(viewController)
        }
        return setupViewControllerContainCoordinator(categoryViewControllers)
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
    
    // MARK: ChildVIewCOntroller 를 ParentCoordinator 로 위치변경
    private func setupViewControllerContainCoordinator(_ viewControllers: [ChildCompositionalViewController]) -> [ChildCompositionalViewController] {
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
}


extension PresentationDIContainer {
    private func registerTabBar() {
        guard let customCoordinator: CustomCoordinator = container.resolveValue(CodiKeys.custom.rawValue),
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
