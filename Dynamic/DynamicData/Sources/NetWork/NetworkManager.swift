//
//  FetchDataService.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/13.
//

import Foundation
import DynamicDomain
import Combine

public class NetworkManager: NetworkManagerRepository {
    private let limit: Int = 20
    
    public func fetchGIPHYDatas(_ searchWord: String,
                                _ offset: Int) async throws -> GIPHYDomainModel {
        let randomImageURL = "https://api.giphy.com/v1/gifs/search?api_key=fUyNy20JVfRpEHP0UJEAJQk8mT3hyv4H&q=\(searchWord)&limit=\(limit)&offset=\(offset)&rating=g&lang=en"
        
        guard let stringToURL = URL(string: randomImageURL) else {
            return GIPHYDomainModel.empty
        }
        
        let (data, _ ) = try await URLSession.shared.data(from: stringToURL)
        
        let decodeData = try JSONDecoder().decode(GIPHYFromAPIEntity.self, from: data)
        
        return convertToDomainModel(convertGiphyImageEntity(decodeData))
    }
    
    public func fetchImageData(_ url: String) async throws -> Data {
        guard let stringToURL = URL(string: url) else { return Data() }
        
        let (data, _) = try await URLSession.shared.data(from: stringToURL)
        
        return data
    }
}

extension NetworkManager {
    enum BaseURL: String {
        case base = ""
    }
}

extension NetworkManager {
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
    
    public func convertToDomainModel(_ data: GiphyImageDataModel) -> GIPHYDomainModel {
        return .init(
            previewImages: data.previewImages.map { convertToDomainPreviewModel($0) },
            originalImages: data.originalImages.map { convertToDomainOriginalModel($0) }
        )
    }
    
    private func convertToDomainPreviewModel(_ data: GiphyImageDataModel.PreviewAddIDEntity) -> PreviewDomainModel {
        return .init(id: data.id, height: data.height, width: data.width, url: data.url)
    }
    
    private func convertToDomainOriginalModel(_ data: GiphyImageDataModel.OriginalAddIDEntity) -> OriginalDomainModel {
        return .init(id: data.id, height: data.height, width: data.width, url: data.url)
    }
}
