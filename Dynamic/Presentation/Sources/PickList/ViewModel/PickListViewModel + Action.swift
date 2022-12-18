//
//  PickListViewModel + Action.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/18.
//

import Foundation

extension PickListViewModel {
    public enum Action {
        case viewDidLoad
        case viewNeededCalculateLayout
        case didSelectedItemAtLongPressed(indexPath: IndexPath)
        case viewDidDisappear
    }
}
