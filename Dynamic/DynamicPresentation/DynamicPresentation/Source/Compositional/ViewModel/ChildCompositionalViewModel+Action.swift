//
//  CompositionalViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation

extension ChildCompositionalViewModel {
    internal enum Action {
        case viewDidLoad
        case viewWillAppear
        case didSelectItemAt(_ indexPath: IndexPath)
        case willDisplay(_ indexPath: IndexPath)
        case didSelectedItemAtLongPressed(indexPath: IndexPath)
        case pullToRefresh
        case scrollPanGestureAction(yValue: Double)
    }
}
