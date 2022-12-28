//
//  CustomViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/14.
//

import Foundation

extension CustomViewModel {
    public enum Action {
        case viewWillAppear
        case viewNeededCalculateLayout
        case didSelectItemAt(indexPath: IndexPath)
        case willDisplay(indexPath: IndexPath)
        case didSelectedItemAtLongPressed(indexPath: IndexPath)
        case scrollViewDidScroll(_ yValue: CGFloat)
        case pullToRefresh
    }
}
