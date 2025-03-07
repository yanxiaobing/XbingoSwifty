//
//  XBGradientColorDirection.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/3.
//


import UIKit

/// 渐变方向
public enum GradientColorDirection {
    case leftToRight       // 从左到右
    case topToBottom       // 从上到下
    case leftTopToRightBottom // 从左上到右下
    case leftBottomToRightTop // 从左下到右上
}

public class GradientColorView: UIView {
    
    /// 是否禁止隐式动画
    public var forbidDefaultAnimation: Bool = false
    
    /// 渐变方向
    public var direction: GradientColorDirection = .leftToRight {
        didSet {
            updateGradientDirection()
        }
    }
    
    public var startPoint: CGPoint = .zero {
        didSet {
            applyTransaction {
                gradientLayer.startPoint = startPoint
            }
        }
    }
    
    public var endPoint: CGPoint = .zero {
        didSet {
            applyTransaction {
                gradientLayer.endPoint = endPoint
            }
        }
    }
    
    /// 渐变颜色
    public var colors: [UIColor] = [] {
        didSet {
            updateGradientColors()
        }
    }
    
    /// 渐变分割位置
    public var locations: [NSNumber] = [] {
        didSet {
            updateGradientLocations()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        self.layer.addSublayer(layer)
        return layer
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    private func updateGradientColors() {
        let cgColors = colors.map { $0.cgColor }
        applyTransaction {
            gradientLayer.colors = cgColors
        }
    }
    
    private func updateGradientLocations() {
        applyTransaction {
            gradientLayer.locations = locations
        }
    }
    
    private func updateGradientDirection() {
        applyTransaction {
            switch direction {
            case .leftToRight:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            case .topToBottom:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            case .leftTopToRightBottom:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            case .leftBottomToRightTop:
                gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            }
        }
    }
    
    private func updateGradientFrame() {
        applyTransaction {
            gradientLayer.frame = bounds
        }
    }
    
    private func applyTransaction(_ updates: () -> Void) {
        if forbidDefaultAnimation {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            updates()
            CATransaction.commit()
        } else {
            updates()
        }
    }
}
