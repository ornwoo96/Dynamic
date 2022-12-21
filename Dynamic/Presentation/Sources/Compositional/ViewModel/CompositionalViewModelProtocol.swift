//
//  CompositionalViewModelProtocol.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import Combine

public protocol CompositionalViewModelInputProtocol: AnyObject {
    func action(_ action: CompositionalViewModel.Action)
}

public protocol CompositionalViewModelOutputProtocol: AnyObject {
    var event: CurrentValueSubject<CompositionalViewModel.Event, Never> { get }

    func getSectionItem(_ sectionIndex: Int) -> CompositionalViewModel.Section
}

public protocol CompositionalViewModelProtocol: CompositionalViewModelInputProtocol, CompositionalViewModelOutputProtocol {
}
