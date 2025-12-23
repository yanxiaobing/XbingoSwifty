//
//  OverlapLayout.swift
//  QuitSmoke
//
//  Created by xbingo on 2024/12/30.
//  Copyright © 2024 Xbingo. All rights reserved.
//


import UIKit

public class OverlapLayout: UICollectionViewFlowLayout {
    
    /// 从哪个 section 开始重叠
    public var overlapSection: Int = 0

    /// 重叠高度
    public var overlapHeight: CGFloat = 0

    public override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {

        guard let collectionView = collectionView,
              let originAttrs = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        // ⚠️ 一定要 copy
        let attrs = originAttrs.map { $0.copy() as! UICollectionViewLayoutAttributes }

        for attr in attrs {
            guard attr.indexPath.section >= overlapSection else { continue }

            // 所有 >= overlapSection 的 section 整体上移
            attr.frame.origin.y -= overlapHeight
            attr.zIndex += attr.indexPath.section
        }

        return attrs
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // 只有宽度变化才 invalidate，避免性能问题
        guard let cv = collectionView else { return false }
        return newBounds.width != cv.bounds.width
    }
}
