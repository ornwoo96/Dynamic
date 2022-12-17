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
    func action(_ action: CustomViewModel.Action)
    var previewImageDataSubject: CurrentValueSubject<CustomPresentationModel, Never> { get }
    func retrieveImageData(_ indexPath: IndexPath) async throws -> (Data, Bool)
}

class CustomViewModel: CustomViewModelProtocol {
    var dynamicUseCase: DynamicUseCase
    
    var event: CurrentValueSubject<Event, Never> = .init(.none)
    public let previewImageDataSubject = CurrentValueSubject<CustomPresentationModel, Never>(CustomPresentationModel.empty)
    private var originalImageDataArray: [String] = []
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            retrieveGIPHYData()
        case .viewNeededCalculateLayout: break
            
        case .didSelectItemAt(let indexPath):
            event.send(.showDetailView(createDetailData(indexPath.item)))
        case .willDisplay(indexPath: _): break
            
        case .didSelectedItemAtLongPressed(indexPath: let indexPath):
            event.send(.showHeartView(indexPath))
        }
    }
    
    public func retrieveImageData(_ indexPath: IndexPath) async throws -> (Data,Bool) {
        let urlString = self.previewImageDataSubject.value.contents.previewImages[indexPath.item].url
        let id = self.previewImageDataSubject.value.contents.previewImages[indexPath.item].id
        let previewData = try await dynamicUseCase.retrieveGIFImage(urlString, id)
        return previewData
    }
    
    public func checkFavoriteButtonTapped(_ bool: Bool,
                                          _ indexPath: Int) {
        if bool {
            requestCreateImageDataFromCoreData(indexPath)
        } else {
            requestRemoveImageDataFromCoreData(indexPath)
        }
    }
    
    private func requestCreateImageDataFromCoreData(_ indexPath: Int) {
        let imageData: OriginalDomainModel = previewImageDataSubject.value.contents.originalImages[indexPath]
        dynamicUseCase.requestCoreDataManagerForCreateImageData(imageData)
    }
    
    private func requestRemoveImageDataFromCoreData(_ indexPath: Int) {
        let id = previewImageDataSubject.value.contents.originalImages[indexPath].id
        dynamicUseCase.requestRemoveImageDataFromCoreData(id)
    }
    
    private func createDetailData(_ indexPath: Int) -> DetailModel {
        let data = previewImageDataSubject.value.contents.originalImages[indexPath].url
        let width = previewImageDataSubject.value.contents.originalImages[indexPath].width
        let height = previewImageDataSubject.value.contents.originalImages[indexPath].height
        
        return DetailModel(url: data, width: width, height: height)
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
