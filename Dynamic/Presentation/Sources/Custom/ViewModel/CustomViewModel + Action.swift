//
//  CustomViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/14.
//

import Foundation

extension CustomViewModel {
    public enum Action {
        case viewDidLoad
        case viewNeededCalculateLayout
        case didSelectItemAt(indexPath: IndexPath)
        case willDisplay(indexPath: IndexPath)
    }
}
