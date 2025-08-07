//
//  UIViewControllerExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2025/8/7.
//

import UIKit

public extension UIViewController{
    
    public func fullPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil){
        
        if #available(iOS 13.0, *) {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: flag, completion: completion)
            return
        }
            
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
