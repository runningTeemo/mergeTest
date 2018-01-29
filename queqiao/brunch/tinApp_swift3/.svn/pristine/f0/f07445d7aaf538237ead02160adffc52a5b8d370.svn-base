//
//  QXSignal_NSNotification.swift
//  QXSignal
//
//  Created by Richard.q.x on 16/5/10.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

extension NotificationCenter {

    func qxSignal_notice(_ name: String) -> QXSignal {
        return qxSignal_notice(name, obj: nil)
    }
    
    func qxSignal_notice(_ name: String, obj: AnyObject?) -> QXSignal {
        for s in self.SIGNALS {
            let sig = s as! QXSignal
            let n = sig.subType! as! String
            if n == name {
                return sig
            }
        }
        let signal = QXSignal(content: self, type: .nsNotification, subType: name)
        self.addObserver(self, selector:
            #selector(QXSignal.notice_forNotification(_:)), name: NSNotification.Name(rawValue: name), object: obj)
        self.SIGNALS.add(signal)
        return signal;
    }
    
}

extension QXSignal {
    func notice_forNotification(_ notification: Notification) {
        activeSignal((notification as NSNotification).userInfo as AnyObject?)
    }
}

private var kUIControlSignalsAssociateKey:UInt = 1202328503
extension NotificationCenter {
    var SIGNALS:NSMutableArray {
        get {
            var obj = objc_getAssociatedObject(self, &kUIControlSignalsAssociateKey)
            if obj == nil {
                obj = NSMutableArray()
                objc_setAssociatedObject(self, &kUIControlSignalsAssociateKey, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return obj as! NSMutableArray
        }
    }
}
