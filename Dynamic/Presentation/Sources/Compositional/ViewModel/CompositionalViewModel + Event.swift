//
//  CompositionalViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/19.
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
                
            case (.invalidateLayout, .invalidateLayout):
                return true
                
            case (.showDetailView, .showDetailView):
                return true
                
            case (.showLoading, .showLoading):
                return true
                
            default:
                return false
                
            }
        }
        
        
        case none
        case reloadData(sections: [Section])
        case invalidateLayout
        case showDetailView(selectedIndex: Int, contents: [CustomPresentationModel.Preview])
        case showLoading
        case hideLoading
    }
    
}
