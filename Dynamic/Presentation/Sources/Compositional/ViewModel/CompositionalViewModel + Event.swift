//
//  CompositionalViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation

extension CompositionalViewModel {
    public enum Event: Equatable {
        public static func == (lhs: CompositionalViewModel.Event, rhs: CompositionalViewModel.Event) -> Bool {
            switch (lhs, rhs) {
                
            case (.none, .none):
                return true
                
            case (.reloadData, .reloadData):
                return true
                
            case (.showDetailView, .showDetailView):
                return true
                
            case (.showLoading, .showLoading):
                return true
                
            case (.invalidateLayout, .invalidateLayout):
                return true
                
            default:
                return false
                
            }
        }
        
        
        case none
        case reloadData(sections: [Section])
        case showDetailView(selectedIndex: Int,
                            contents: CompositionalPresentationModel.OriginalModel)
        case showLoading
        case hideLoading
        case invalidateLayout
    }
    
}
