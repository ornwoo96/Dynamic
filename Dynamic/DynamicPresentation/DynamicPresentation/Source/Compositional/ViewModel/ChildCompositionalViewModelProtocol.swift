//
//  CompositionalViewModelProtocol.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import Combine

internal protocol ChildCompositionalViewModelInputProtocol: AnyObject {
    func action(_ action: ChildCompositionalViewModel.Action)
    func checkFavoriteButtonTapped(_ bool: Bool, _ indexPath: Int)
    func setupCategory(_ category: ChildCompositionalViewModel.Category)
    func scrollViewDidScroll(yValue: CGFloat)
}

internal protocol ChildCompositionalViewModelOutputProtocol: AnyObject {
    var event: CurrentValueSubject<ChildCompositionalViewModel.Event, Never> { get }
    func getSectionItem(_ sectionIndex: Int) -> ChildCompositionalViewModel.Section
}

internal protocol ChildCompositionalViewModelProtocol: ChildCompositionalViewModelInputProtocol, ChildCompositionalViewModelOutputProtocol {
    var favoritesCount: CurrentValueSubject<Int, Never> { get set }
}
