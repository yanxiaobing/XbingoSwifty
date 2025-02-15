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
    
    @preconcurrency @MainActor
    var angle: CGFloat {
        self * .pi / 180
    }
    
    @preconcurrency @MainActor
    static var minH: CGFloat {
        1 / UIScreen.main.scale
    }
}

public extension Int {
    @preconcurrency @MainActor
    var pt: CGFloat {
        UIScreen.main.bounds.width / 375.0 * CGFloat(self)
    }
    
    @preconcurrency @MainActor
    var angle: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

public extension Double {
    @preconcurrency @MainActor
    var pt: CGFloat {
        UIScreen.main.bounds.width / 375.0 * CGFloat(self)
    }
    
    @preconcurrency @MainActor
    var angle: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
