//
//  PickListViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import DynamicDomain
import Combine

internal protocol PickListViewModelInputProtocol: AnyObject {
    
}

internal protocol PickListViewModelOutputProtocol: AnyObject {
    
}

internal protocol PickListViewModelProtocol: PickListViewModelInputProtocol, PickListViewModelOutputProtocol {
    var event: CurrentValueSubject<PickListViewModel.Event, Never> { get set }
    var contents: [FavoriteDomainModel] { get }

    func action(_ action: PickListViewModel.Action)
}

internal class PickListViewModel: PickListViewModelProtocol {
    private var removeFavoritesUseCase: RemoveFavoritesUseCaseProtocol
    private var fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol
    var event: CurrentValueSubject<Event, Never> = .init(.none)
    var contents: [FavoriteDomainModel] = []
    
    init(removeFavoritesUseCase: RemoveFavoritesUseCaseProtocol,
         fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol) {
        self.removeFavoritesUseCase = removeFavoritesUseCase
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            retrieveFavoriteDataFromCoreData()
        case .viewNeededCalculateLayout:
            break
        case .didSelectedItemAtLongPressed(indexPath: let indexPath):
            removeFavoriteData(indexPath)
        case .viewDidDisappear:
            NotificationCenter.default.post(name: NSNotification.Name("PickListViewDidDisappear"),
                                            object: nil)
        }
    }
    
    private func removeFavoriteData(_ indexPath: IndexPath) {
        let id = contents[indexPath.item].id
        removeFavoritesUseCase.requestRemoveImageDataFromCoreData(id)
        event.send(.deleteItem(indexPath))
    }
    
    private func retrieveFavoriteDataFromCoreData() {
        Task {
            do {
                let data = try await fetchFavoritesUseCase.retrieveGIPHYDataFromCoreData()
                self.contents = data
                event.send(.invalidateLayout)
            } catch {
                
            }
        }
    }
}
