//
//  FileManagerExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2025/9/30.
//

import Foundation

public extension FileManager {
    
    /// Document 目录
    /// - 用于存储用户生成的数据或不可再生的数据
    /// - 会随 iCloud 备份
    /// - `Documents/Inbox`：用于存放外部 App 打开的文件副本
    var documentURL: URL {
        urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Library 目录
    /// - 存储配置、缓存或持久化数据
    /// - `Library/Preferences`：系统偏好设置目录（不要手动写）
    /// - `Library/Caches`：可再生成的数据缓存
    var libraryURL: URL {
        urls(for: .libraryDirectory, in: .userDomainMask).first!
    }
    
    /// Caches 目录
    /// - 存放可再生的缓存数据
    /// - 系统可能在空间不足时清理
    /// - 不会备份到 iCloud
    var cachesURL: URL {
        urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    /// tmp 目录
    /// - 存放临时文件
    /// - 应用退出后系统可能随时清理
    /// - 不会备份到 iCloud
    var tempURL: URL {
        URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }
    
    // MARK: - 子路径拼接工具
    
    /// 在 Document 目录下拼接子路径
    func documentSubPath(_ name: String) -> URL {
        documentURL.appendingPathComponent(name)
    }
    
    /// 在 Library 目录下拼接子路径
    func librarySubPath(_ name: String) -> URL {
        libraryURL.appendingPathComponent(name)
    }
    
    /// 在 Caches 目录下拼接子路径
    func cachesSubPath(_ name: String) -> URL {
        cachesURL.appendingPathComponent(name)
    }
}
