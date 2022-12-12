//
//  MainViewModel.swift
//  Presentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit
import DynamicDomain

import Combine

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
    var viewControllers: [UIViewController]
    
    init(dynamicUseCase: DynamicUseCase,
         viewControllers: [UIViewController]) {
        self.dynamicUseCase = dynamicUseCase
        self.viewControllers = viewControllers
    }
    
    func viewDidLoad() {
        print("mainViewModel start")
        dynamicUseCase.doSomething()
    }
}
