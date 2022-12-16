//
//  PickListViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation
import DynamicDomain
import Combine

protocol PickListViewModelInputProtocol: AnyObject {
    
}

protocol PickListViewModelOutputProtocol: AnyObject {
    
}

protocol PickListViewModelProtocol: PickListViewModelInputProtocol, PickListViewModelOutputProtocol {
    
}

class PickListViewModel: PickListViewModelProtocol {
    
    init() {
        
    }
}
