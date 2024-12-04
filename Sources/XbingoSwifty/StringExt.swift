//
//  StringExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/4.
//


// 手机号码相关
extension String {
    
    public var containsPhone: Bool {
        let regex = "(\\d{3})(\\d{4})(\\d{4})"
        let replacedString = self.replacingOccurrences(of: regex, with: "$1****$3")
        return replacedString != self
    }
    
    public var desensitizedText: String {
        let regex = "(\\d{3})(\\d{4})(\\d{4})"
        return self.replacingOccurrences(of: regex, with: "$1****$3", options: .regularExpression)
    }
}
