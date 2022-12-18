//
//  CustomViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/14.
//

import Foundation
import DynamicDomain

extension CustomViewModel {
    public enum Event: Equatable {
        public static func == (lhs: CustomViewModel.Event, rhs: CustomViewModel.Event) -> Bool {
            switch (lhs, rhs) {
                
            case (.none, .none):
                return true
                
            case (.invalidateLayout, .invalidateLayout):
                return true
                
            case (.showDetailView, .showDetailView):
                return true
                
            case (.showLoading, .showLoading):
                return true
                
            case (.hideLoading, hideLoading):
                return true
                
            case (.showHeartView, .showHeartView):
                return true
                
            default:
                return false
                
            }
        }
        
        
        case none
        case invalidateLayout
        case showDetailView(_ data: DetailModel)
        case showLoading
        case hideLoading
        case showHeartView(_ indexPath: IndexPath)
    }
}
