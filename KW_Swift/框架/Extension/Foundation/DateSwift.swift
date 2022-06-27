//
//  DateSwift.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/29.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation


extension Date: KWSwiftCompatibleValue {}

public extension KWSwiftWrapper where Base == Date {
    
    /// 用户当前地区日历
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
    }
    
    // MARK: - 当前时间
    
    /// 年
    var year: Int {
        get { return calendar.component(.year, from: base)}
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: base)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// 月
    var month: Int {
        get { return calendar.component(.month, from: base) }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: base)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// 日
    var day: Int {
        get { return calendar.component(.day, from: base) }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: base)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// 星期
    var weekday: Int {
        return calendar.component(.weekday, from: base)
    }
    
    /// 时
    var hour: Int {
        get { return calendar.component(.hour, from: base) }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = calendar.component(.hour, from: base)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// 分
    var minute: Int {
        get { return calendar.component(.minute, from: base) }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: base)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: base) {
                base = date
            }
        }
    }
    
    /// 秒
    var second: Int {
        get { return calendar.component(.second, from: base) }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: base)
            let secondsToAdd = newValue - currentSeconds
            if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: base) {
                base = date
            }
        }
    }
    
    
    // MARK: -
    
    
    /// 是否是以后的时间
    ///
    ///     Date(timeInterval: -100, since: Date()).isInFuture -> true
    ///
    var isInFuture: Bool {
        return base > Date()
    }

    /// 是否是过去的时间
    ///
    ///     Date(timeInterval: -100, since: Date()).isInPast -> true
    ///
    var isInPast: Bool {
        return base < Date()
    }

    /// 是否是今天
    ///
    ///     Date().isInToday -> true
    ///
    var isInToday: Bool {
        return calendar.isDateInToday(base)
    }

    /// 是否是昨天
    ///
    ///     Date().isInYesterday -> false
    ///
    var isInYesterday: Bool {
        return calendar.isDateInYesterday(base)
    }

    /// 是否是明天
    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(base)
    }

    /// 是否是休息日
    var isInWeekend: Bool {
        return calendar.isDateInWeekend(base)
    }

    /// 是否是工作日
    var isWorkday: Bool {
        return !calendar.isDateInWeekend(base)
    }

    /// 是否属于这个星期
    var isInCurrentWeek: Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 是否属于这个月
    var isInCurrentMonth: Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .month)
    }

    /// 是否属于今年
    var isInCurrentYear: Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: .year)
    }
    
    /// 昨天
    var yesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: base) ?? Date()
    }
    
    /// 明天
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: base) ?? Date()
    }
    
    /// 时间戳字符串
    var timestampString: String {
        return String(Int(base.timeIntervalSince1970))
    }
    
}


public extension KWSwiftWrapper where Base == Date {
    
    /// 生成一个新的日期
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: 类型
    ///   - value: 差值
    /// - Returns: 新的日期
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: base)!
    }
    
    
    /// 当前时间转字符串
    ///
    ///     Date().kw.string() -> "2020-05-31 15:16:28"
    ///     Date().kw.string(withFormat: "yyyy-MM-dd") -> "2020-05-31"
    ///
    /// - Parameter format: 格式
    /// - Returns: 日期格式字符串
    func string(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: base)
    }
    
    /// 计算两个日期之前的间隔 （年、月、日、周）
    /// - Parameters:
    ///   - toDate: 结束时间
    ///   - unit: 单位
    /// - Returns: 单位数量
    func unitsBetweenDate(toDate: Date, unit: Calendar.Component) -> Int {
        let components = calendar.dateComponents([unit], from: base, to: toDate)
        switch unit {
        case .year:
            return components.year ?? 0
        case .month:
            return components.month ?? 0
        case .weekOfYear:
            return components.weekOfYear ?? 0
        case .day:
            return components.day ?? 0
        default:
            return 0
        }
    }
    
    /// 时间转字符串
    ///
    ///     Date.kw.string(fromDate: Date()) -> "2020-05-31 15:18:03"
    ///     Date.kw.string(fromDate: Date(), format: "yyyy-MM-dd") -> "2020-05-31"
    ///
    /// - Parameters:
    ///   - date: 时间
    ///   - format: 格式
    /// - Returns: 日期格式字符串
    static func string(fromDate date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /// 时间字符串转时间
    ///
    ///     Date.kw.date(fromString: "2020-05-31", format: "yyyy-MM-dd") -> Date
    ///
    /// - Parameters:
    ///   - string: 字符串
    ///   - format: 格式
    /// - Returns: 日期
    static func date(fromString string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    /// 比较两个时间字符串的大小
    /// - Parameters:
    ///   - string1: 第一个
    ///   - string2: 第二个
    /// - Returns: 结果
    static func compare(string1: String, string2: String) -> ComparisonResult {
        guard !string1.isEmpty, !string2.isEmpty else { return .orderedSame }
        let dateFormatter = DateFormatter()
        let date1 = dateFormatter.date(from: string1) ?? Date()
        let date2 = dateFormatter.date(from: string2) ?? Date()
        return date1.compare(date2)
    }
    
    //MARK: 前几天日期
    static func getLastDay(_ nowDay: String ,dayNum:Int) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // 先把传入的时间转为 date
            let date = dateFormatter.date(from: nowDay)
        let lastTime: TimeInterval = TimeInterval(-(24*60*60 * dayNum)) // 往前减去一天的秒数，昨天
    //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
            
            let lastDate = date?.addingTimeInterval(lastTime)
            let lastDay = dateFormatter.string(from: lastDate!)
            return lastDay
        }
}
