//
//  CompositionalViewModel + Section.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import UIKit

extension ChildCompositionalViewModel {
    internal class Section: Hashable {
        let identifier: UUID = .init()
        
        let type: SectionType
        var items: [BaseCellItem]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: ChildCompositionalViewModel.Section,
                               rhs: ChildCompositionalViewModel.Section) -> Bool {
            lhs.identifier ==  rhs.identifier
        }
        
        init(type: SectionType,
             items: [BaseCellItem]) {
            self.type = type
            self.items = items
        }
        
        public enum SectionType {
            case content
        }
    }
}
