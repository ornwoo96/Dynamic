//
//  GIPHYDomainModel.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/14.
//

import Foundation

public struct GIPHYDomainModel {
    public static let empty: Self = .init(previewImages: [],
                                   originalImages: [])
    
    public var previewImages: [PreviewDomainModel]
    public var originalImages: [OriginalDomainModel]
    
    public init(previewImages: [PreviewDomainModel],
                originalImages: [OriginalDomainModel]) {
        self.previewImages = previewImages
        self.originalImages = originalImages
    }
}

public struct PreviewDomainModel {
    public var id: String
    public var height: String
    public var width: String
    public var url: String
    
    public init(id: String, height: String, width: String, url: String) {
        self.id = id
        self.height = height
        self.width = width
        self.url = url
    }
}

public struct OriginalDomainModel {
    public var id: String
    public var height: String
    public var width: String
    public var url: String
    
    public init(id: String, height: String, width: String, url: String) {
        self.id = id
        self.height = height
        self.width = width
        self.url = url
    }
}
