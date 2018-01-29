//
//  PathTool.swift
//  tinCRM
//
//  Created by Richard.q.x on 16/8/5.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import Foundation

struct PathTool {
    
    /// 文档目录，可iTunes备份
    static var document: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    // 缓存目录，手动清空，系统在空间不足的时候会清空
    static var cache: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    
    // library目录，不会清空
    static var library: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }
    
    // 临时文件目录，重启清空
    static var temp: String {
        return NSTemporaryDirectory()
    }
    
}
