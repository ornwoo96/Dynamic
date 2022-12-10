//
//  DIContainer.swift
//  Core
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation

public protocol Containable {
    var container: BMOInject { get set }
    
    func register()
}

public final class DIContainer {
    public static let shared: BMOInject = BMOInject()
}
