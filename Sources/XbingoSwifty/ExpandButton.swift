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
    public var edgeInserts: UIEdgeInsets = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    /// 图标与标题之间的间距
    public var titleToImgSpacing: CGFloat = 8 {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    /// 图标是否在右侧
    public var isImgRight: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    /// 图片的展示模式
    public var imageDisplayMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            imageView?.contentMode = imageDisplayMode
        }
    }
    
    /// 渐变背景
    public var gradientBgV: GradientColorView? = nil {
        willSet {
            guard let view = newValue else {
                gradientBgV?.removeFromSuperview()
                return
            }
            view.isUserInteractionEnabled = false
            insertSubview(view, at: 0)
        }
        
        didSet{
            setNeedsLayout()
        }
    }
    
    /// 点击block
    public var actionBlock: ((_ sender: ExpandButton) -> Void)? = nil {
        didSet {
            addTarget(self, action: #selector(act(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func act(_ sender: ExpandButton) -> Void {
        actionBlock?(sender)
    }
    
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
        imageView?.contentMode = imageDisplayMode
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
    
    /// 重写内容尺寸逻辑，支持内容边距、标题与图标间距、图标位置
    public override var intrinsicContentSize: CGSize {
        guard let titleLabel = titleLabel, let imageView = imageView else {
            let oSize = super.intrinsicContentSize
            let insets = edgeInserts
            return .init(width: oSize.width + insets.left + insets.right,
                         height: oSize.height + insets.top + insets.bottom)
        }
        
        let titleSize = titleLabel.intrinsicContentSize
        let imageSize = imageView.intrinsicContentSize
        
        let totalWidth = titleSize.width + imageSize.width + titleToImgSpacing
        let totalHeight = max(titleSize.height, imageSize.height)
        
        let adjustedWidth = totalWidth + edgeInserts.left + edgeInserts.right
        let adjustedHeight = totalHeight + edgeInserts.top + edgeInserts.bottom
        
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    
    /// 布局子视图
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientBgV?.frame = bounds
        
        // 如果只有标题没有图片，或者只有图片没有标题，直接居中显示
        if titleLabel?.text != nil && imageView?.image == nil {
            guard let titleLabel = titleLabel else { return }
            let titleSize = titleLabel.intrinsicContentSize
            let contentWidth = bounds.width - edgeInserts.left - edgeInserts.right
            let contentHeight = bounds.height - edgeInserts.top - edgeInserts.bottom
            
            let titleX = edgeInserts.left + (contentWidth - titleSize.width) / 2
            let titleY = edgeInserts.top + (contentHeight - titleSize.height) / 2
            
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleSize.width, height: titleSize.height)
            return
        }
        
        // 原有的布局逻辑保持不变
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return
        }
        
        let contentWidth = bounds.width - edgeInserts.left - edgeInserts.right
        let contentHeight = bounds.height - edgeInserts.top - edgeInserts.bottom
        
        let titleSize = titleLabel.intrinsicContentSize
        
        // 保持图片原始宽高比
        let originalImageSize = imageView.image?.size ?? imageView.intrinsicContentSize
        let imageAspectRatio = originalImageSize.width / originalImageSize.height
        let imageHeight = min(contentHeight, originalImageSize.height)
        let imageWidth = imageHeight * imageAspectRatio
        let imageSize = CGSize(width: imageWidth, height: imageHeight)
        
        let totalWidth = titleSize.width + imageSize.width + titleToImgSpacing
        let titleX: CGFloat
        let imageX: CGFloat
        
        if isImgRight {
            titleX = edgeInserts.left + (contentWidth - totalWidth) / 2
            imageX = titleX + titleSize.width + titleToImgSpacing
        } else {
            imageX = edgeInserts.left + (contentWidth - totalWidth) / 2
            titleX = imageX + imageSize.width + titleToImgSpacing
        }
        
        let titleY = edgeInserts.top + (contentHeight - titleSize.height) / 2
        let imageY = edgeInserts.top + (contentHeight - imageSize.height) / 2
        
        // 设置图标和标题的 frame
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleSize.width, height: titleSize.height)
    }
}
