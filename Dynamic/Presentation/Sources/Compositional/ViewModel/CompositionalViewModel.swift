//
//  CompositionalViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation

import DynamicDomain

protocol CompositionalViewModelInputProtocol: AnyObject {
    
}

protocol CompositionalViewModelOutputProtocol: AnyObject {
    
}

protocol CompositionalViewModelProtocol: CompositionalViewModelInputProtocol, CompositionalViewModelOutputProtocol {
    
}



final class CompositionalViewModel {
    private let dynamicUseCase: DynamicUseCase
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
}
