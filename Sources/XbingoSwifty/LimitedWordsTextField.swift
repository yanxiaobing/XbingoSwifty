//
//  LimitedWordsTextField.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/7/15.
//

import UIKit

public class LimitedWordsTextField: UITextField {
    
    public var maxWords: Int = 0
    public var isTrim: Bool = false
    public var didChangeBlock: ((_ textField: UITextField)->Void)?
    public var shouldReturnBlock: ((UITextField)->(Bool))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        addTarget(self, action: #selector(textFiledDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        didSet{
            didChangeBlock?(self)
        }
    }
}

extension LimitedWordsTextField: UITextFieldDelegate {
    
    @objc func textFiledDidChange(_ sender: UITextField) -> Void {
        
        if maxWords <= 0 && !isTrim {
            didChangeBlock?(sender)
            return
        }
        
        if let mr = sender.markedTextRange, let _ = sender.position(from: mr.start, offset: 0) {
            didChangeBlock?(sender)
            return
        }
        
        if maxWords > 0 {
            let textContent = isTrim ? sender.text?.trim() : sender.text
            let textCount = textContent?.count ?? 0
            
            // 超长
            if textCount > maxWords {
                sender.text = String(textContent?.prefix(maxWords) ?? "")
                return
            }
            
            // trim前后不一致
            if textContent != sender.text {
                sender.text = textContent
                return
            }
            
            didChangeBlock?(sender)
            return
        }
        
        if !isTrim {
            didChangeBlock?(sender)
            return
        }
        
        if sender.text != sender.text?.trim() {
            sender.text = sender.text?.trim()
            return
        }
        
        didChangeBlock?(sender)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return shouldReturnBlock?(textField) ?? true
    }
}

extension UITextField {
    func setPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = .init(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
}
