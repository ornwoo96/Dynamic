//
//  GiphyEntityFromAPI.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/13.
//

import Foundation

struct GIPHYDataFromAPI: Codable {
    let giphyData: [GiphyData]
    
    enum CodingKeys: String, CodingKey {
        case giphyData = "data"
    }
}

struct GiphyData: Codable {
    let type: String
    let id: String
    let images: GIFImages
    
    enum CodingKeys: String, CodingKey {
        case type, id, images
    }
}

struct GIFImages: Codable {
    let previewGIF: Preview
    let original: Original
    
    enum CodingKeys: String, CodingKey {
        case previewGIF = "preview_gif"
        case original
    }
}

struct Preview: Codable {
    let height: String
    let width: String
    let url: String
    
    init(height: String, width: String, url: String) {
        self.height = height
        self.width = width
        self.url = url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decode(String.self, forKey: .height)
        width = try values.decode(String.self, forKey: .width)
        url = try values.decode(String.self, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case height, width, url
    }
}

struct Original: Codable {
    let height: String
    let width: String
    let url: String
    
    init(height: String, width: String, url: String) {
        self.height = height
        self.width = width
        self.url = url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decode(String.self, forKey: .height)
        width = try values.decode(String.self, forKey: .width)
        url = try values.decode(String.self, forKey: .url)
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

extension GIPHYDataFromAPI {
    func convertGiphyImageEntity() -> GiphyImageEntity {
        return .init(previewImages: convertPreviewImageData(giphyData),
                     originalImages: convertOriginalImageData(giphyData))
    }
    
    func convertPreviewImageData(_ data: [GiphyData]) -> [PreviewAddIDEntity] {
        var previewData: [PreviewAddIDEntity] = []
        for i in 0..<data.count {
            let result = PreviewAddIDEntity(id: data[i].id,
                                            height: data[i].images.previewGIF.height,
                                            width: data[i].images.previewGIF.width,
                                            url: data[i].images.previewGIF.url)
            previewData.append(result)
        }
        
        return previewData
    }
    
    func convertOriginalImageData(_ data: [GiphyData]) -> [OriginalAddIDEntity] {
        var originalData: [OriginalAddIDEntity] = []
        for i in 0..<data.count {
            let result = OriginalAddIDEntity(id: data[i].id,
                                            height: data[i].images.previewGIF.height,
                                            width: data[i].images.previewGIF.width,
                                            url: data[i].images.previewGIF.url)
            originalData.append(result)
        }
        
        return originalData
    }
}
