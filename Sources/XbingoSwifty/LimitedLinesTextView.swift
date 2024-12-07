//
//  LimitedHighTextView.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/7/10.
//

import UIKit

public class LimitedLinesTextView: UITextView {
    
    public var maxLines: Int = 0
    
    public var maxWords: Int = 0
    
    public override var text: String? {
        didSet{
            invalidateIntrinsicContentSize()
            placeholderLab.isHidden = text?.count ?? 0 > 0
            didChangeBlock?(self)
        }
    }
    
    public var didChangeBlock: ((_ textView: UITextView)->Void)?
    public var reachMaxWordsBlock: ((Int)->())?
    
    public var placeholderFont: UIFont? {
        didSet {
            placeholderLab.font = placeholderFont
            setNeedsLayout()
        }
    }
    
    public var placeholderTextColor: UIColor? {
        didSet {
            placeholderLab.textColor = placeholderTextColor
            setNeedsLayout()
        }
    }
    
    public var placeholderText: String? {
        didSet{
            placeholderLab.text = placeholderText
            setNeedsLayout()
        }
    }
    
    public var placeholderInsert: UIEdgeInsets = .zero {
        didSet{
            setNeedsLayout()
        }
    }
    
    public override var textContainerInset: UIEdgeInsets {
        didSet {
            super.textContainerInset = textContainerInset
            setNeedsLayout()
            setNeedsUpdateConstraints()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private lazy var placeholderLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.textAlignment = .left
        return lab
    }()
    
    private func commonInit() {
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        addSubview(placeholderLab)
        setNeedsLayout()
    }
    
    
    public override var intrinsicContentSize: CGSize {
        let size = self.sizeThatFits(CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let mh = maxHeight
        if mh > 0 && size.height > mh {
            isScrollEnabled = true
            return CGSize(width: size.width, height: mh)
        }
        isScrollEnabled = false
        return size
    }
    
    private var maxHeight: CGFloat {
        guard let font = self.font else { return 0 }
        let lineHeight = font.lineHeight
        return lineHeight * CGFloat(maxLines) + self.textContainerInset.top + self.textContainerInset.bottom
    }
    
    private var xb_lastW = 0.0
    public override func layoutSubviews() {
        super.layoutSubviews()
        if xb_lastW != bounds.width {
            xb_lastW = bounds.width
            invalidateIntrinsicContentSize()
        }
        
        let w = bounds.width - textContainerInset.left - textContainerInset.right
        let size = placeholderLab.sizeThatFits(CGSize(width: w - 5.pt, height: CGFloat.greatestFiniteMagnitude))
        placeholderLab.frame = .init(x: textContainerInset.left + 2.5.pt + placeholderInsert.left, y: textContainerInset.top + placeholderInsert.top, width: w - 5.pt - placeholderInsert.left - placeholderInsert.right, height: size.height)
    }
}

extension LimitedLinesTextView: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        
        // 处理自动布局高度变化
        invalidateIntrinsicContentSize()
        placeholderLab.isHidden = textView.text.count > 0
        
        // 高亮状态不做干预
        if let markedTextRange = textView.markedTextRange, let _ = textView.position(from: markedTextRange.start, offset: 0) {
            didChangeBlock?(textView)
            return
        }
        
        // 无字数限制
        if maxWords <= 0 {
            didChangeBlock?(textView)
            return
        }
        
        // 有字数限制
        let textContent = textView.text
        let textCount = textContent?.count ?? 0
        if textCount > maxWords {
            textView.text = String(textContent?.prefix(maxWords) ?? "")
            reachMaxWordsBlock?(maxWords)
            return
        }
        didChangeBlock?(textView)
    }
    
}
