//
//  CustomPresentationModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import DynamicDomain

public struct CustomPresentationModel {
    public static let empty: Self = .init(previewImageData: [],
                                          originalImageData: [])
    
    var previewImageData: [PresentationPreview]
    var originalImageData: [PresentationOriginal]
    
    init(previewImageData: [PresentationPreview],
         originalImageData: [PresentationOriginal]) {
        self.previewImageData = previewImageData
        self.originalImageData = originalImageData
    }
    
    public struct PresentationPreview {
        let id: String
        let height: CGFloat
        let width: CGFloat
        let url: String
        let favorite: Bool
        
        init(height: String,
             width: String,
             url: String,
             id: String,
             favorite: Bool = false) {
            self.height = CGFloat(Int(height) ?? 0)
            self.width = CGFloat(Int(width) ?? 0)
            self.url = url
            self.id = id
            self.favorite = favorite
        }
    }
    
    public struct PresentationOriginal {
        let id: String
        let height: CGFloat
        let width: CGFloat
        let url: String
        let favorite: Bool
        
        init(height: String,
             width: String,
             url: String,
             id: String,
             favorite: Bool = false) {
            self.height = CGFloat(Int(height) ?? 0)
            self.width = CGFloat(Int(width) ?? 0)
            self.url = url
            self.id = id
            self.favorite = favorite
        }
    }

    
}
