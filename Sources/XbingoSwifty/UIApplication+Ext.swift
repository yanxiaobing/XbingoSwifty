//
//  UIApplication+Ext.swift
//  XbingoSwifty
//
//  Created by xbingo on 2025/9/11.
//
import UIKit

public extension UIApplication {
    public var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
