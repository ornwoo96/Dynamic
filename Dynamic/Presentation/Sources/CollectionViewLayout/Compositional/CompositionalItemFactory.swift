//
//  CompositionalItemFactory.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import UIKit

public struct FactoryItems {
    var columnCount: Int = 2
    let itemPadding: CGFloat
    let itemSize: CGSize
}

public class CompositionalItemFactory {
    private var columnHeights: [CGFloat] = []
    private let columnCount: CGFloat
    private let itemPadding: CGFloat
    private let contentWidth: CGFloat
    private let itemSize: CGSize
    
    init(factoryItems: FactoryItems,
         contentWidth: CGFloat) {
        self.columnCount = CGFloat(factoryItems.columnCount)
        self.itemPadding = factoryItems.itemPadding
        self.contentWidth = contentWidth
        self.itemSize = factoryItems.itemSize
    }
    
    public func getItem() -> NSCollectionLayoutGroupCustomItem {
        let frame = itemFrame()
        columnHeights[columnIndex()] = frame.maxY + itemPadding
        return NSCollectionLayoutGroupCustomItem(frame: frame)
    }
    
    private func itemFrame() -> CGRect {
        let itemOrigin = itemOrigin(itemWidth())
        let itemSize = itemSizeAspect()
        return CGRect(origin: itemOrigin, size: itemSize)
    }
    
    private func itemOrigin(_ width: CGFloat) -> CGPoint {
        let y = columnHeights[columnIndex()]
        let x = (width + itemPadding) * CGFloat(columnIndex())
        return CGPoint(x: x, y: y)
    }
    
    private func itemSizeAspect() -> CGSize {
        let height = itemHeight()
        let width = itemWidth()
        return CGSize(width: width, height: height)
    }
    
    private func itemWidth() -> CGFloat {
        let itemPadding = (columnCount - 1) * itemPadding
        return (contentWidth - itemPadding) / columnCount
    }
    
    private func itemHeight() -> CGFloat {
        return (itemWidth()*itemSize.height)/itemSize.width
    }
    
    private func columnIndex() -> Int {
        return columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
    }
}
