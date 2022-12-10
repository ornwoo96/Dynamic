//
//  MainViewModel.swift
//  Presentation
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation
import Domain

public protocol MainViewModelInputProtocol: AnyObject {
    func viewDidLoad()
}

public protocol MainViewModelOutputProtocol: AnyObject {
    
}

public protocol MainViewModelProtocol: MainViewModelInputProtocol, MainViewModelOutputProtocol {
    var dynamicUseCase: DynamicUseCase { get }
}


final class MainViewModel: MainViewModelProtocol {
    
    var dynamicUseCase: DynamicUseCase
    
    init(dynamicUseCase: DynamicUseCase) {
        self.dynamicUseCase = dynamicUseCase
    }
    
    func viewDidLoad() {
        print("mainViewModel start")
        dynamicUseCase.doSomething()
    }
}
