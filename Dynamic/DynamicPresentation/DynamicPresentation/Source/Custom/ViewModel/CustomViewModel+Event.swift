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
                
            case (.showBottomLoading, .showBottomLoading):
                return true
                
            case (.hideBottomLoading, hideBottomLoading):
                return true
                
            case (.showHeartView, .showHeartView):
                return true
                
            case (.showRetrievedCells, showRetrievedCells):
                return true
                
            case (.animateHideBar, .animateHideBar):
                return true
                
            case (.animateShowBar, .animateShowBar):
                return true
                
            case (.endRefreshing, .endRefreshing):
                return true
                
            case (.showPageLoading, .showPageLoading):
                return true
                
            case (.hidePageLoading, .hidePageLoading):
                return true
                
            case (.collectionViewReload, collectionViewReload):
                return true
                
            default:
                return false
                
            }
        }
        
        
        case none
        case invalidateLayout
        case showDetailView(_ data: DetailModel)
        case showBottomLoading
        case hideBottomLoading
        case showPageLoading
        case hidePageLoading
        case showHeartView(_ indexPath: IndexPath)
        case showRetrievedCells(_ indexPaths: [IndexPath])
        case animateHideBar
        case animateShowBar
        case endRefreshing
        case collectionViewReload
    }
}
