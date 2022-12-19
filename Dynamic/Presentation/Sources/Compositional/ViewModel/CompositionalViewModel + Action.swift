//
//  CompositionalViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/19.
//

import Foundation

extension CompositionalViewModel {
    public enum Action {
        case viewDidLoad
        case viewNeededCalculateLayout
        case didSelectItemAt(_ indexPath: IndexPath)
        case willDisplay(_ indexPath: IndexPath)
    }
    
}
