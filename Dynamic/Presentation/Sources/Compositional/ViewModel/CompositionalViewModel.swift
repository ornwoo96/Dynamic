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
    private var previewContents: [CompoPresentationModel.PreviewModel] = []
    private var originalContents: [CompoPresentationModel.OriginalModel] = []
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
        case .willDisplay(_):
            break
        }
    }
    
    public func retrieveImageData(_ indexPath: IndexPath) async throws -> (Data, Bool) {
        return try await dynamicUseCase.retrieveGIFImage(
            previewContents[indexPath.item].url,
            previewContents[indexPath.item].id
        )
    }
    
    private func retrieveGIPHYData() {
        Task { [weak self] in
            do {
                let model = try await dynamicUseCase.retrieveGIPHYDatas()
                self?.previewContents.append(contentsOf: convert(model).previewModel)
                self?.originalContents.append(contentsOf: convert(model).originalModel)
                setupSections(convert(model).previewModel)
            } catch {
                print("viewModel PreviewImage - 가져오기 실패")
            }
        }
    }
    
    private func setupSections(_ data: [CompoPresentationModel.PreviewModel]) {
        if sections.isEmpty {
            sections.append(.init(type: .content, items: convert(data)))
        } else {
            sections.first?.items.append(contentsOf: convert(data))
        }
        event.send(.reloadData(sections: sections))
        event.send(.hideLoading)
    }
}

extension CompositionalViewModel {
    public func getSectionItem(_ sectionIndex: Int) -> CompositionalViewModel.Section {
        return sections[sectionIndex]
    }
}
