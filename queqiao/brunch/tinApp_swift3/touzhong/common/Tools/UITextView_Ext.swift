//
//  UITextView_Ext.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/3/6.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 检测是否含有提示文本
    var qxHasSelectRange: Bool {
        if let range = markedTextRange {
            if !range.isEmpty {
                return true
            }
        }
        return false
    }
    
    /// 选中的range (0, 0) 表示没选中
    var qxSelectRangeTuple: (start: Int, end: Int, length: Int) {
        if self.qxHasSelectRange {
            let selectRange = self.markedTextRange!
            let textBegin = self.beginningOfDocument
            let start = self.offset(from: textBegin, to: selectRange.start)
            let length = self.offset(from: selectRange.start, to: selectRange.end)
            return (start, start + length, length)
        }
        return (0, 0, 0)
    }
    
    /// 选中的文字 "" 表示没有
    var qxSelectText: String {
        if self.qxHasSelectRange {
            let allString = self.text!
            let range = self.qxSelectRangeTuple
            let selStart = allString.index(allString.startIndex, offsetBy: range.start)
            let selEnd = allString.index(allString.startIndex, offsetBy: range.end)
            return allString.substring(with: selStart..<selEnd)
        }
        return ""
    }
    
    /// 选中的文字的前面的文字 "" 表示没有
    var qxBeforeSelectText: String {
        if self.qxHasSelectRange {
            let allString = self.text!
            let range = self.qxSelectRangeTuple
            let selStart = allString.index(allString.startIndex, offsetBy: range.start)
            return allString.substring(to: selStart)
        }
        return ""
    }
    
    /// 选中的文字的后面的文字 "" 表示没有
    var qxAfterSelectText: String {
        if self.qxHasSelectRange {
            let allString = self.text!
            let range = self.qxSelectRangeTuple
            let selEnd = allString.index(allString.startIndex, offsetBy: range.end)
            return allString.substring(from: selEnd)
        }
        return ""
    }
    
    
    /// 在没有选中的文字的情况下操作，在选中文本消失的时候需要重新调用
    func qxLimitToLength(_ len: Int) {
        // 主限制操作
        func _checkOrCut(_ t: String) -> String {
            if t.characters.count >= len {
                let toIdx = t.index(t.startIndex, offsetBy: len)
                return t.substring(to: toIdx)
            }
            return t
        }
        // 无提示文本
        func _noSelectRangeToDo() {
            var stringToCut = ""
            if let _text = self.text {
                stringToCut = _text
            }
            self.text = _checkOrCut(stringToCut)
        }
        
        // 处理
        func doIt() {
            if !self.qxHasSelectRange {
                _noSelectRangeToDo()
            }
        }
        // 执行两遍
        doIt()
        doIt()
    }
    
}
