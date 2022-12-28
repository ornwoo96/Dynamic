//
//  DynamicCustomFlowLayout.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/11.
//

import UIKit

protocol DynamicCollectionViewHeightLayoutDelegate: AnyObject {
    func collectionViewImageHeight(_ collectionView: UICollectionView,
                                   _ heightForImageAtIndexPath: IndexPath) -> CGFloat
    func collectionViewImageWidth(_ collectionView: UICollectionView,
                                  _ widthForImageAtIndexPath: IndexPath) -> CGFloat
}

final class DynamicCustomFlowLayout: UICollectionViewLayout {
    weak var delegate: DynamicCollectionViewHeightLayoutDelegate?
    private var columnCount: Int = 2
    private var cache: [UICollectionViewLayoutAttributes] = []
    internal var cellPadding: CGFloat?
    private var contentHeight: CGFloat = 0.0
    private lazy var contentWidth: CGFloat = {
        guard let collectionView = collectionView else { return 0.0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }()
    
    private var allLeftHeightValue: CGFloat = 0.0
    private var allRightHeightValue: CGFloat = 0.0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        clearLayoutObject()
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
        
        return xOffset
    }
    
    private func calculateYOffsetValue(_ collectionView: UICollectionView,
                                       _ xOffset: [CGFloat]) {
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            if allLeftHeightValue <= allRightHeightValue {
                createLeftSideAttribute(collectionView, indexPath)
            } else {
                createRightSideAttribute(collectionView, indexPath)
            }
        }
    }
    
    private func createLeftSideAttribute(_ collectionView: UICollectionView,
                                         _ indexPath: IndexPath) {
        let columnWidth: CGFloat = contentWidth / CGFloat(columnCount)
        let heightResult = createHeightResize(collectionView, indexPath)
        let height = (cellPadding ?? 0) * 2 + heightResult
        let frame = CGRect(x: calculateXOffsetValue()[0],
                           y: allLeftHeightValue,
                           width: columnWidth, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding ?? 0, dy: cellPadding ?? 0)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        allLeftHeightValue += height
        contentHeight = allLeftHeightValue
    }
    
    private func createRightSideAttribute(_ collectionView: UICollectionView,
                                          _ indexPath: IndexPath) {
        let columnWidth: CGFloat = contentWidth / CGFloat(columnCount)
        let heightResult = createHeightResize(collectionView, indexPath)
        let height = (cellPadding ?? 0) * 2 + heightResult
        let frame = CGRect(x: calculateXOffsetValue()[1],
                           y: allRightHeightValue,
                           width: columnWidth, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding ?? 0, dy: cellPadding ?? 0)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        allRightHeightValue += height
        contentHeight = allRightHeightValue
    }
    
    private func createHeightResize(_ collectionView: UICollectionView,
                                    _ indexPath: IndexPath) -> CGFloat {
        let imageHeight = delegate?.collectionViewImageHeight(collectionView, indexPath) ?? 0
        let imageWidth = delegate?.collectionViewImageWidth(collectionView, indexPath) ?? 0
        let heightResult = setupImageResize(imageWidth, imageHeight, contentWidth/2)
        return heightResult
    }
    
    private func setupImageResize(_ width: CGFloat,
                                  _ height: CGFloat,
                                  _ resizeWidth: CGFloat) -> CGFloat {
        let resizeHeight = (resizeWidth * height)/width
        return CGFloat(resizeHeight)
    }
    
    private func clearLayoutObject() {
        self.cache = []
        self.allLeftHeightValue = 0
        self.allRightHeightValue = 0
    }
}
