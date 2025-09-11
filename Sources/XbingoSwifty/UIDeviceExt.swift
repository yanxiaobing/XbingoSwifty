//
//  UIDevice.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/4.
//

import UIKit

public extension UIDevice{
    
    static var uuid: String {
        return UUID().uuidString.lowercased()
    }

    static var appVersion : String{
        guard let version : String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "1.0.0"
        }
        return version
    }
    
    static var buildVersion: String {
        guard let version : String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return "2025080701"
        }
        return version
    }
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
    }()
    
    static var marketMode: String{
        return iPhoneDevice[modelName] ?? modelName
    }
}


//https://www.theiphonewiki.com/wiki/Models#iPhone
let iPhoneDevice = ["i386":"32-bit Simulator",
                    "x86_64":"64-bit Simulator",
                    "iPhone1,1":"iPhone",
                    "iPhone1,2":"iPhone 3G",
                    "iPhone2,1":"iPhone 3GS",
                    "iPhone3,1":"iPhone 4 (GSM)",
                    "iPhone3,3":"iPhone 4 (CDMA/Verizon/Sprint)",
                    "iPhone4,1":"iPhone 4S",
                    "iPhone5,1":"iPhone 5 (model A1428,AT&T/ Canada)",
                    "iPhone5,2":"iPhone 5 (model A1429, everything else)",
                    "iPhone5,3":"iPhone 5c (model A1456, A1532 | GSM)",
                    "iPhone5,4":"iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)",
                    "iPhone6,1":"iPhone 5s (model A1433, A1533 | GSM)",
                    "iPhone6,2":"iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)",
                    "iPhone7,1":"iPhone 6 Plus",
                    "iPhone7,2":"iPhone 6",
                    "iPhone8,1":"iPhone 6S",
                    "iPhone8,2":"iPhone 6S Plus",
                    "iPhone8,4":"iPhone SE",
                    "iPhone9,1":"iPhone 7 (CDMA)",
                    "iPhone9,2":"iPhone 7 Plus (CDMA)",
                    "iPhone9,3":"iPhone 7 (GSM)",
                    "iPhone9,4":"iPhone 7 Plus (GSM)",
                    "iPhone10,1":"iPhone 8 (CDMA)",
                    "iPhone10,2":"iPhone 8 Plus (CDMA)",
                    "iPhone10,3":"iPhone X (CDMA)",
                    "iPhone10,4":"iPhone 8 (GSM)",
                    "iPhone10,5":"iPhone 8 Plus (GSM)",
                    "iPhone10,6":"iPhone X (GSM)",
                    "iPhone11,2":"iPhone XS",
                    "iPhone11,4":"iPhone XS Max",
                    "iPhone11,6":"iPhone XS Max China",
                    "iPhone11,8":"iPhone XR",
                    "iPhone12,1":"iPhone 11",
                    "iPhone12,3":"iPhone 11 Pro",
                    "iPhone12,5":"iPhone 11 Pro Max",
                    "iPhone12,8":"iPhone SE2",
                    "iPhone13,1":"iPhone 12 mini",
                    "iPhone13,2":"iPhone 12",
                    "iPhone13,3":"iPhone 12 Pro",
                    "iPhone13,4":"iPhone 12 Pro Max",
                    "iPhone14,4":"iPhone 13 mini",
                    "iPhone14,5":"iPhone 13",
                    "iPhone14,2":"iPhone 13 Pro",
                    "iPhone14,3":"iPhone 13 Pro Max",
                    "iPhone14,7":"iPhone 14",
                    "iPhone14,8":"iPhone 14 Plus",
                    "iPhone15,2":"iPhone 14 Pro",
                    "iPhone15,3":"iPhone 14 Pro Max",
                    "iPhone15,4":"iPhone 15",
                    "iPhone15,5":"iPhone 15 Plus",
                    "iPhone16,1":"iPhone 15 Pro",
                    "iPhone16,2":"iPhone 15 Pro Max",
                    "iPhone17,1":"iPhone 16 Pro",
                    "iPhone17,2":"iPhone 16 Pro Max",
                    "iPhone17,3":"iPhone 16",
                    "iPhone17,4":"iPhone 16 Plus",
                    "iphone17,5":"iPhone 16e",
                    "iPad1,1":"iPad",
                    "iPad2,1":"iPad 2",
                    "iPad3,1":"iPad",
                    "iPad4,1":"iPad Air",
                    "iPad4,2":"iPad Air",
                    "iPad4,4":"iPad Mini",
                    "iPad4,5":"iPad Mini",
                    "iPad4,7":"iPad Mini",
                    "iPad6,3":"iPad Pro (9.7)",
                    "iPad6,4":"iPad Pro (9.7)",
                    "iPad6,7":"iPad Pro (12.9)",
                    "iPad6,8":"iPad Pro (12.9)"
]
