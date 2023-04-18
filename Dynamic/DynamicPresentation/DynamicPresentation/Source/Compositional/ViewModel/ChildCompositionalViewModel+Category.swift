//
//  ChildCompositionalViewModel + Category.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/24.
//

import Foundation

extension ChildCompositionalViewModel {
    internal enum Category: String {
        case Coding = "Coding"
        case Memes = "Memes"
        case Cats = "Cat"
        case Dogs = "Dogs"
        case Christmas = "Christmas"
        case Oops = "Oops"
        case Reactions = "Reactions"
        case Emoji = "Emoji"
    }
    
    internal static var categorys: [Category] = {
        var array = [Category.Coding,
                     Category.Memes,
                     Category.Cats,
                     Category.Dogs,
                     Category.Christmas,
                     Category.Oops,
                     Category.Reactions,
                     Category.Emoji]
        return array
    }()
}
