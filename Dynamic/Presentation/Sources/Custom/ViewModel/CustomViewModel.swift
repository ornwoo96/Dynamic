//
//  CustomViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine

import DynamicDomain

public protocol CustomViewModelInputProtocol: AnyObject {
    
}

public protocol CustomViewModelOutputProtocol: AnyObject {
    
}

public protocol CustomViewModelProtocol: CustomViewModelInputProtocol, CustomViewModelOutputProtocol {
    var previewImageDataSubject: CurrentValueSubject<CustomPresentationModel, Never> { get }
    func retrieveImageData(_ indexPath: IndexPath) async throws -> Data
}

public class CustomViewModel: CustomViewModelProtocol {
    var dynamicUseCase: DynamicUseCase
    
    public var event: CurrentValueSubject<Event, Never> = .init(.none)
    public let previewImageDataSubject = CurrentValueSubject<CustomPresentationModel, Never>(CustomPresentationModel.empty)
    private var originalImageDataArray: [Data] = []
    
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
            
        }
    }
    
    private func createDetailData(_ indexPath: Int) -> DetailModel {
        let imageData = originalImageDataArray[indexPath]
        let width = previewImageDataSubject.value.contents.originalImages[indexPath].width
        let height = previewImageDataSubject.value.contents.originalImages[indexPath].height
        
        return DetailModel(detailImage: imageData, width: width, height: height)
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
    
    public func retrieveImageData(_ indexPath: IndexPath) async throws -> Data {
        let urlString = self.previewImageDataSubject.value.contents.previewImages[indexPath.item].url
        let previewData = try await dynamicUseCase.retrieveGIFImage(urlString)
        retrieveOriginalImageData(indexPath.item)
        return previewData
    }
    
    private func retrieveOriginalImageData(_ indexPath: Int) {
        Task { [weak self] in
            do {
                guard let originalUrlString = self?.previewImageDataSubject.value.contents.originalImages[indexPath].url else { return }
                let originalData = try await dynamicUseCase.retrieveGIFImage(originalUrlString)
                self?.originalImageDataArray.append(originalData)
            } catch {
                print("original image load - 실패")
            }
        }
    }
}
