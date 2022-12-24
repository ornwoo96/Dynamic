//
//  ParentCompositionalViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/24.
//

import Foundation

protocol ParentCompositionalViewModelProtocol {
    var isCustomNavigationBarAnimationFirst: Bool { get set }
    var viewControllers: [ChildCompositionalViewController] { get set }
}

class ParentCompositionalViewModel: ParentCompositionalViewModelProtocol {
    public var isCustomNavigationBarAnimationFirst = false
    public var viewControllers: [ChildCompositionalViewController] = []
    
}
