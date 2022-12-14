//
//  CustomViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine

import DynamicDomain

protocol CustomViewModelInputProtocol: AnyObject {
    
}

protocol CustomViewModelOutputProtocol: AnyObject {
    
}

protocol CustomViewModelProtocol: CustomViewModelInputProtocol, CustomViewModelOutputProtocol {
    var previewImageDataSubject: CurrentValueSubject<CustomPresentationModel, Never> { get }
}

final class CustomViewModel: CustomViewModelProtocol {
    var dynamicUseCase: DynamicUseCase
    
    public let previewImageDataSubject = CurrentValueSubject<CustomPresentationModel, Never>(CustomPresentationModel.empty)
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            retrieveGIPHYData()
        case .viewNeededCalculateLayout: break
            
        case .didSelectItemAt(indexPath: _): break
            
        case .willDisplay(indexPath: _): break
            
        }
    }
    
    private func retrieveGIPHYData() {
        Task { [weak self] in
            do {
                let model = try await dynamicUseCase.retrieveGIPHYDatas()
                self?.previewImageDataSubject.send(CustomPresentationModel.init(domainModel: model))
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
}
