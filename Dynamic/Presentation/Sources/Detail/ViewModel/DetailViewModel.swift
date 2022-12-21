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
}

protocol DetailViewModelProtocol: DetailViewModelInputProtocol, DetailViewModelOutputProtocol {
    func action(_ action: DetailViewModel.Action)
}

public class DetailViewModel: DetailViewModelProtocol {
    var dynamicUseCase: DynamicUseCase
    var imageDataSubject = CurrentValueSubject<Data, Never>(Data())
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad(let url):
            retrieveOriginalImage(url)
        }
    }
    
    private func retrieveOriginalImage(_ url: String) {
        Task { [weak self] in
            do {
                let imageData = try await ImageCacheManager.shared.imageLoad(url)
                self?.imageDataSubject.send(imageData)
            } catch {
                print("OriginalImage Retrieve - 실패")
            }
        }
    }
}
