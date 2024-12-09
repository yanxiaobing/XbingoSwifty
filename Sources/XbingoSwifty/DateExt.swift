//
//  DateExt.swift
//  XbingoSwifty
//
//  Created by xbingo on 2024/12/9.
//


import UIKit
import Foundation
import Darwin

// 单例优化转化效率
public class DateService {
    
    @preconcurrency @MainActor
    public static let shared = DateService()
    
    private init() {}
    
    public lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        return f
    }()
}

// MARK: Date expand var
public extension Date{
    static var systemLaunchTs: Double? {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.size
        var now = time_t()
        time(&now)
        
        if sysctl(&mib, u_int(mib.count), &boottime, &size, nil, 0) != -1, boottime.tv_sec != 0 {
            let uptime = now - boottime.tv_sec
            return TimeInterval(uptime) * 1000
        }
        return nil
    }
}

// MARK: Date offset
public extension Date{
    
    public func yearOffset(_ offset:Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: offset, to: self) ?? self
    }
    
    public func monthOffset(_ offset:Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: offset, to: self) ?? self
    }
    
    public func dayOffset(_ offset:Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: offset, to: self) ?? self
    }
    
    public func hourOffset(_ offset:Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: offset, to: self) ?? self
    }
    
    public func minuteOffset(_ offset:Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: offset, to: self) ?? self
    }
    
    public func secondOffset(_ offset:Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: offset, to: self) ?? self
    }
}
