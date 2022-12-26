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

class ParentCompositionalViewModel: ParentCompositionalViewModelProtocol {
    internal var pageViewControllerPreviousIndex = 0
    internal var event = CurrentValueSubject<Event, Never>(.none)
    private let dynamicUseCase: DynamicUseCase
    private var favoritesCount = 0
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            retrieveSavingDataCountFromCoreData()
        case .categoryButtonDidTap(let tag, let viewController):
            branchCategoryViewTags(tag, viewController)
        case .receiveFavoritesCountData(let count):
            
            favoritesCount += count
            event.send(.setupPickListButtonCount(favoritesCount))
        }
    }
    
    func changeIndex(_ tag: Int) {
        self.pageViewControllerPreviousIndex = tag
    }
    
    func readIndex() -> Int {
        return pageViewControllerPreviousIndex
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
                let count = try await dynamicUseCase.requestFavoritesImageDataCountInCoreData()
                event.send(.setupPickListButtonCount(count))
                self.favoritesCount = count
            } catch {
                
            }
        }
    }
}
