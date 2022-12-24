//
//  CompositionalViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation

extension ChildCompositionalViewModel {
    public enum Event: Equatable {
        public static func == (lhs: ChildCompositionalViewModel.Event, rhs: ChildCompositionalViewModel.Event) -> Bool {
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
                
            case (.showHeartView, .showHeartView):
                return true
                
            default:
                return false
                
            }
        }
        
        
        case none
        case reloadData(sections: [Section])
        case showDetailView(content: DetailModel)
        case showLoading
        case showHeartView(indexPath: IndexPath)
        case hideLoading
        case invalidateLayout
    }
    
}
