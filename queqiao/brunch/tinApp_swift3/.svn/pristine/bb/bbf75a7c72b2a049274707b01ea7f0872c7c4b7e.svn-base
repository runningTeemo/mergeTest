//
//  QXSignal.swift
//  QXSignal
//
//  Created by Richard.q.x on 16/5/10.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

typealias QXSignalDone = () -> ()
typealias QXSignalAsycNext = (_ signal: QXSignal, _ done: QXSignalDone) -> ()
typealias QXSignalSycNext = (_ signal: QXSignal) -> ()


enum QXSignalEventType {
    case value
    case uiControl
    case nsNotification
}

class QXSignal: NSObject {
    
    fileprivate(set) var type: QXSignalEventType = .value
    fileprivate(set) var subType: Any?

    required init(content: AnyObject? = nil, type: QXSignalEventType = .value, subType: Any? = nil) {
        self.type = type
        self.subType = subType
    }
    
    class func combine(_ signals: QXSignal ...) -> QXSignal {
        let sig = QXSignal(content: nil)
        for s in signals {
            s.next({ (signal) in
                sig.activeSignal(nil)
            })
        }
        return sig
    }
    
    @discardableResult func head(_ head: @escaping QXSignalSycNext) -> QXSignal {
        _head = { (signal, done) in
            head(signal)
            done()
        }
        return self
    }
    
    @discardableResult func next(_ next: @escaping QXSignalSycNext) -> QXSignal {
        _nexts.append({ (signal, done) in
            next(signal)
            done()
        })
        return self
    }
    
    @discardableResult func asycHead(_ head: @escaping QXSignalAsycNext) -> QXSignal {
        _head = head
        return self
    }
    
    @discardableResult func asycNext(_ next: @escaping QXSignalAsycNext) -> QXSignal {
        _nexts.append(next)
        return self
    }
    
    func cleanNexts() {
        _nexts.removeAll()
    }
    
    func activeSignal(_ content: AnyObject?) {
        self.activeSignal()
    }
    
    func activeSignal() {
        if let head = _head {
            head(self, { [weak self] in
                self?._reactChain(0)
            })
        } else {
            _reactChain(0)
        }
    }
    
    
    //MARK:- private
    
    //private var _content: QXContent?
    fileprivate var _head: QXSignalAsycNext?
    fileprivate lazy var _nexts = [QXSignalAsycNext]()
    
    fileprivate func _reactChain(_ idx: Int) {
        if _nexts.count == 0 { return }
        if idx == _nexts.count - 1 {
            _nexts[idx](self, {
                // do nothing
            })
        } else {
            _nexts[idx](self, { [weak self] in
                self?._reactChain(idx + 1)
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
