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
    
    public let previewImages: [PreviewDomainModel]
    public let originalImages: [OriginalDomainModel]
    
    public init(previewImages: [PreviewDomainModel],
                originalImages: [OriginalDomainModel]) {
        self.previewImages = previewImages
        self.originalImages = originalImages
    }
}

public struct PreviewDomainModel {
    public let id: String
    public let height: String
    public let width: String
    public let url: String
    
    public init(id: String, height: String, width: String, url: String) {
        self.id = id
        self.height = height
        self.width = width
        self.url = url
    }
}

public struct OriginalDomainModel {
    public let id: String
    public let height: String
    public let width: String
    public let url: String
    
    public init(id: String, height: String, width: String, url: String) {
        self.id = id
        self.height = height
        self.width = width
        self.url = url
    }
}
