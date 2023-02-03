//
//  CompositionalViewModel + Section.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import UIKit

extension ChildCompositionalViewModel {
    public class Section: Hashable {
        let identifier: UUID = .init()
        
        public let type: SectionType
        public var items: [BaseCellItem]
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        public static func == (lhs: ChildCompositionalViewModel.Section,
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
