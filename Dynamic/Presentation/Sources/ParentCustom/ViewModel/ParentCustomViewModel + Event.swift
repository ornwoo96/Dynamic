//
//  ParentCustomViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

extension ParentCustomViewModel {
    internal enum Event: Equatable {
        public static func == (lhs: ParentCustomViewModel.Event, rhs: ParentCustomViewModel.Event) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none):
                return true
            case (.setViewControllersToForward, .setViewControllersToForward):
                return true
            case (.setViewControllersToReverse, .setViewControllersToReverse):
                return true
            case (.setupPickListButtonCount, .setupPickListButtonCount):
                return true
            case (.animateHideNavigationBar, .animateHideNavigationBar):
                return true
            case (.animateShowNavigationBar, .animateShowNavigationBar):
                return true
            default:
                return false
            }
        }
        case setViewControllersToForward(_ viewController: CustomViewController)
        case setViewControllersToReverse(_ viewController: CustomViewController)
        case setupPickListButtonCount(_ count: Int)
        case animateHideNavigationBar
        case animateShowNavigationBar
        case none
    }
    
}
