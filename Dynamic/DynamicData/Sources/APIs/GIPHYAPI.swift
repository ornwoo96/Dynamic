//
//  GIPHYAPI.swift
//  DynamicDataTests
//
//  Created by 김동우 on 2022/12/30.
//

import Foundation
import DynamicDomain

enum GIPYAPIError: String, Error {
    case invalidServerResponse = "invalidServerResponse"
}

public struct GIPHYAPI: BaseAPIProtocol {
    public var networkManager: NetworkManager
    private let limit: Int = 20
    private var path = "/v1/gifs/search"
    private var method: NetworkManager.Method = .get
    private var GIPHYAPIKey = "fUyNy20JVfRpEHP0UJEAJQk8mT3hyv4H"
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    public func retrieveGIFImageData(searchWord: String,
                                     offset: Int) async throws -> GiphyImageDataModel {
        let parameters: [String: Any] = ["api_key":GIPHYAPIKey,
                                         "q":searchWord,
                                         "limit":"\(limit)",
                                         "offset":"\(offset)",
                                         "rating":"g",
                                         "lang":"en"]
        let (data, response) = try await networkManager.request(path: path,
                                                                 parameters: parameters,
                                                                 method: NetworkManager.Method.get)
        let decodeData = try JSONDecoder().decode(GIPHYFromAPIEntity.self, from: data)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw GIPYAPIError.invalidServerResponse
        }

        return convertGiphyImageEntity(decodeData)
    }
}

extension GIPHYAPI {
    public func convertGiphyImageEntity(_ data: GIPHYFromAPIEntity) -> GiphyImageDataModel {
        return .init(previewImages: data.giphyData.map { convertPreviewImageData($0) },
                     originalImages: data.giphyData.map { convertOriginalImageData($0) })
    }
    
    private func convertPreviewImageData(_ data: GiphyData) -> GiphyImageDataModel.PreviewAddIDEntity {
        return .init(id: data.id,
                     height: data.images.previewGIF.height,
                     width: data.images.previewGIF.width,
                     url: data.images.previewGIF.url)
    }
    
    private func convertOriginalImageData(_ data: GiphyData) -> GiphyImageDataModel.OriginalAddIDEntity {
        return .init(id: data.id,
                     height: data.images.original.height,
                     width: data.images.original.width,
                     url: data.images.original.url)
    }
}
