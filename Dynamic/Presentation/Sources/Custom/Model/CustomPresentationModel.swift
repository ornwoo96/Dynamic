//
//  CustomPresentationModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/19.
//

import Foundation
import DynamicDomain

public struct CustomPresentationModel: BaseCellItem {
//    public static let empty: Self = .
    
    var previewImageData: [Preview]
    var originalImageData: [Original]
    
    init(previewImageData: [Preview],
         originalImageData: [Original]) {
        self.previewImageData = previewImageData
        self.originalImageData = originalImageData
    }
    
//    init(giphyDomainModel: GIPHYDomainModel) {
//        self.previewImageData = giphyDomainModel.previewImages
//        self.originalImageData = giphyDomainModel.originalImages
//    }
    
    
    public struct Preview {
        var id: String
        var height: String
        var width: String
        var url: String
        
        init(id: String,
             height: String,
             width: String,
             url: String) {
            self.id = id
            self.height = height
            self.width = width
            self.url = url
        }
    }
    
    public struct Original {
        var id: String
        var height: String
        var width: String
        var url: String
        
        init(id: String,
             height: String,
             width: String,
             url: String) {
            self.id = id
            self.height = height
            self.width = width
            self.url = url
        }
    }
}

