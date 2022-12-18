//
//  PickListViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/18.
//

import Foundation

extension PickListViewModel {
    public enum Event: Equatable {
        public static func == (lhs: PickListViewModel.Event, rhs: PickListViewModel.Event) -> Bool {
            switch (lhs, rhs) {
                
            case (.none, .none):
                return true
            case (.invalidateLayout, .invalidateLayout):
                return true
            case (.deleteItem, .deleteItem):
                return true
            default:
                return false
                
            }
        }
        
        
        case none
        case invalidateLayout
        case deleteItem(_ indexPath: IndexPath)
    }
    
    
}
