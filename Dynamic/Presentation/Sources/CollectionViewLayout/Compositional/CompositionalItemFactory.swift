//
//  CompositionalItemFactory.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import UIKit

public struct FactoryItems {
    static let empty: Self = .init(columnCount: 0,
                                   itemPadding: 0,
                                   contentWidth: 0,
                                   sectionIndex: 0)
    
    let columnCount: Int
    let itemPadding: CGFloat
    let contentWidth: CGFloat
    let sectionIndex: Int
    
    init(columnCount: Int,
         itemPadding: CGFloat,
         contentWidth: CGFloat,
         sectionIndex: Int) {
        self.columnCount = columnCount
        self.itemPadding = itemPadding
        self.contentWidth = contentWidth
        self.sectionIndex = sectionIndex
    }
}

public class CompositionalItemFactory {
    private var columnHeights: [CGFloat] = []
    private let columnCount: CGFloat
    private let itemPadding: CGFloat
    private let contentWidth: CGFloat
    private var itemSize: CGSize = .zero
    private var sectionIndex: CGFloat
    
    init(factoryItems: FactoryItems) {
        self.columnCount = CGFloat(factoryItems.columnCount)
        self.contentWidth = factoryItems.contentWidth
        self.itemPadding = factoryItems.itemPadding
        self.sectionIndex = CGFloat(factoryItems.sectionIndex)
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
        let x = xValue(width) + addSectionIndexXPoint()
        
        return CGPoint(x: x, y: y)
    }
    
    private func xValue(_ width: CGFloat) -> CGFloat {
        if columnIndex() == 0 {
            return itemPadding
        } else if columnIndex() == Int(columnCount) {
            return (width*CGFloat(columnIndex())) + (itemPadding*2)
        } else {
            return (width*CGFloat(columnIndex())) + (itemPadding*2)
        }
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
    
    private func addSectionIndexXPoint() -> CGFloat {
        return contentWidth * sectionIndex
    }
    
    private func itemWidth() -> CGFloat {
        return (contentWidth/columnCount) - minusPadding()
    }
    
    private func minusPadding() -> CGFloat {
        if columnIndex() == 0 {
            return (itemPadding/2)*3
        } else if columnIndex() == Int(columnCount)-1 {
            return (itemPadding/2)*3
        } else {
            return itemPadding
        }
    }
    
    private func itemHeight() -> CGFloat {
        return (itemWidth()*itemSize.height)/itemSize.width
    }
    
    private func columnIndex() -> Int {
        return columnHeights.enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }
    
}
