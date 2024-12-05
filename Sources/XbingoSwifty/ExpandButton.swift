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
        let titleSize = titleLabel?.intrinsicContentSize ?? .zero
        let imageSize = imageView?.intrinsicContentSize ?? .zero
        
        // 只有标题
        if titleLabel?.text != nil && imageView?.image == nil {
            return CGSize(
                width: titleSize.width + contentEdgeInsets.left + contentEdgeInsets.right,
                height: titleSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom
            )
        }
        
        // 只有图片
        if titleLabel?.text == nil && imageView?.image != nil {
            return CGSize(
                width: imageSize.width + contentEdgeInsets.left + contentEdgeInsets.right,
                height: imageSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom
            )
        }
        
        // 图文都有
        if titleLabel?.text != nil && imageView?.image != nil {
            let totalWidth = titleSize.width + imageSize.width + titleToImgSpacing
            let totalHeight = max(titleSize.height, imageSize.height)
            
            return CGSize(
                width: totalWidth + contentEdgeInsets.left + contentEdgeInsets.right,
                height: totalHeight + contentEdgeInsets.top + contentEdgeInsets.bottom
            )
        }
        
        // 都没有
        return super.intrinsicContentSize
    }
    
    /// 布局子视图
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientBgV?.frame = bounds
        
        guard let titleLabel = titleLabel, let imageView = imageView else { return }
        
        let contentWidth = bounds.width - contentEdgeInsets.left - contentEdgeInsets.right
        let contentHeight = bounds.height - contentEdgeInsets.top - contentEdgeInsets.bottom
        
        // 计算图片尺寸的辅助方法
        func calculateImageSize() -> CGSize {
            let originalImageSize = imageView.image?.size ?? .zero
            let imageAspectRatio = originalImageSize.width / originalImageSize.height
            let imageHeight = min(contentHeight, originalImageSize.height)
            let imageWidth = imageHeight * imageAspectRatio
            return CGSize(width: imageWidth, height: imageHeight)
        }
        
        // 计算垂直居中Y坐标的辅助方法
        func centerY(for height: CGFloat) -> CGFloat {
            return contentEdgeInsets.top + (contentHeight - height) / 2
        }
        
        let titleSize = titleLabel.intrinsicContentSize
        
        // 只有标题
        if titleLabel.text != nil && imageView.image == nil {
            let titleX = contentEdgeInsets.left + (contentWidth - titleSize.width) / 2
            titleLabel.frame = CGRect(origin: CGPoint(x: titleX, y: centerY(for: titleSize.height)),
                                    size: titleSize)
            return
        }
        
        // 只有图片
        if titleLabel.text == nil && imageView.image != nil {
            let imageSize = calculateImageSize()
            let imageX = contentEdgeInsets.left + (contentWidth - imageSize.width) / 2
            imageView.frame = CGRect(origin: CGPoint(x: imageX, y: centerY(for: imageSize.height)),
                                   size: imageSize)
            return
        }
        
        // 图文都有
        if titleLabel.text != nil && imageView.image != nil {
            let imageSize = calculateImageSize()
            let totalWidth = titleSize.width + imageSize.width + titleToImgSpacing
            let startX = (bounds.width - totalWidth) / 2
            
            let (titleX, imageX) = isImgRight
                ? (startX, startX + titleSize.width + titleToImgSpacing)
                : (startX + imageSize.width + titleToImgSpacing, startX)
            
            imageView.frame = CGRect(origin: CGPoint(x: imageX, y: centerY(for: imageSize.height)),
                                   size: imageSize)
            titleLabel.frame = CGRect(origin: CGPoint(x: titleX, y: centerY(for: titleSize.height)),
                                    size: titleSize)
        }
    }
}
