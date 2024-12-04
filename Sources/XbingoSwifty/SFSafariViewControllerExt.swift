//
//  SFSafariViewControllerExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/4.
//

import SafariServices

public extension SFSafariViewController {
    static func present(url: String?, on: UIViewController?, completion: (() -> Void)? = nil) -> Void {
        guard let u = url, let tUrl = URL(string: u) else { return }
        let safari = SFSafariViewController(url: tUrl)
        on?.present(safari, animated: true, completion: completion)
    }
}
