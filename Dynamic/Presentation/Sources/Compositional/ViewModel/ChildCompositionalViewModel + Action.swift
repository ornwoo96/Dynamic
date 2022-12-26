//
//  CompositionalViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation

extension ChildCompositionalViewModel {
    public enum Action {
        case viewDidLoad
        case didSelectItemAt(_ indexPath: IndexPath)
        case willDisplay(_ indexPath: IndexPath)
        case didSelectedItemAtLongPressed(indexPath: IndexPath)
        case scrollViewDidScroll(_ yValue: CGFloat)
    }
}
