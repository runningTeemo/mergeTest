//
//  Array_Ext.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/20.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import Foundation

/// 模型数组去重
func QXDistinct<T>(arr: [T], compare: ((_ a: T, _ b: T) -> Bool)) -> [T] {
    var _arr = [T]()
    for a in arr {
        var thereIsOne = false
        for _a in _arr {
            if compare(_a, a) {
                thereIsOne = true
                break
            }
        }
        if !thereIsOne {
            _arr.append(a)
        }
    }
    return _arr
}

extension Array {

    func ifExsit(_ idx: Int) -> Any? {
        if idx < 0 || idx > self.count - 1 {
            return nil
        }
        return self[idx]
    }
    
}

extension Bool {
    func appToString() -> String {
        return self ? "1" : "0"
    }
}
extension Int {
    func appToString() -> String {
        return "\(self)"
    }
}
extension Double {
    func appToString() -> String {
        return "\(self)"
    }
}
extension Date {
    func appToString() -> String {
        return "\(UInt64(timeIntervalSince1970) * 1000)"
    }
}

extension Dictionary {
    
    mutating func append(_ dic: Dictionary) {
        for (key, value) in dic {
            self[key] = value
        }
    }
    
    mutating func append(_ key: Key, notNullValue: Value) {
        self[key] = notNullValue
    }
    
    mutating func append(_ key: Key, value: Value?, holderForNull: Value) {
        if let value = value {
            self[key] = value
        } else {
            self[key] = holderForNull
        }
    }
    
    mutating func checkOrAppend(_ key: Key, value: Value?) {
        if let value = value {
            self[key] = value
        }
    }
    
    func nullableDate(_ key: Key) -> Date? {
        if let double = nullableDouble(key) {
            return Date(timeIntervalSince1970: double / 1000)
        } else {
            return nil
        }
    }
    func nullableInt(_ key: Key) -> Int? {
        if let value = self[key] {
            if value is String {
                return (value as! NSString).integerValue
            } else if value is NSNumber {
                return (value as! NSNumber).intValue
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func nullableDouble(_ key: Key) -> Double? {
        if let value = self[key] {
            if value is String {
                return (value as! NSString).doubleValue
            } else if value is NSNumber {
                return (value as! NSNumber).doubleValue
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func nullableString(_ key: Key) -> String? {
        if let value = self[key] {
            if value is String {
                let str = value as! String
                if str.characters.count > 0 {
                    return str
                } else {
                    return nil
                }
            } else if value is NSNumber {
                return "\((value as! NSNumber))"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func nullableBool(_ key: Key) -> Bool? {
        if let value = self[key] {
            if value is String {
                let str = value as! String
                if str.contains("n") || str.contains("N") || str.contains("F") || str.contains("f") {
                    return false
                } else if str.contains("Y") || str.contains("y") || str.contains("T") || str.contains("t") {
                    return true
                } else {
                    return (value as! NSString).boolValue
                }
            } else if value is NSNumber {
                return (value as! NSNumber).boolValue
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
