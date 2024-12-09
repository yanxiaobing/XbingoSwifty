//
//  DecimalExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/8.
//

import Foundation
import UIKit

public extension CGFloat {
    @preconcurrency @MainActor
    var pt: CGFloat {
        UIScreen.main.bounds.width / 375.0 * self
    }
}

public extension Int {
    @preconcurrency @MainActor
    var pt: CGFloat {
        UIScreen.main.bounds.width / 375.0 * CGFloat(self)
    }
}

public extension Double {
    @preconcurrency @MainActor
    var pt: CGFloat {
        UIScreen.main.bounds.width / 375.0 * CGFloat(self)
    }
}