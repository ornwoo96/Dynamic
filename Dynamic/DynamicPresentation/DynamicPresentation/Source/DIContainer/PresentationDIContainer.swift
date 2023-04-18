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
        registerDetailViewModel()
        registerPickListViewModel()
        registerParentCompositionalViewModel()
    }
    
    private func registerViewControllers() {
        registerCompositionalViewController()
        registerDetailViewController()
        registerPickListViewController()
    }
    
    private func registerCoordinators() {
        registerParentCompositionalCoordinator()
        registerDetailCoordinator()
        registerPickListCoordinator()
    }
}

// MARK: Register - ViewModel
extension PresentationDIContainer {
    
    private func registerParentCompositionalViewModel() {
        guard let fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol = container.resolveValue(UCKeys.fetchFavorites.rawValue) else { return }
        let parentViewModel = ParentCompositionalViewModel(fetchFavoritesUseCase: fetchFavoritesUseCase)
        container.registerValue(VMKeys.parentCompo.rawValue, parentViewModel)
    }
    
    
    private func registerDetailViewModel() {
        let viewModel = DetailViewModel()
        container.registerValue(VMKeys.detail.rawValue, viewModel)
    }
    
    private func registerPickListViewModel() {
        guard let removeFavoritesUseCase: RemoveFavoritesUseCaseProtocol = container.resolveValue(UCKeys.removeFavorites.rawValue),
        let fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol = container.resolveValue(UCKeys.fetchFavorites.rawValue) else { return }
        let viewModel = PickListViewModel(removeFavoritesUseCase: removeFavoritesUseCase,
                                          fetchFavoritesUseCase: fetchFavoritesUseCase)
        container.registerValue(VMKeys.pickList.rawValue, viewModel)
    }
    
    private func createChildCompositionViewModel(_ categorys: [ChildCompositionalViewModel.Category]) -> [ChildCompositionalViewModel] {
        guard let addFavoritesUseCase: AddFavoritesUseCaseProtocol = container.resolveValue(UCKeys.addFavorites.rawValue),
              let removeFavoritesUseCase: RemoveFavoritesUseCaseProtocol = container.resolveValue(UCKeys.removeFavorites.rawValue),
              let imageSearchUseCase: ImageSearchUseCaseProtocol = container.resolveValue(UCKeys.search.rawValue) else {
            return []
        }
        
        var viewModelArray: [ChildCompositionalViewModel] = []
        
        categorys.forEach { _ in
            let viewModel = ChildCompositionalViewModel(addFavoritesUseCase: addFavoritesUseCase,
                                                        removeFavoritesUseCase: removeFavoritesUseCase,
                                                        imageSearchUseCase: imageSearchUseCase)
            viewModelArray.append(viewModel)
        }
        
        return viewModelArray
    }
}

// MARK: Register - ViewController
extension PresentationDIContainer {
    private func registerCompositionalViewController() {
        guard let parentViewModel: ParentCompositionalViewModel = container.resolveValue(VMKeys.parentCompo.rawValue) else { return }
        let parentCompositionalViewController = ParentCompositionalViewController(viewModel: parentViewModel)
        container.registerValue(VCKeys.parentCompo.rawValue, parentCompositionalViewController)
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
}

// MARK: Register - Coordinator
extension PresentationDIContainer {
    
    private func registerParentCompositionalCoordinator() {
        guard let viewController: ParentCompositionalViewController = container.resolveValue(VCKeys.parentCompo.rawValue) else { return }
        let coordinator = ParentCompositionalCoordinator(parentCoordinator: nil,
                                                         viewController: viewController)
        let viewControllers: [ChildCompositionalViewController] = createCategoryViewControllers()
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        coordinator.navigationController = navigationController
        coordinator.childViewControllers = viewControllers
        container.registerValue(CodiKeys.parentCompo.rawValue, coordinator)
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
            let navigationController = UINavigationController()
            navigationController.isNavigationBarHidden = true
            coordinator.navigationController = navigationController
            viewControllerArray.append($0)
        }
        
        return viewControllerArray
    }
}


extension PresentationDIContainer {
    private func registerTabBar() {
        guard let compositionalCoordinator: ParentCompositionalCoordinator = DIContainer.shared.resolveValue(CodiKeys.parentCompo.rawValue) else { return }
        
        guard let compositionalNavigationController: UINavigationController = compositionalCoordinator.navigationController else { return }
    
        let initialViewController = TabBarController(compoTab: compositionalNavigationController)
        let tabBarCoordinator = TabBarCoordinator(parentCoordinator: nil,
                                                  viewController: initialViewController)
        
        initialViewController.coordinator = tabBarCoordinator
        tabBarCoordinator.viewController = initialViewController
        container.registerValue(CodiKeys.tabBar.rawValue, tabBarCoordinator)
    }
}
