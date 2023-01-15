//
//  DetailViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import Combine
import DynamicDomain

protocol DetailViewModelInputProtocol: AnyObject {
    func setupDetailHeightData(_ data: String)
    func setupDetailWidthData(_ data: String)
}

protocol DetailViewModelOutputProtocol: AnyObject {
    var imageDataSubject: CurrentValueSubject<Data, Never> { get }
    var event: CurrentValueSubject<DetailViewModel.Event, Never> { get }
    
    func retrieveDetailHeightData() -> CGFloat
    func retrieveDetailWidthData() -> CGFloat
}

protocol DetailViewModelProtocol: DetailViewModelInputProtocol, DetailViewModelOutputProtocol {
    func action(_ action: DetailViewModel.Action)
}

public class DetailViewModel: DetailViewModelProtocol {
    private var detailHeight: CGFloat = 0
    private var detailWidth: CGFloat = 0
    internal var imageDataSubject = CurrentValueSubject<Data, Never>(Data())
    internal var event = CurrentValueSubject<DetailViewModel.Event, Never>(.none)
    
    public func action(_ action: Action) {
        switch action {
        case .viewDidLoad(let url):
            event.send(.showLoading)
            retrieveOriginalImage(url)
        }
    }
    
    func setupDetailHeightData(_ data: String) {
        let data = CGFloat(Int(data) ?? 0)
        detailHeight = data
    }
    
    func setupDetailWidthData(_ data: String) {
        let data = CGFloat(Int(data) ?? 0)
        detailWidth = data
    }
    
    func retrieveDetailHeightData() -> CGFloat {
        return detailHeight
    }
    
    func retrieveDetailWidthData() -> CGFloat {
        return detailWidth
    }
    
    private func retrieveOriginalImage(_ url: String) {
        Task { [weak self] in
            do {
                let imageData = try await ImageCacheManager.shared.imageLoad(url)
                self?.imageDataSubject.send(imageData)
                event.send(.hideLoading)
            } catch {
                print("OriginalImage Retrieve - 실패")
            }
        }
    }
}
