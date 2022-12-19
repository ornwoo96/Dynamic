//
//  HasCoordinatable.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/16.
//

import Foundation

public protocol HasCoordinatable {
    var coordinator: Coordinator? { get set }
}

