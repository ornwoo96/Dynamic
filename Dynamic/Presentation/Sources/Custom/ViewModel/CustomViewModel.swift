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
    func action(_ action: CustomViewModel.Action)
}

protocol CustomViewModelOutputProtocol: AnyObject {
    var contents: GIPHYDomainModel { get }
    func retrieveImageData(_ indexPath: IndexPath) async throws -> (Data, Bool)
}

protocol CustomViewModelProtocol: CustomViewModelInputProtocol, CustomViewModelOutputProtocol {
    var event: CurrentValueSubject<CustomViewModel.Event, Never> { get set }
}

class CustomViewModel: CustomViewModelProtocol {
    private var dynamicUseCase: DynamicUseCase
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
    
    private func createIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for i in contents.previewImages.count-15..<contents.previewImages.count {
            let indexPath = IndexPath(item: i, section: 0)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
}

extension CustomViewModel {
    public func scrollViewDidEndDecelerating() {
        if event.value == .showLoading {
            event.send(.showRetrievedCells(createIndexPaths()))
        }
        event.send(.hideLoading)
    }
    
    public func collectionViewImageHeight(_ indexPath: IndexPath) -> CGFloat {
        let string = contents.previewImages[indexPath.item].height
        let height: CGFloat = CGFloat(Int(string) ?? 0)
        
        return height
    }
    
    public func collectionViewImageWidth(_ indexPath: IndexPath) -> CGFloat {
        let string = contents.previewImages[indexPath.item].width
        let width: CGFloat = CGFloat(Int(string) ?? 0)
        
        return width
    }
    
    public func numberOfItemsInSection() -> Int {
        return contents.originalImages.count
    }
}
