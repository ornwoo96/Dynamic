//
//  DetailViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import Combine
import DynamicDomain

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
                guard let imageData = try await self?.dynamicUseCase.retrieveGIFImage(url) else {
                    return
                }
                self?.imageDataSubject.send(imageData)
            } catch {
                print("OriginalImage Retrieve - 실패")
            }
        }
    }
}
