//
//  CompositionalViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine
import DynamicDomain

public protocol CompositionalViewModelInputProtocol: AnyObject {
}

public protocol CompositionalViewModelOutputProtocol: AnyObject {
    
}

public protocol CompositionalViewModelProtocol: CompositionalViewModelInputProtocol, CompositionalViewModelOutputProtocol {
    
}



public class CompositionalViewModel {
    private let dynamicUseCase: DynamicUseCase
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    
    public func action(_ action: Action) {
        
    }
}
