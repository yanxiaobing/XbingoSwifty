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
    
    /// 图标与标题之间的间距
    public var titleToImgSpacing: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 图标是否在右侧
    public var isImgRight: Bool = false {
        didSet {
            setNeedsLayout()
        }
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
            // 移除旧的 target 后再添加新的
            removeTarget(self, action: #selector(act(_:)), for: .touchUpInside)
            if actionBlock != nil {
                addTarget(self, action: #selector(act(_:)), for: .touchUpInside)
            }
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
    
    /// 重写内容尺寸逻辑
    public override var intrinsicContentSize: CGSize {
        guard let titleLabel = titleLabel, let imageView = imageView, titleLabel.text != nil, imageView.image != nil else {
            return super.intrinsicContentSize
        }
        
        let titleSize = titleLabel.intrinsicContentSize
        let imageSize = imageView.intrinsicContentSize
        
        let totalWidth = titleSize.width + imageSize.width + titleToImgSpacing
        let totalHeight = max(titleSize.height, imageSize.height)
        
        // 加上 contentEdgeInsets 的影响
        return CGSize(
            width: totalWidth + contentEdgeInsets.left + contentEdgeInsets.right,
            height: totalHeight + contentEdgeInsets.top + contentEdgeInsets.bottom
        )
    }
    
    /// 布局子视图
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientBgV?.frame = bounds
        
        guard let titleLabel = titleLabel, let imageView = imageView, titleLabel.text != nil, imageView.image != nil else {
            return
        }
        
        let contentWidth = bounds.width - contentEdgeInsets.left - contentEdgeInsets.right
        let contentHeight = bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom
        
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
            titleX = contentEdgeInsets.left + (contentWidth - totalWidth) / 2
            imageX = titleX + titleSize.width + titleToImgSpacing
        } else {
            imageX = contentEdgeInsets.left + (contentWidth - totalWidth) / 2
            titleX = imageX + imageSize.width + titleToImgSpacing
        }
        
        let titleY = contentEdgeInsets.top + (contentHeight - titleSize.height) / 2
        let imageY = contentEdgeInsets.top + (contentHeight - imageSize.height) / 2
        
        // 设置图标和标题的 frame
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleSize.width, height: titleSize.height)
    }
}
