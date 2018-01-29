//
//  TinKeyDefs.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

/// 公用key模型
struct TinKey<Code: Equatable> {
    var code: Code
    var name: String
}

/// 根据name查询code
func TinSearch<T>(name: String?, inKeys: [TinKey<T>]) -> TinKey<T>? {
    if let name = name {
        for key in inKeys {
            if key.name == name {
                return key
            }
        }
    }
    return nil
}
/// 根据code查询name
func TinSearch<T: Equatable>(code: T?, inKeys: [TinKey<T>]) -> TinKey<T>? {
    if let code = code {
        for key in inKeys {
            if key.code == code {
                return key
            }
        }
    }
    return nil
}
/// 获取所有name
func TinGetNames<T>(keys: [TinKey<T>]) -> [String] {
    var names = [String]()
    for key in keys {
        names.append(key.name)
    }
    return names
}

/// 获取所有name, 前面附加一个name
func TinGetNames<T>(preName: String,  keys: [TinKey<T>]) -> [String] {
    var names = [String]()
    names.append(preName)
    for key in keys {
        names.append(key.name)
    }
    return names
}



// ————————————————————————————  BREAK  ————————————————————————————

/// key设置示例
let kDemoKeys: [TinKey<Int>] = [
    TinKey(code: 0, name: "类型A"),
    TinKey(code: 1, name: "类型B"),
    TinKey(code: 2, name: "类型C"),
    TinKey(code: 3, name: "类型D")
]
