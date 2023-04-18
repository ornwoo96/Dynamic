//
//  CompositionalPresentationModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import DynamicDomain

internal struct CompositionalPresentationModel {
    internal static let empty: Self = .init(previewModel: [],
                                          originalModel: [])
    
    var previewModel: [PreviewModel]
    var originalModel: [OriginalModel]
    
    init(previewModel: [PreviewModel],
         originalModel: [OriginalModel]) {
        self.previewModel = previewModel
        self.originalModel = originalModel
    }
    
    internal struct PreviewModel {
        public static let empty: Self = .init(height: 0,
                                              width: 0,
                                              url: "",
                                              id: "",
                                              favorite: false)
        
        var id: String
        let height: CGFloat
        let width: CGFloat
        let url: String
        let favorite: Bool
        
        init(height: CGFloat,
             width: CGFloat,
             url: String,
             id: String,
             favorite: Bool = false) {
            self.height = height
            self.width = width
            self.url = url
            self.id = id
            self.favorite = favorite
        }
    }
    
    public struct OriginalModel {
        public static let empty: Self = .init(height: 0,
                                              width: 0,
                                              url: "",
                                              id: "",
                                              favorite: false)
        let id: String
        let height: CGFloat
        let width: CGFloat
        let url: String
        let favorite: Bool
        
        init(height: CGFloat,
             width: CGFloat,
             url: String,
             id: String,
             favorite: Bool = false) {
            self.height = height
            self.width = width
            self.url = url
            self.id = id
            self.favorite = favorite
        }
    }
}
