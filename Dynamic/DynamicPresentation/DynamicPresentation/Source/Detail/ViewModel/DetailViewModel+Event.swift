//
//  DetailViewModel + Event.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/31.
//

import Foundation

extension DetailViewModel {
    public enum Event: Equatable {
        public static func == (lhs: DetailViewModel.Event, rhs: DetailViewModel.Event) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none):
                return true
                
            case (.showLoading, .showLoading):
                return true
                
            case (.hideLoading, .hideLoading):
                return true
                
            default:
                return false
                
            }
        }
        
        case none
        case showLoading
        case hideLoading
    }
}
