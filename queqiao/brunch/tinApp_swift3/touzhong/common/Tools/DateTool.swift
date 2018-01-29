//
//  DateTool.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/17.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

struct SegDate {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
}

struct DateTool {
    
    static func laterOne(_ date1: Date?, date2: Date?) -> Date? {
        if date1 == nil && date2 == nil {
            return nil
        } else if date1 == nil && date2 != nil {
            return date2
        } else if date2 == nil && date1 != nil {
            return date1
        } else {
            return date1!.timeIntervalSince1970 > date2!.timeIntervalSince1970 ? date1 : date2
        }
    }
    
    static func getLaterOne(_ date: Date?...) -> Date? {
        
        var maxDate: Date = Date(timeIntervalSince1970: 0)
        var atLeastOne: Bool = false
        for _d in date {
            if let d = _d {
                atLeastOne = true
                if d.timeIntervalSince1970 > maxDate.timeIntervalSince1970 {
                    maxDate = d
                }
            }
        }
        if atLeastOne {
            return maxDate
        }
        return nil
    }
    
    /// 标准日期时间格式
    static var dateTimeFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return one
    }()
    static var dateTimeShortFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "yyyy-MM-dd HH:mm"
        return one
    }()
    
    /// 短日期时间格式
    static var shortDateTimeFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "MM-dd HH:mm:ss"
        return one
    }()
    
    /// 标准日期格式
    static var dateFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "yyyy-MM-dd"
        return one
    }()
    
    /// 标准时间格式
    static var timeFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "hh:mm:ss"
        return one
    }()
    
    /// 时间轴格式
    static var careerFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "yyyy.MM.dd"
        return one
    }()
    
    /// 分段格式
    static var segFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "yyyy MM dd HH mm ss"
        return one
    }()
    
    /// 分段格式
    static var slashDateFormater: DateFormatter = {
        let one =  DateFormatter()
        one.dateFormat = "yyyy/MM/dd"
        return one
    }()
    
    /**
     根据日期生成对应的标准格式字符串
     - parameter date: 日期
     - returns: 标准格式字符串
     */
    static func getDateTimeString(_ date: Date?) -> String? {
        if let date = date {
            return dateTimeFormater.string(from: date)
        }
        return nil
    }
    static func dateTime(_ str: String?) -> Date? {
        if let str = str {
            return dateTimeFormater.date(from: str)
        }
        return nil
    }
    static func getDateTimeShortString(_ date: Date?) -> String? {
        if let date = date {
            return dateTimeShortFormater.string(from: date)
        }
        return nil
    }
    static func dateTimeShort(_ str: String?) -> Date? {
        if let str = str {
            return dateTimeShortFormater.date(from: str)
        }
        return nil
    }
    static func getDateString(_ date: Date?) -> String? {
        if let date = date {
            return dateFormater.string(from: date)
        }
        return nil
    }
    static func getSlashString(_ date: Date?) -> String? {
        if let date = date {
            return slashDateFormater.string(from: date)
        }
        return nil
    }
    static func getTimeString(_ date: Date?) -> String? {
        if let date = date {
            return timeFormater.string(from: date)
        }
        return nil
    }
    static func getShortDateTimeString(_ date: Date?) -> String? {
        if let date = date {
            return shortDateTimeFormater.string(from: date)
        }
        return nil
    }
    static func getCareerString(_ date: Date?) -> String? {
        if let date = date {
            return careerFormater.string(from: date)
        }
        return nil
    }
    static func carreerDate(_ str: String?) -> Date? {
        if let str = str {
            return careerFormater.date(from: str)
        }
        return nil
    }
    
    static func getSegDate(_ date: Date?) -> SegDate? {
        if let date = date {
            let str = segFormater.string(from: date)
            let strs = str.components(separatedBy: " ")
            assert(strs.count >= 6)
            let year = (strs[0] as NSString).integerValue
            let month = (strs[1] as NSString).integerValue
            let day = (strs[2] as NSString).integerValue
            let hour = (strs[3] as NSString).integerValue
            let minute = (strs[4] as NSString).integerValue
            let second = (strs[5] as NSString).integerValue
            return SegDate(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        }
        return nil
    }
    
    static func getNature(_ date: Date?) -> String? {
        
        if date == nil { return nil }
        
        var timeString = NSString()
        let now = Date().timeIntervalSince1970
        let cha = now - date!.timeIntervalSince1970
        
        if (cha / 3600 < 1) {
            timeString = NSString(format: "%f", cha / 60)
            timeString = timeString.substring(to: timeString.length - 7) as NSString
            let num = timeString.intValue
            if num <= 1 {
                timeString = "刚刚..."
            }else{
                timeString =  "\(timeString)分钟前" as NSString
            }
        } else if (cha / 3600 > 1 && cha / 86400 < 1) {
            timeString = NSString(format: "%f", cha / 3600)
            timeString = timeString.substring(to: timeString.length - 7) as NSString
            timeString =  "\(timeString)小时前" as NSString
        } else if (cha/86400 > 1) {
            timeString = NSString(format: "%f", cha / 86400)
            timeString = timeString.substring(to: timeString.length - 7) as NSString
            let num = timeString.intValue
            if num < 2 {
                timeString = "昨天"
            } else if num == 2 {
                timeString = "前天"
            } else if num > 2 && num <= 7 {
                timeString = "\(num)天前" as NSString
            } else if (num > 7 && num <= 30){
                timeString = "\(num / 7)周前" as NSString
            } else if (num > 30 && num < 365) {
                timeString = "\(num / 30)个月前" as NSString
            } else {
                timeString = "\(num / 365)年前" as NSString
            }
        }
        
        return timeString as String
    }
    
}

