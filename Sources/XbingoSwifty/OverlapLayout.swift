//
//  OverlapLayout.swift
//  QuitSmoke
//
//  Created by xbingo on 2024/12/30.
//  Copyright © 2024 Xbingo. All rights reserved.
//


import UIKit

public class OverlapLayout: UICollectionViewFlowLayout {
    
    /// 需要重叠的 section 索引
    var overlapSection: Int = -1
    
    /// 重叠的高度
    var overlapHeight: CGFloat = 20
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        // 遍历并调整目标 section 的布局
        for attribute in attributes {
            if attribute.indexPath.section == overlapSection {
                adjustAttributes(attribute: attribute)
            }
        }
        
        return attributes
    }
    
    private func adjustAttributes(attribute: UICollectionViewLayoutAttributes) {
        guard collectionView != nil else { return }
        
        // 确保是普通 item 或 Header/Footer
        if attribute.representedElementKind == nil {
            // 上移 frame 的 y 坐标
            attribute.frame.origin.y -= overlapHeight
        }
        
        // 提升 zIndex，让目标 section 盖住前一个 section
        attribute.zIndex = 10
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // 确保滚动时布局可以更新
        return true
    }
}
