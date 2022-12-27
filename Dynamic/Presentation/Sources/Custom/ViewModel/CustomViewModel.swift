//
//  CustomViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine
import DynamicDomain

public class CustomViewModel: CustomViewModelProtocol {
    private var dynamicUseCase: DynamicUseCase
    public var event: CurrentValueSubject<Event, Never> = .init(.none)
    private var previewContents: [CustomPresentationModel.PresentationPreview] = []
    private var originalContents: [CustomPresentationModel.PresentationOriginal] = []
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
    
    public func retrieveCustomCellItem(_ indexPath: IndexPath) -> CustomCellItem {
        let urlString = self.previewContents[indexPath.item].url
        let favorite = self.previewContents[indexPath.item].favorite
        return CustomCellItem.init(favorite: favorite, imageUrl: urlString)
    }
    
    public func checkFavoriteButtonTapped(_ bool: Bool,
                                          _ indexPath: Int) {
        if bool {
            requestCreateImageDataToCoreData(indexPath)
        } else {
            requestRemoveImageDataToCoreData(indexPath)
        }
    }
    
    private func requestCreateImageDataToCoreData(_ indexPath: Int) {
        dynamicUseCase.requestCoreDataCreateImageData(convert(originalContents[indexPath]))
    }
    
    private func requestRemoveImageDataToCoreData(_ indexPath: Int) {
        dynamicUseCase.requestRemoveImageDataFromCoreData(originalContents[indexPath].id)
    }
    
    private func createDetailData(_ indexPath: Int) -> DetailModel {
        return convert(indexPath, originalContents)
    }
    
    private func checkLastCell(_ indexPath: Int) {
        if previewContents.count - 1 == indexPath,
           event.value != .showLoading {
            event.send(.showLoading)
            retrieveGIPHYData()
        }
    }
    
    private func retrieveGIPHYData() {
        Task { [weak self] in
            do {
//                let model = try await dynamicUseCase.retrieveGIPHYDatas()
//                self?.previewContents.append(contentsOf: convert(model.previewImages))
//                self?.originalContents.append(contentsOf: convert(model.originalImages))
//                
//                event.send(.invalidateLayout)
//                event.send(.hideLoading)
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
    
    private func createIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for i in previewContents.count-15..<previewContents.count {
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
        let string = previewContents[indexPath.item].height
        let height: CGFloat = CGFloat(Int(string))
        
        return height
    }
    
    public func collectionViewImageWidth(_ indexPath: IndexPath) -> CGFloat {
        let string = previewContents[indexPath.item].width
        let width: CGFloat = CGFloat(Int(string))
        
        return width
    }
    
    public func numberOfItemsInSection() -> Int {
        return previewContents.count
    }
}
