//
//  GiphyEntityFromAPI.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/13.
//

import Foundation

public struct GIPHYFromAPIEntity: Codable {
    static let empty: Self = .init(giphyData: [])
    public let giphyData: [GiphyData]
    
    enum CodingKeys: String, CodingKey {
        case giphyData = "data"
    }
}

public struct GiphyData: Codable {
    public let type: String
    public let id: String
    public let images: GIFImages
    
    enum CodingKeys: String, CodingKey {
        case type, id, images
    }
}

public struct GIFImages: Codable {
    public let previewGIF: Preview
    public let original: Original
    
    enum CodingKeys: String, CodingKey {
        case previewGIF = "preview_gif"
        case original
    }
}

public struct Preview: Codable {
    public let height: String
    public let width: String
    public let url: String
    
    public init(height: String, width: String, url: String) {
        self.height = height
        self.width = width
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case height, width, url
    }
}

public struct Original: Codable {
    public let height: String
    public let width: String
    public let url: String
    
    public init(height: String, width: String, url: String) {
        self.height = height
        self.width = width
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case height, width, url
    }
}


public struct GiphyImageEntity {
    static let empty: Self = .init(previewImages: [],
                                   originalImages: [])
    
    public let previewImages: [PreviewAddIDEntity]
    public let originalImages: [OriginalAddIDEntity]
    
    public init(previewImages: [PreviewAddIDEntity],
                originalImages: [OriginalAddIDEntity]) {
        self.previewImages = previewImages
        self.originalImages = originalImages
    }
}

public struct PreviewAddIDEntity {
    public let id: String
    public let height: String
    public let width: String
    public let url: String
}

public struct OriginalAddIDEntity {
    public let id: String
    public let height: String
    public let width: String
    public let url: String
}
