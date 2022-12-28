//
//  CompositionalViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine
import DynamicDomain

public class ChildCompositionalViewModel: ChildCompositionalViewModelProtocol {
    public var event: CurrentValueSubject<Event, Never> = .init(.none)
    private let dynamicUseCase: DynamicUseCase
    private var previewContents: [CompositionalPresentationModel.PreviewModel] = []
    private var originalContents: [CompositionalPresentationModel.OriginalModel] = []
    private var sections: [Section] = []
    private var isCustomNavigationBarAnimationFirst: Bool = false
    private var offset = 0
    private var limit = 20
    private var category: Category = .Coding
    public var favoritesCount: CurrentValueSubject<Int, Never> = .init(0)
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            event.send(.showLoading)
            self.retrieveGIPHYData()
        case .didSelectItemAt(let indexPath):
            event.send(.showDetailView(content: convert(originalContents[indexPath.item])))
        case .willDisplay(let indexPath):
            self.retrieveNextData(indexPath.item)
        case .didSelectedItemAtLongPressed(indexPath: let indexPath):
            event.send(.showHeartView(indexPath: indexPath))
        case .scrollViewDidScroll(let yValue):
            self.branchNavigationAnimationForHideORShow(yValue)
        case .pullToRefresh:
            self.delayRetrieveData()
        }
    }
    
    public func setupCategory(_ category: ChildCompositionalViewModel.Category) {
        self.category = category
    }
    
    public func changeIsNavigationBarAnimation(_ bool: Bool) {
        self.isCustomNavigationBarAnimationFirst = bool
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
    
    private func delayRetrieveData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.event.send(.endRefreshing)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.retrieveGIPHYDataForRefresh()
        }
    }
    
    private func requestCreateImageDataToCoreData(_ indexPath: Int) {
        dynamicUseCase.requestCoreDataCreateImageData(convertOriginalDomain(originalContents[indexPath]))
    }
    
    private func requestRemoveImageDataToCoreData(_ indexPath: Int) {
        dynamicUseCase.requestRemoveImageDataFromCoreData(originalContents[indexPath].id)
    }
    
    private func retrieveGIPHYDataForRefresh() {
        
        Task { [weak self] in
            do {
                let model = try await dynamicUseCase.retrieveGIPHYDatas(category.rawValue, 0)
                let presentationModel = convertPresentationModel(model)
                self?.resetFetchData()
                self?.previewContents.append(contentsOf: presentationModel.previewModel)
                self?.originalContents.append(contentsOf: presentationModel.originalModel)
                setupSections(presentationModel.previewModel)
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
    
    private func resetFetchData() {
        sections = []
        previewContents = []
        originalContents = []
        offset = 0
    }
    
    private func retrieveGIPHYData() {
        Task { [weak self] in
            do {
                let model = try await dynamicUseCase.retrieveGIPHYDatas(category.rawValue, offset)
                let presentationModel = convertPresentationModel(model)
                self?.previewContents.append(contentsOf: presentationModel.previewModel)
                self?.originalContents.append(contentsOf: presentationModel.originalModel)
                setupSections(presentationModel.previewModel)
                offset += limit
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
    
    private func setupSections(_ data: [CompositionalPresentationModel.PreviewModel]) {
        if sections.isEmpty {
            sections.append(.init(type: .content, items: convertCellModel(data)))
            sections.append(.init(type: .content, items: convertCellModel(data)))
        } else {
            sections.first?.items.append(contentsOf: convertCellModel(data))
        }
        event.send(.reloadData(sections: sections))
        event.send(.hideLoading)
    }
    
    private func retrieveNextData(_ indexPath: Int) {
        if previewContents.count - 1 == indexPath,
           event.value != .showLoading {
            retrieveGIPHYData()
        }
    }
    
    private func branchNavigationAnimationForHideORShow(_ yValue: CGFloat) {
        if yValue > 1 {
            if self.isCustomNavigationBarAnimationFirst == false {
                self.isCustomNavigationBarAnimationFirst = true
                event.send(.animateHideBar)
            }
        } else {
            if self.isCustomNavigationBarAnimationFirst {
                self.isCustomNavigationBarAnimationFirst = false
                event.send(.animateShowBar)
            }
        }
    }
}

extension ChildCompositionalViewModel {
    public func getSectionItem(_ sectionIndex: Int) -> Section {
        return sections[sectionIndex]
    }
    
    public func getIsNavigationBarAnimation() -> Bool {
        return self.isCustomNavigationBarAnimationFirst
    }
    
}
