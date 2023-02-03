//
//  SwiftUIViewModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import Foundation
import Combine

import DynamicDomain

protocol SwiftUIViewModelInputProtocol: AnyObject {
    
}

protocol SwiftUIViewModelOutputProtocol: AnyObject {
    
}

protocol SwiftUIViewModelProtocol: SwiftUIViewModelInputProtocol, SwiftUIViewModelOutputProtocol {
    
}

final class SwiftUIViewModel: SwiftUIViewModelProtocol {
    
}
