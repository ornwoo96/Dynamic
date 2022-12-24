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
}

public protocol ChildCompositionalViewModelOutputProtocol: AnyObject {
    var event: CurrentValueSubject<ChildCompositionalViewModel.Event, Never> { get }
    func getSectionItem(_ sectionIndex: Int) -> ChildCompositionalViewModel.Section
}

public protocol ChildCompositionalViewModelProtocol: ChildCompositionalViewModelInputProtocol, ChildCompositionalViewModelOutputProtocol {
    var category: ChildCompositionalViewModel.Category { get set }
}
