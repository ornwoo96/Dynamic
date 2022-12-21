//
//  CompositionalLayout + Dynamic.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//


import UIKit

public class CompositionalLayoutFactory {
    public func getDynamicLayoutSection(_ columnCount: Int = 2,
                                        _ itemPadding: CGFloat,
                                        _ contentWidth: CGFloat,
                                        _ numberOfItems: Int,
                                        _ sectionItem: CompositionalViewModel.Section) -> NSCollectionLayoutSection {
        guard let items = sectionItem.items as? [CompositionalCellItem] else {
            return .init(group: .init(layoutSize: .init(widthDimension: .absolute(0),
                                                        heightDimension: .absolute(0))))
        }
        
        var itemFactory = CompositionalItemFactory(
            factoryItems: FactoryItems(columnCount: columnCount,
                                       itemPadding: itemPadding),
            contentWidth: contentWidth)
        var customGroupItems: [NSCollectionLayoutGroupCustomItem] = []
        
        for i in 0..<numberOfItems {
            itemFactory.setItemSize(CGSize(width: items[i].width, height: items[i].height))
            let item = itemFactory.getItem()
            customGroupItems.append(item)
        }
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .absolute(itemFactory.getTotalHeight()))
        
        let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { _ in
            return customGroupItems
        }
        
        return .init(group: group)
    }
    
    public func getEmptySection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(widthDimension: .absolute(0),
                              heightDimension: .absolute(0))
        )
        
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(widthDimension: .absolute(0),
                              heightDimension: .absolute(0)),
            subitems: [item])
        
        return .init(group: group)
    }
}
