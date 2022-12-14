//
//  CustomPresentationModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/14.
//

import Foundation
import DynamicDomain

public struct CustomPresentationModel {
    public static let empty: Self = .init(domainModel: GIPHYDomainModel.empty)
    
    var contents: GIPHYDomainModel
    
    init(domainModel: GIPHYDomainModel) {
        self.contents = domainModel
    }
}
