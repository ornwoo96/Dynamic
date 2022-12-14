//
//  ParentCustomViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation
import Combine
import DynamicDomain

protocol ParentCustomViewModelInputProtocol: AnyObject {
    func changeIndex(_ tag: Int)
    func action(_ action: ParentCustomViewModel.Action)
}

protocol ParentCustomViewModelOutputProtocol: AnyObject {
    func readIndex() -> Int
}

protocol ParentCustomViewModelProtocol: ParentCustomViewModelInputProtocol, ParentCustomViewModelOutputProtocol {
    var pageViewControllerPreviousIndex: Int { get set }
    var event: CurrentValueSubject<ParentCustomViewModel.Event, Never> { get set }
}

public class ParentCustomViewModel: ParentCustomViewModelProtocol {
    internal var pageViewControllerPreviousIndex = 0
    internal var event = CurrentValueSubject<Event, Never>(.none)
    private let fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol
    private var favoritesCount = 0
    private var currentNavigationBarState = CustomNavigationBarState.show
    
    init(fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol) {
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            retrieveSavingDataCountFromCoreData()
        case .categoryButtonDidTap(let tag, let viewController):
            branchCategoryViewTags(tag, viewController)
            event.send(.animateShowNavigationBar)
        case .receiveFavoritesCountData(let count):
            favoritesCount += count
            event.send(.setupPickListButtonCount(favoritesCount))
        case .customNavigationBarState(state: let state):
            branchNavigationBar(state: state)
        }
    }
    
    func changeIndex(_ tag: Int) {
        self.pageViewControllerPreviousIndex = tag
        event.send(.animateShowNavigationBar)
    }
    
    func readIndex() -> Int {
        return pageViewControllerPreviousIndex
    }
    
    private func branchNavigationBar(state: CustomNavigationBarState) {
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
                                        _ viewController: CustomViewController) {
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
