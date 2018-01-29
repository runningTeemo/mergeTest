//
//  History.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/10.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class History {
    let time: Date
    let key: String
    init(key: String, time: Date) {
        self.key = key
        self.time = time
    }
    func toString() -> String {
        return "\(key) \(time.timeIntervalSince1970)"
    }
    init(str: String) {
        let strs = str.components(separatedBy: " ")
        let key = strs[0]
        let date = Date(timeIntervalSince1970: (strs[1] as NSString).doubleValue)
        self.key = key
        self.time = date
    }
    
    class func getHistories() -> [History] {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: cachePath()), options: NSData.ReadingOptions(rawValue: 0))
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let arr = obj as? [String] {
                    var histories = [History]()
                    for str in arr {
                        let history = History(str: str)
                        histories.append(history)
                    }
                    return histories
                } else {
                    //assert(true, "本地accout数据解析得到的不是字典")
                }
            } catch {
                print("本地accout数据json解析失败\(error)")
            }
        } catch {
            print("本地accout数据加载失败\(error)")
        }
        return [History]()
    }
    
    class func saveHistories(_ histories: [History]) {
        var arr = [String]()
        for history in histories {
            arr.append(history.toString())
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions(rawValue: 0))
            if !((try? data.write(to: URL(fileURLWithPath: cachePath()), options: [.atomic])) != nil) {
                print("保存用户失败，保存失败")
            }
        } catch {
            print("用户数据序列化保存失败\(error)")
        }
    }
    
    class func cachePath() -> String {
        if let id = Account.sharedOne.optionalUserId {
            return PathTool.document + "/" + id + "_search.cache"
        } else {
            return PathTool.cache + "/default_search.cache"
        }
    }
    
}
