//
//  GradientButton.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/3.
//


import UIKit

public class GradientButton: ExpandButton {

    /// 渐变背景视图
    public lazy var gradientV: GradientColorView = {
        let view = GradientColorView()
        view.isUserInteractionEnabled = false // 不影响按钮的点击事件
        return view
    }()
    
    // MARK: - 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(gradientV)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(gradientV)
    }
    
    // MARK: - 布局更新
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientV.frame = bounds // 动态更新背景视图的布局
    }
}
