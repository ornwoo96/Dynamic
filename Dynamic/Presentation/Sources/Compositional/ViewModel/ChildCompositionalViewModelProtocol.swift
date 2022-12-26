//
//  CompositionalViewModelProtocol.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import Combine

public protocol ChildCompositionalViewModelInputProtocol: AnyObject {
    func action(_ action: ChildCompositionalViewModel.Action)
    func checkFavoriteButtonTapped(_ bool: Bool, _ indexPath: Int)
    func changeIsNavigationBarAnimation(_ bool: Bool)
}

public protocol ChildCompositionalViewModelOutputProtocol: AnyObject {
    var event: CurrentValueSubject<ChildCompositionalViewModel.Event, Never> { get }
    func getSectionItem(_ sectionIndex: Int) -> ChildCompositionalViewModel.Section
    func getIsNavigationBarAnimation() -> Bool
}

public protocol ChildCompositionalViewModelProtocol: ChildCompositionalViewModelInputProtocol, ChildCompositionalViewModelOutputProtocol {
    var category: ChildCompositionalViewModel.Category { set get }
    var favoritesCount: CurrentValueSubject<Int, Never> { get set }
}
