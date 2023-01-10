//
//  DetailViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import Combine
import DynamicDomain
import DynamicCore

protocol DetailViewModelInputProtocol: AnyObject {
    
}

protocol DetailViewModelOutputProtocol: AnyObject {
    var imageDataSubject: CurrentValueSubject<Data, Never> { get }
    var event: CurrentValueSubject<DetailViewModel.Event, Never> { get }
}

protocol DetailViewModelProtocol: DetailViewModelInputProtocol, DetailViewModelOutputProtocol {
    func action(_ action: DetailViewModel.Action)
}

public class DetailViewModel: DetailViewModelProtocol {
    var imageDataSubject = CurrentValueSubject<Data, Never>(Data())
    var event = CurrentValueSubject<DetailViewModel.Event, Never>(.none)
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad(let url):
            event.send(.showLoading)
            retrieveOriginalImage(url)
        }
    }
    
    private func retrieveOriginalImage(_ url: String) {
        Task { [weak self] in
            do {
                let imageData = try await ImageCacheManager.shared.imageLoad(url)
                self?.imageDataSubject.send(imageData)
                event.send(.hideLoading)
            } catch {
                print("OriginalImage Retrieve - 실패")
            }
        }
    }
}
