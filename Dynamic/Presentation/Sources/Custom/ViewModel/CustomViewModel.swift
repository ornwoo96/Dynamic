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
    var contents: GIPHYDomainModel { get }

    func action(_ action: CustomViewModel.Action)
    func retrieveImageData(_ indexPath: IndexPath) async throws -> (Data, Bool)
}

class CustomViewModel: CustomViewModelProtocol {
    var dynamicUseCase: DynamicUseCase
    
    var event: CurrentValueSubject<Event, Never> = .init(.none)
    public var contents = GIPHYDomainModel.empty
    private var originalImageDataArray: [String] = []
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            retrieveGIPHYData()
        case .viewNeededCalculateLayout:
            event.send(.invalidateLayout)
        case .didSelectItemAt(let indexPath):
            event.send(.showDetailView(createDetailData(indexPath.item)))
        case .willDisplay(indexPath: let indexPath):
            checkLastCell(indexPath.item)
        case .didSelectedItemAtLongPressed(indexPath: let indexPath):
            event.send(.showHeartView(indexPath))
        }
    }
    
    public func retrieveImageData(_ indexPath: IndexPath) async throws -> (Data,Bool) {
        let urlString = self.contents.previewImages[indexPath.item].url
        let id = self.contents.previewImages[indexPath.item].id
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
        let imageData: OriginalDomainModel = contents.originalImages[indexPath]
        dynamicUseCase.requestCoreDataManagerForCreateImageData(imageData)
    }
    
    private func requestRemoveImageDataFromCoreData(_ indexPath: Int) {
        let id = contents.originalImages[indexPath].id
        dynamicUseCase.requestRemoveImageDataFromCoreData(id)
    }
    
    private func createDetailData(_ indexPath: Int) -> DetailModel {
        let data = contents.originalImages[indexPath].url
        let width = contents.originalImages[indexPath].width
        let height = contents.originalImages[indexPath].height
        
        return DetailModel(url: data, width: width, height: height)
    }
    
    private func checkLastCell(_ indexPath: Int) {
        // MARK: 마지막 데이터가 맞냐?
        if contents.previewImages.count - 1 == indexPath,
           event.value != .showLoading {
            event.send(.showLoading)
            retrieveGIPHYData()
        }
        
    }
    
    private func retrieveGIPHYData() {
        Task { [weak self] in
            do {
                let model = try await dynamicUseCase.retrieveGIPHYDatas()
                self?.contents.previewImages.append(contentsOf: model.previewImages)
                self?.contents.originalImages.append(contentsOf: model.originalImages)
                
                event.send(.invalidateLayout)
                event.send(.hideLoading)
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
}
