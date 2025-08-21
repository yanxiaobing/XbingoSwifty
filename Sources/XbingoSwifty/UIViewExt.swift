//
//  UIViewExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/30.
//

import UIKit

public extension UIView {
    
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let path = UIBezierPath()

        // 起点：左上角开始
        path.move(to: CGPoint(x: topLeft, y: 0))
        
        // 顶边
        path.addLine(to: CGPoint(x: bounds.width - topRight, y: 0))
        path.addQuadCurve(to: CGPoint(x: bounds.width, y: topRight),
                          controlPoint: CGPoint(x: bounds.width, y: 0))
        
        // 右边
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - bottomRight))
        path.addQuadCurve(to: CGPoint(x: bounds.width - bottomRight, y: bounds.height),
                          controlPoint: CGPoint(x: bounds.width, y: bounds.height))
        
        // 底边
        path.addLine(to: CGPoint(x: bottomLeft, y: bounds.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: bounds.height - bottomLeft),
                          controlPoint: CGPoint(x: 0, y: bounds.height))
        
        // 左边
        path.addLine(to: CGPoint(x: 0, y: topLeft))
        path.addQuadCurve(to: CGPoint(x: topLeft, y: 0),
                          controlPoint: CGPoint(x: 0, y: 0))
        
        path.close()
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
    
    func showShadow(
        color: UIColor? = UIColor.black.withAlphaComponent(0.5),
        offset: CGSize? = .init(width: 2, height: 2),
        opacity: Float? = 0.4,
        radius: CGFloat? = 4
    ) -> Void {
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOffset = offset ?? .zero
        self.layer.shadowOpacity = opacity ?? .zero
        self.layer.shadowRadius = radius ?? .zero
    }
}

public extension UIView {

    // MARK: - Frame Properties

    var xb_width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var xb_height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    var xb_top: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var xb_left: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var xb_bottom: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }

    var xb_right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }

    // MARK: - Center Properties

    var xb_centerX: CGFloat {
        get { return self.center.x }
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }

    var xb_centerY: CGFloat {
        get { return self.center.y }
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
}
