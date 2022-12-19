//
//  PickListViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import DynamicDomain
import Combine

protocol PickListViewModelInputProtocol: AnyObject {
    
}

protocol PickListViewModelOutputProtocol: AnyObject {
    
}

protocol PickListViewModelProtocol: PickListViewModelInputProtocol, PickListViewModelOutputProtocol {
    var event: CurrentValueSubject<PickListViewModel.Event, Never> { get set }
    var contents: [FavoriteDomainModel] { get }

    func action(_ action: PickListViewModel.Action)
}

class PickListViewModel: PickListViewModelProtocol {
    private var dynamicUseCase: DynamicUseCase
    var event: CurrentValueSubject<Event, Never> = .init(.none)
    var contents: [FavoriteDomainModel] = []
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
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
            self.contents = []
        }
    }
    
    private func removeFavoriteData(_ indexPath: IndexPath) {
        let id = contents[indexPath.item].id
        dynamicUseCase.requestRemoveImageDataFromCoreData(id)
        event.send(.deleteItem(indexPath))
    }
    
    private func retrieveFavoriteDataFromCoreData() {
        Task {
            do {
                let data = try await dynamicUseCase.retrieveGIPHYDataFromCoreData()
                contents.append(contentsOf: data)
                event.send(.invalidateLayout)
            } catch {
                
            }
        }
    }
}
