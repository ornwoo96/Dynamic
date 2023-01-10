//
//  ParentCompositionalViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/25.
//

import Foundation

extension ParentCompositionalViewModel {
    internal enum Event: Equatable {
        public static func == (lhs: ParentCompositionalViewModel.Event, rhs: ParentCompositionalViewModel.Event) -> Bool {
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
        case setViewControllersToForward(_ viewController: ChildCompositionalViewController)
        case setViewControllersToReverse(_ viewController: ChildCompositionalViewController)
        case setupPickListButtonCount(_ count: Int)
        case animateHideNavigationBar
        case animateShowNavigationBar
        case none
    }
    
    public enum NavigationBarState {
        case hide
        case show
    }
}
