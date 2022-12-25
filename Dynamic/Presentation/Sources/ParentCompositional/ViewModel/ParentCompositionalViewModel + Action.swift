//
//  ParentCompositionalViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/25.
//

import Foundation

extension ParentCompositionalViewModel {
    internal enum Action {
        case categoryButtonDidTap(_ tag: Int,
                                  _ viewController: ChildCompositionalViewController)
    }
}
