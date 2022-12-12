//
//  DynamicCustomFlowLayout.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit

protocol WaterFallCollectionViewHeightLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        _ heightForImageAtIndexPath: IndexPath) -> CGFloat
}

final class WaterfallCustomFlowLayout: UICollectionViewLayout {
    weak var delegate: WaterFallCollectionViewHeightLayoutDelegate?
    private var columnCount: Int = 2
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0.0
    private lazy var contentWidth: CGFloat = {
        guard let collectionView = collectionView else { return 0.0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }()
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        calculateYOffsetValue(collectionView, calculateXOffsetValue())
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    private func calculateXOffsetValue() -> [CGFloat] {
        let columnWidth: CGFloat = contentWidth / CGFloat(columnCount)
        var xOffset: [CGFloat] = []
        
        for column in 0..<columnCount {
            let offset = CGFloat(column) * columnWidth
            xOffset += [offset]
        }
        print("빼엠")
        return xOffset
    }
    
    private func calculateYOffsetValue(_ collectionView: UICollectionView,
                                       _ xOffset: [CGFloat]) {
        let columnWidth: CGFloat = contentWidth / CGFloat(columnCount)
        let cellPadding: CGFloat = 6.0
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: columnCount)
        let maxHeightValue: CGFloat = 3000
        var allHeightValue: CGFloat = 0.0

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let imageHeight = delegate?.collectionView(collectionView, indexPath) ?? 0
            
            allHeightValue = allHeightValue + imageHeight
        }
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let imageHeight = delegate?.collectionView(collectionView, indexPath) ?? 0
            let heightPercentValue = imageHeight/allHeightValue*100
            let heightResult = maxHeightValue*heightPercentValue/100
            let height = cellPadding * 2 + heightResult
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = insetFrame
            
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            
            yOffset[column] = yOffset[column] + height
            
            column = column < (columnCount - 1) ? (column + 1) : 0
        }
    }
}
