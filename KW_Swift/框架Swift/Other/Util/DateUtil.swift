//
//  DateUtil.swift
//  KW_Swift
//
//  Created by bingxin on 2021/1/19.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation

struct  DateUtil {

    static  let YYYY_MM :String = "yyyy-MM"
    static  let YYYY_MM_DD :String = "yyyy-MM-dd"
    static  let YYYY_MM_DD_HH :String = "yyyy-MM-dd HH"
    static  let YYYY_MM_DD_HH_MM :String = "yyyy-MM-dd HH:mm"
    static  let YYYY_MM_DD_HH_MM_SS :String = "yyyy-MM-dd HH:mm:ss"
    init() {
        
    }
    //获取当前时间
    static func getCurrentDate() -> String {
        let now = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy年MM月dd日"
        return df.string(from: now)
    }
    //获取当前时间
   static func getCurrentDateWithFormat(format:String = YYYY_MM_DD_HH_MM_SS) -> String {
        let now = Date()
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: now)
    }
   
    
    //日期 -> 字符串
    static  func formatDate( dateStr:String, oldFormat:String , newFormat:String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = oldFormat
        let date = formatter.date(from: dateStr)
        
        
        formatter.dateFormat = newFormat
        let dateStr = formatter.string(from: date!)
        
        return dateStr
    }
    
    //字符串 -> 日期
    static  func string2Date(_ string:String, dateFormat:String = YYYY_MM_DD_HH_MM_SS) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date!
    }
    
    
    //date -> 字符串
    static func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    //获取前一天、后一天
    static func getLastDay(_ nowDay: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 先把传入的时间转为 date
        let date = dateFormatter.date(from: nowDay)
        //let lastTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
        let lastTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        
        let lastDate = date?.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate!)
        return lastDay
    }
    //获取两个日期中的每一天
    static func getDaysArr(start: String ,end:String) -> [Date] {
        var array:[Date] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startdate = dateFormatter.date(from: start) //第一天
        let enddate = dateFormatter.date(from: end) //最后一天
        array.append(startdate!)
        
        let nextTime: TimeInterval = 24*60*60
        var nextDate = startdate?.addingTimeInterval(nextTime) //第二天
        array.append(nextDate!)
        if enddate?.compare(nextDate!) == .orderedAscending {
            return array
        }
        
        for _ in 0...50 {
            nextDate = nextDate?.addingTimeInterval(nextTime) //第三四。。。天
            array.append(nextDate!)
            
            if enddate?.compare(nextDate!) == .orderedAscending {
                array.removeLast()
                return array
            }
        }
        
        return array
    }
}
