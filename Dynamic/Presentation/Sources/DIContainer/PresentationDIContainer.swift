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
    private let navigationController: UINavigationController
    private var viewControllers: [UIViewController] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func register() {
        registerViewModels()
        registerViewControllers()
        registerCoordinators()
    }
    
    private func registerViewModels() {
        registerCustomViewModel()
        registerCompositionalViewModel()
        registerSwiftUIViewModel()
    }
    
    private func registerViewControllers() {
        registerCustomViewController()
        registerSwiftUIViewController()
        registerCompositionalViewController()
    }
    
    private func registerCoordinators() {
        registerCustomCoordinator()
        registerCompositionalCoordinator()
        registerSwiftCoordinator()
        registerTabBarCoordinator()
    }
}

// MARK: Register - Coordinator
extension PresentationDIContainer {
    private func registerCustomCoordinator() {
        let coordinator = CustomCoordinator(navigationController: UINavigationController())
        container.registerValue(CodiKeys.custom.rawValue, coordinator)
    }
    
    private func registerCompositionalCoordinator() {
        let coordinator = CompositionalCoordinator(navigationController: UINavigationController())
        container.registerValue(CodiKeys.compo.rawValue, coordinator)
    }
    
    private func registerSwiftCoordinator() {
        let coordinator = SwiftUICoordinator(navigationController: UINavigationController())
        container.registerValue(CodiKeys.swift.rawValue, coordinator)
    }
    
    private func registerTabBarCoordinator() {
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        container.registerValue(CodiKeys.tabBar.rawValue, coordinator)
    }
}

// MARK: Register - ViewController
extension PresentationDIContainer {
    private func registerCustomViewController() {
        guard let viewModel: CustomViewModel = container.resolveValue(VMKeys.CustomVM.rawValue) else { return }
        let viewController = CustomViewController(viewModel: viewModel)
        container.registerValue(VCKeys.CustomVC.rawValue, viewController)
    }
    
    private func registerCompositionalViewController() {
        guard let viewModel: CompositionalViewModel = container.resolveValue(VMKeys.CompoVM.rawValue) else { return }
        let viewController = CompositionalViewController(viewModel: viewModel)
        container.registerValue(VCKeys.CompoVC.rawValue, viewController)
    }
    
    private func registerSwiftUIViewController() {
        guard let viewModel: SwiftUIViewModel = container.resolveValue(VMKeys.SwiftUIVM.rawValue) else { return }
        let viewController = SwiftUIViewController(viewModel: viewModel)
        container.registerValue(VCKeys.SwiftUI.rawValue, viewController)
    }
}

// MARK: Register - ViewModel
extension PresentationDIContainer {
    private func registerCustomViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.DynamicUC.rawValue) else { return }
        let viewModel = CustomViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.CustomVM.rawValue, viewModel)
    }
    
    private func registerCompositionalViewModel() {
        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.DynamicUC.rawValue) else { return }
        let viewModel = CompositionalViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.CompoVM.rawValue, viewModel)
    }
    
    private func registerSwiftUIViewModel() {

        guard let dynamicUseCase: DynamicUseCase = container.resolveValue(UCKeys.DynamicUC.rawValue) else { return }
        let viewModel = DynamicPresentation.SwiftUIViewModel(dynamicUseCase: dynamicUseCase)
        container.registerValue(VMKeys.SwiftUIVM.rawValue, viewModel)
    }
}
