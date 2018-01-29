//
//  NullTool.swift
//  tinCRM
//
//  Created by Richard.q.x on 16/8/19.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import Foundation

func NotNull<T>(_ value: T?) -> Bool {
    return !Null(value)
}
func Null<T>(_ value: T?) -> Bool {
    return value == nil ? true : false
}

func NotNull<T>(_ values: T?..., then: (() -> ())) -> Bool {
    for value in values {
        if Null(value) {
            return false
        }
    }
    then()
    return true
}


func SafeUnwarp<T>(_ value: T?, holderForNull: T) -> T {
    if Null(value) {
        return holderForNull
    }
    return value!
}

func NullText(_ text: String?) -> Bool {
    if let text = text {
        if text.characters.count > 0 {
            return false
        }
    }
    return true
}

func NotNullText(_ text: String?) -> Bool {
    return !NullText(text)
}
