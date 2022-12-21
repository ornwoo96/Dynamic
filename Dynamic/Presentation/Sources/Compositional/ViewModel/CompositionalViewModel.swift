//
//  CompositionalViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine
import DynamicDomain

public class CompositionalViewModel: CompositionalViewModelProtocol {
    public var event: CurrentValueSubject<Event, Never> = .init(.none)
    private let dynamicUseCase: DynamicUseCase
    private var previewContents: [CompositionalPresentationModel.PreviewModel] = []
    private var originalContents: [CompositionalPresentationModel.OriginalModel] = []
    private var sections: [Section] = []
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad:
            self.retrieveGIPHYData()
        case .didSelectItemAt(_):
            break
        case .willDisplay(let indexPath):
            self.retrieveNextData(indexPath.item)
        }
    }
    
    private func retrieveGIPHYData() {
        Task { [weak self] in
            do {
                let model = try await dynamicUseCase.retrieveGIPHYDatas()
                self?.previewContents.append(contentsOf: convertPresentationModel(model).previewModel)
                self?.originalContents.append(contentsOf: convertPresentationModel(model).originalModel)
                
                setupSections(convertPresentationModel(model).previewModel)
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
    
    private func setupSections(_ data: [CompositionalPresentationModel.PreviewModel]) {
        if sections.isEmpty {
            
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
            event.send(.showLoading)
            retrieveGIPHYData()
        }
    }
}

extension CompositionalViewModel {
    public func getSectionItem(_ sectionIndex: Int) -> Section {
        return sections[sectionIndex]
    }
}
