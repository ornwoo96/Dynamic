//
//  ParentCompositionalViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/24.
//

import Foundation
import Combine
import DynamicDomain

protocol ParentCompositionalViewModelInputProtocol: AnyObject {
    func changeIndex(_ tag: Int)
    func action(_ action: ParentCompositionalViewModel.Action)
}

protocol ParentCompositionalViewModelOutputProtocol: AnyObject {
    func readIndex() -> Int
}

protocol ParentCompositionalViewModelProtocol: ParentCompositionalViewModelInputProtocol, ParentCompositionalViewModelOutputProtocol {
    var pageViewControllerPreviousIndex: Int { get set }
    var event: CurrentValueSubject<ParentCompositionalViewModel.Event, Never> { get set }
}

public class ParentCompositionalViewModel: ParentCompositionalViewModelProtocol {
    internal var pageViewControllerPreviousIndex = 0
    internal var event = CurrentValueSubject<Event, Never>(.none)
    private let fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol
    private var favoritesCount = 0
    private var currentNavigationBarState = NavigationBarState.show
    
    init(fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol) {
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            retrieveSavingDataCountFromCoreData()
        case .categoryButtonDidTap(let tag, let viewController):
            currentNavigationBarState = .show
            branchCategoryViewTags(tag, viewController)
            event.send(.animateShowNavigationBar)
        case .receiveFavoritesCountData(let count):
            favoritesCount += count
            event.send(.setupPickListButtonCount(favoritesCount))
        case .navigationBarState(state: let state):
            branchNavigationBar(state: state)
        }
    }
    
    func changeIndex(_ tag: Int) {
        currentNavigationBarState = .show
        self.pageViewControllerPreviousIndex = tag
        event.send(.animateShowNavigationBar)
    }
    
    func readIndex() -> Int {
        return pageViewControllerPreviousIndex
    }
    
    private func branchNavigationBar(state: NavigationBarState) {
        switch state {
        case .hide:
            if currentNavigationBarState == .show {
                event.send(.animateHideNavigationBar)
                currentNavigationBarState = .hide
            }
        case .show:
            if currentNavigationBarState == .hide {
                event.send(.animateShowNavigationBar)
                currentNavigationBarState = .show
            }
        }
    }
    
    private func branchCategoryViewTags(_ tag: Int,
                                _ viewController: ChildCompositionalViewController) {
        if tag > self.pageViewControllerPreviousIndex {
            self.event.send(.setViewControllersToForward(viewController))
            self.pageViewControllerPreviousIndex = tag
        } else {
            self.event.send(.setViewControllersToReverse(viewController))
            self.pageViewControllerPreviousIndex = tag
        }
    }
    
    private func retrieveSavingDataCountFromCoreData()  {
        Task {
            do {
                let count = try await fetchFavoritesUseCase.requestFavoritesImageDataCountInCoreData()
                event.send(.setupPickListButtonCount(count))
                self.favoritesCount = count
            } catch {
                
            }
        }
    }
}
