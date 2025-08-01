//
//  StringExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/4.
//

import UIKit
import CommonCrypto
import CryptoKit

public extension String {
    
    var trim: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var md5: String {
        
        guard let data = data(using: .utf8) else {
            return self
        }
        
        if #available(iOS 13.0, *) {
            return Insecure.MD5.hash(data: data).map {String(format: "%02x", $0)}.joined()
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02x", $0) }.joined()
        }
    }
}

// 手机号码相关
public extension String {
    
    public var containsPhone: Bool {
        let regex = "(\\d{3})(\\d{4})(\\d{4})"
        let replacedString = self.replacingOccurrences(of: regex, with: "$1****$3")
        return replacedString != self
    }
    
    public var desensitizedText: String {
        let regex = "(\\d{3})(\\d{4})(\\d{4})"
        return self.replacingOccurrences(of: regex, with: "$1****$3", options: .regularExpression)
    }
    
    func isEmail() -> Bool{
        if self.count == 0 { return false }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}

// 高度计算
extension String {
    
    public func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil) -> CGSize {
        let attritube = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: attritube.length)
        attritube.addAttributes([NSAttributedString.Key.font: font], range: range)
        if lineSpacing != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing!
            attritube.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        let rect = attritube.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        var size = rect.size
        
        if let currentLineSpacing = lineSpacing {
            // 文本的高度减去字体高度小于等于行间距，判断为当前只有1行
            let spacing = size.height - font.lineHeight
            if spacing <= currentLineSpacing && spacing > 0 {
                size = CGSize(width: size.width, height: font.lineHeight)
            }
        }
        
        return size
    }
    
    public func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil, lines: Int) -> CGSize {
        if lines < 0 {
            return .zero
        }
        
        let size = boundingRect(with: constrainedSize, font: font, lineSpacing: lineSpacing)
        if lines == 0 {
            return size
        }
        
        let currentLineSpacing = (lineSpacing == nil) ? (font.lineHeight - font.pointSize) : lineSpacing!
        let maximumHeight = font.lineHeight*CGFloat(lines) + currentLineSpacing*CGFloat(lines - 1)
        if size.height >= maximumHeight {
            return CGSize(width: size.width, height: maximumHeight)
        }
        
        return size
    }
}


// 富文本
public extension String {
    
    func paraAttrStr(lineSpacing : CGFloat = 6) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        let paragStyle = NSMutableParagraphStyle.init()
        paragStyle.lineSpacing = lineSpacing
        let range = NSMakeRange(0, self.count)
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle:paragStyle], range: range)
        return attrStr
    }
    
    func colorAttrString(_ withTargetColor:UIColor,targetTexts:[String]) -> NSAttributedString {
        return attrString(targetColor:withTargetColor, targetTexts: targetTexts)
    }
    
    func fontAttrString(_ withTargetFont:UIFont, baseOffset: Any? = 0, targetTexts:[String]) -> NSAttributedString {
        return attrString(targetFont: withTargetFont, baseOffset: baseOffset, targetTexts: targetTexts)
    }
    
    func attrString(
        targetFont:UIFont? = nil,
        targetColor:UIColor? = nil,
        baseOffset:Any? = 0,
        minimumLineHeight: CGFloat? = nil,
        targetTexts:[String]) -> NSAttributedString
    {
        let attrStr = NSMutableAttributedString.init(string: self)
        for subText in targetTexts {
            let ranges = self.nsranges(of: subText)
            for range in ranges {
                if let font = targetFont {
                    attrStr.addAttribute(NSAttributedString.Key.font, value: font, range: range)
                }
                if let color = targetColor {
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                }
                if let offset = baseOffset {
                    attrStr.addAttribute(NSAttributedString.Key.baselineOffset, value: offset, range: range)
                }
            }
        }
        
        if let minLineHeight = minimumLineHeight {
            let paragStyle = NSMutableParagraphStyle.init()
            let range = NSMakeRange(0, self.count)
            paragStyle.minimumLineHeight = minLineHeight
            attrStr.addAttributes([NSAttributedString.Key.paragraphStyle:paragStyle], range: range)
        }
        return attrStr
    }
    
    func nsranges(of string: String) -> [NSRange] {
        var ranges = [NSRange]()
        var searchRange = self.startIndex..<self.endIndex
        while let range = self.range(of: string, options: .literal, range: searchRange) {
            ranges.append(NSRange(range, in: self))
            searchRange = range.upperBound..<self.endIndex
        }
        return ranges
    }
    
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    
    func nsrange(fromRange range : Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
}
