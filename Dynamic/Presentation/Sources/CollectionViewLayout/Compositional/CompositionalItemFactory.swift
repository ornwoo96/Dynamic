//
//  CompositionalItemFactory.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import UIKit

public struct FactoryItems {
    static let empty: Self = .init(columnCount: 0, itemPadding: 0)
    
    let columnCount: Int
    let itemPadding: CGFloat
    
    init(columnCount: Int,
         itemPadding: CGFloat) {
        self.columnCount = columnCount
        self.itemPadding = itemPadding
    }
}

public class CompositionalItemFactory {
    private var columnHeights: [CGFloat] = []
    private let columnCount: CGFloat
    private let itemPadding: CGFloat
    private let contentWidth: CGFloat
    private var itemSize: CGSize = .zero
    
    init(factoryItems: FactoryItems,
         contentWidth: CGFloat) {
        self.columnCount = CGFloat(factoryItems.columnCount)
        self.itemPadding = factoryItems.itemPadding
        self.contentWidth = contentWidth
    }
    
    public func setItemSize(_ itemSize: CGSize) {
        self.itemSize = itemSize
    }
    
    public func getItem() -> NSCollectionLayoutGroupCustomItem {
        let frame = itemFrame()
        setupColumnHeights(frame)
        
        return NSCollectionLayoutGroupCustomItem(frame: frame)
    }
    
    public func getTotalHeight() -> CGFloat {
        return columnHeights[columnIndex()]
    }
    
    private func setupColumnHeights(_ frame: CGRect) {
        if columnHeights.isEmpty {
            columnHeights = [frame.maxY + itemPadding]
            for _ in 0..<Int(columnCount)-1 {
                columnHeights.append(CGFloat(0))
            }
            return
        }
        
        columnHeights[columnIndex()] = frame.maxY + itemPadding
    }
    
    private func itemFrame() -> CGRect {
        let itemOrigin = itemOrigin(itemWidth())
        let itemSize = itemSizeAspect()
        return CGRect(origin: itemOrigin, size: itemSize)
    }
    
    private func itemOrigin(_ width: CGFloat) -> CGPoint {
        let y = checkColumnHeights()
        let x = (width + itemPadding) * CGFloat(columnIndex())
        return CGPoint(x: x, y: y)
    }
    
    private func checkColumnHeights() -> CGFloat {
        if columnHeights.isEmpty {
            return 0
        }
        return columnHeights[columnIndex()]
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
    
    
    // MARK: 더 작은쪽으로 index 알려주기
    private func columnIndex() -> Int {
        
        
        return columnHeights.enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }
}
