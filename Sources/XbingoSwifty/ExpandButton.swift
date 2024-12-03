//
//  ExpandButton.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/3.
//


import UIKit

/// 可扩展点击范围的按钮
public class ExpandButton: UIButton {
    
    /// 按钮点击范围在原有基础上的增量（单位：pt）
    public var expandMargin: CGFloat = 0
    
    /// 按钮点击间隔时长（单位：秒）
    public var interval: TimeInterval = 0
    
    /// 内容边距
    public var edgeInserts: UIEdgeInsets = .zero
    
    
    private var isIgnoreAction: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpDefaultData()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpDefaultData()
    }
    
    /// 初始化默认数据
    private func setUpDefaultData() {
        expandMargin = 0
        interval = 0
        isIgnoreAction = false
    }
    
    /// 判断点是否在按钮的点击范围内
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let expandedBounds = bounds.insetBy(dx: -expandMargin, dy: -expandMargin)
        return expandedBounds.contains(point)
    }
    
    /// 处理按钮的点击事件，添加点击间隔限制
    public override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if isIgnoreAction {
            return
        }
        
        if interval > 0 {
            isIgnoreAction = true
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
                self?.isIgnoreAction = false
            }
        }
        
        super.sendAction(action, to: target, for: event)
    }
    
    public override var intrinsicContentSize: CGSize {
        let oSize = super.intrinsicContentSize
        let insets = edgeInserts
        return .init(width: oSize.width + insets.left + insets.right,
                     height: oSize.height + insets.top + insets.bottom)
    }
}
