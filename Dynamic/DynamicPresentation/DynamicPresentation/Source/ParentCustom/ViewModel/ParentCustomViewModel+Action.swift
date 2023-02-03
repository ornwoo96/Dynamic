//
//  ParentCustomViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

extension ParentCustomViewModel {
    internal enum Action {
        case viewDidLoad
        case receiveFavoritesCountData(_ count: Int)
        case categoryButtonDidTap(_ tag: Int,
                                  _ viewController: CustomViewController)
        case customNavigationBarState(state: CustomNavigationBarState)
    }
}
