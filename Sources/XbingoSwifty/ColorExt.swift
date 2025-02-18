//
//  ColorExt.swift
//  QuitSmoke
//
//  Created by xbingo on 2024/11/9.
//  Copyright © 2024 Xbingo. All rights reserved.
//

import SwiftUI

@dynamicMemberLookup
public struct ThemeColor {
    public subscript(dynamicMember member: String) -> UIColor {
        let hex = member.dropFirst() // 去掉首字母“c”
        return UIColor.color(hexStr: String(hex))
    }
    
    public subscript(dynamicMember member: String) -> Color {
        let hex = member.dropFirst() // 去掉首字母“c”
        return Color.color(hexStr: String(hex))
    }
}

public extension UIColor {
    
    nonisolated(unsafe) static let theme = ThemeColor()
    
    static func color(hexStr: String) -> UIColor {
        var hex = hexStr.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        
        let scanner = Scanner(string: hex)
        if scanner.scanHexInt64(&rgb) {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        }
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static var random: UIColor {
        let red = Int(arc4random_uniform(256))
        let green = Int(arc4random_uniform(256))
        let blue = Int(arc4random_uniform(256))
        let hexStr = String(format: "#%02X%02X%02X", red, green, blue)
        return color(hexStr: hexStr)
    }
    
    func alpha(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
}

public extension Color {
    nonisolated(unsafe) static let theme = ThemeColor()

    static func color(hexStr: String) -> Color {
        return Color(UIColor.color(hexStr: hexStr))
    }
    
    static var random: Color {
        return Color(UIColor.random)
    }
}
