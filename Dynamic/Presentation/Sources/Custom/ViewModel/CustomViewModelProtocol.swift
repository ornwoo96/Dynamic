//
//  CustomViewModelProtocol.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import DynamicDomain
import Combine

public protocol CustomViewModelInputProtocol: AnyObject {
    func action(_ action: CustomViewModel.Action)
    func scrollViewDidEndDecelerating()
    func checkFavoriteButtonTapped(_ bool: Bool, _ indexPath: Int)
}

public protocol CustomViewModelOutputProtocol: AnyObject {
    func retrieveCustomCellItem(_ indexPath: IndexPath) -> CustomCellItem
    func collectionViewImageHeight(_ indexPath: IndexPath) -> CGFloat
    func collectionViewImageWidth(_ indexPath: IndexPath) -> CGFloat
    func numberOfItemsInSection() -> Int
}

public protocol CustomViewModelProtocol: CustomViewModelInputProtocol, CustomViewModelOutputProtocol {
    var event: CurrentValueSubject<CustomViewModel.Event, Never> { get set }
}
