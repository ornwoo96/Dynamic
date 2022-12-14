//
//  CustomViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine
import DynamicDomain
import DynamicCore

public class CustomViewModel: CustomViewModelProtocol {
    private var addFavoritesUseCase: AddFavoritesUseCaseProtocol
    private var removeFavoritesUseCase: RemoveFavoritesUseCaseProtocol
    private var imageSearchUseCase: ImageSearchUseCaseProtocol
    private var previewContents: [CustomPresentationModel.PresentationPreview] = []
    private var originalContents: [CustomPresentationModel.PresentationOriginal] = []
    private var originalImageDataArray: [String] = []
    private var offset = 0
    private var limit = 20
    private var category: Category = .Coding
    private var IsFirstResponse = true
    private var isRetrieveSuccess = false
    public var event: CurrentValueSubject<Event, Never> = .init(.none)
    public var favoritesCount: CurrentValueSubject<Int, Never> = .init(0)
    
    init(addFavoritesUseCase: AddFavoritesUseCaseProtocol,
         removeFavoritesUseCase: RemoveFavoritesUseCaseProtocol,
         imageSearchUseCase: ImageSearchUseCaseProtocol) {
        self.addFavoritesUseCase = addFavoritesUseCase
        self.removeFavoritesUseCase = removeFavoritesUseCase
        self.imageSearchUseCase = imageSearchUseCase
    }
    
    public func setupCategory(_ category: CustomViewModel.Category) {
        self.category = category
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            event.send(.showPageLoading)
            self.retrieveGIPHYData()
        case .viewNeededCalculateLayout:
            event.send(.invalidateLayout)
        case .didSelectItemAt(let indexPath):
            event.send(.showDetailView(createDetailData(indexPath.item)))
        case .willDisplay(indexPath: let indexPath):
            self.checkLastCell(indexPath.item)
        case .didSelectedItemAtLongPressed(indexPath: let indexPath):
            event.send(.showHeartView(indexPath))
        case .pullToRefresh:
            self.delayRetrieveData()
        case .scrollPanGestureAction(yValue: let yValue):
            self.branchScrollPanGestureAction(yValue: yValue)
        case .scrollViewDidScroll(let yValue):
            self.branchNavigationAnimationForHideORShow(yValue)
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
            favoritesCount.send(1)
        } else {
            requestRemoveImageDataToCoreData(indexPath)
            favoritesCount.send(-1)
        }
    }
    
    private func branchScrollPanGestureAction(yValue: Double) {
        if yValue < 0 {
            event.send(.animateHideBar)
        }
    }
    
    private func delayRetrieveData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.event.send(.endRefreshing)
            self?.event.send(.showPageLoading)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.retrieveGIPHYDataForRefresh()
        }
    }
    
    private func retrieveGIPHYDataForRefresh() {
        Task { [weak self] in
            do {
                let model = try await imageSearchUseCase.retrieveGIPHYDatas(category.rawValue, 0)
                self?.resetFetchData()
                let presentationModel = convertCustomPresentationModel(model)
                self?.previewContents.append(contentsOf: presentationModel.previewImageData)
                self?.originalContents.append(contentsOf: presentationModel.originalImageData)
                print("previewContents", previewContents.count)
                event.send(.invalidateLayout)
                event.send(.hideBottomLoading)
                event.send(.collectionViewReload)
                event.send(.hidePageLoading)
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
    
    private func resetFetchData() {
        previewContents.removeAll()
        originalContents.removeAll()
        offset = 20
        ImageCacheManager.shared.removeCacheData()
    }
    
    private func requestCreateImageDataToCoreData(_ indexPath: Int) {
        addFavoritesUseCase.requestCoreDataCreateImageData(convert(previewContents[indexPath]))
    }
    
    private func requestRemoveImageDataToCoreData(_ indexPath: Int) {
        removeFavoritesUseCase.requestRemoveImageDataFromCoreData(previewContents[indexPath].id)
    }
    
    private func createDetailData(_ indexPath: Int) -> DetailModel {
        return convert(indexPath, originalContents)
    }
    
    private func checkLastCell(_ indexPath: Int) {
        if previewContents.count - 1 == indexPath,
           event.value != .showBottomLoading {
            event.send(.showBottomLoading)
            retrieveGIPHYData()
        }
    }
        
    private func retrieveGIPHYData() {
        Task { [weak self] in
            do {
                let model = try await imageSearchUseCase.retrieveGIPHYDatas(category.rawValue, offset)
                let presentationModel = convertCustomPresentationModel(model)
                self?.previewContents.append(contentsOf: presentationModel.previewImageData)
                self?.originalContents.append(contentsOf: presentationModel.originalImageData)
                isRetrieveSuccess = true
                event.send(.invalidateLayout)
                event.send(.hideBottomLoading)
                event.send(.hidePageLoading)
                offset += limit
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
    
    private func createIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for i in previewContents.count-20..<previewContents.count {
            let indexPath = IndexPath(item: i, section: 0)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    public func branchNavigationAnimationForHideORShow(_ yValue: CGFloat) {
        if yValue > 1 {
            if IsFirstResponse == true {
                event.send(.animateHideBar)
                IsFirstResponse = false
            }
        } else {
            event.send(.animateShowBar)
            IsFirstResponse = true
        }
    }
}

extension CustomViewModel {
    public func scrollViewDidEndDecelerating() {
        if event.value == .showBottomLoading {
            if isRetrieveSuccess {
                event.send(.showRetrievedCells(createIndexPaths()))
                isRetrieveSuccess = false
            }
        }
        event.send(.hideBottomLoading)
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
