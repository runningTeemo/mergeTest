//
//  QXSignal_UIControl.swift
//  QXSignal
//
//  Created by Richard.q.x on 16/5/10.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

extension UIControl {
    
    var signal_event_touchDown: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchDown(_:)), UIControlEvents.touchDown)
    }
    var signal_event_touchDownRepeat: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchDownRepeat(_:)), UIControlEvents.touchDownRepeat)
    }
    var signal_event_touchDragInside: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchDragInside(_:)), UIControlEvents.touchDragInside)
    }
    var signal_event_touchDragOutside: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchDragOutside(_:)), UIControlEvents.touchDragOutside)
    }
    var signal_event_touchDragEnter: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchDragEnter(_:)), UIControlEvents.touchDragEnter)
    }
    var signal_event_touchDragExit: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchDragExit(_:)), UIControlEvents.touchDragExit)
    }
    var signal_event_touchUpInside: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchUpInside(_:)), UIControlEvents.touchUpInside)
    }
    var signal_event_touchUpOutside: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchUpOutside(_:)), UIControlEvents.touchUpOutside)
    }
    var signal_event_touchCancel: QXSignal {
        return _makeSignal(#selector(QXSignal.event_touchCancel(_:)), UIControlEvents.touchCancel)
    }
    
    var signal_event_valueChanged: QXSignal {
        return _makeSignal(#selector(QXSignal.event_valueChanged(_:)), UIControlEvents.valueChanged)
    }
    
//    var signal_event_primaryActionTriggered: QXSignal {
//        return _makeSignal(#selector(QXSignal.event_primaryActionTriggered(_:)), UIControlEvents.PrimaryActionTriggered)
//    }
    
    var signal_event_editingDidBegin: QXSignal {
        return _makeSignal(#selector(QXSignal.event_editingDidBegin(_:)), UIControlEvents.editingDidBegin)
    }
    var signal_event_editingDidEnd: QXSignal {
        return _makeSignal(#selector(QXSignal.event_editingDidEnd(_:)), UIControlEvents.editingDidEnd)
    }
    var signal_event_editingDidEndOnExit: QXSignal {
        return _makeSignal(#selector(QXSignal.event_editingDidEndOnExit(_:)), UIControlEvents.editingDidEndOnExit)
    }
    var signal_event_editingChanged: QXSignal {
        return _makeSignal(#selector(QXSignal.event_editingChanged(_:)), UIControlEvents.editingChanged)
    }
    
    var signal_event_allTouchEvents: QXSignal {
        return _makeSignal(#selector(QXSignal.event_allTouchEvents(_:)), UIControlEvents.allTouchEvents)
    }
    var signal_event_allEditingEvents: QXSignal {
        return _makeSignal(#selector(QXSignal.event_allEditingEvents(_:)), UIControlEvents.allEditingEvents)
    }
    var signal_event_allEvents: QXSignal {
        return _makeSignal(#selector(QXSignal.event_allEvents(_:)), UIControlEvents.allEvents)
    }
    
    var signal_event_applicationReserved: QXSignal {
        return _makeSignal(#selector(QXSignal.event_applicationReserved(_:)), UIControlEvents.applicationReserved)
    }
    var signal_event_systemReserved: QXSignal {
        return _makeSignal(#selector(QXSignal.event_systemReserved(_:)), UIControlEvents.systemReserved)
    }
    
    fileprivate func _makeSignal(_ sel: Selector, _ event: UIControlEvents) -> QXSignal {
        for s in self.SIGNALS {
            let sig = s as! QXSignal
            let eve = UIControlEvents(rawValue: sig.subType as! UInt)
            if eve.rawValue == event.rawValue {
                return sig
            }
        }
        let signal = QXSignal(content: self, type: .uiControl, subType: event.rawValue)
        self.addTarget(signal, action: sel, for: event)
        self.SIGNALS.add(signal)
        return signal
    }
    
}

extension QXSignal {
    
    func event_touchDown(_ sender: UIControl)                 { activeSignal(sender) }
    func event_touchDownRepeat(_ sender: UIControl)           { activeSignal(sender) }
    func event_touchDragInside(_ sender: UIControl)           { activeSignal(sender) }
    func event_touchDragOutside(_ sender: UIControl)          { activeSignal(sender) }
    func event_touchDragEnter(_ sender: UIControl)            { activeSignal(sender) }
    func event_touchDragExit(_ sender: UIControl)             { activeSignal(sender) }
    func event_touchUpInside(_ sender: UIControl)             { activeSignal(sender) }
    func event_touchUpOutside(_ sender: UIControl)            { activeSignal(sender) }
    func event_touchCancel(_ sender: UIControl)               { activeSignal(sender) }
    
    func event_valueChanged(_ sender: UIControl)              { activeSignal(sender) }
    
    func event_primaryActionTriggered(_ sender: UIControl)    { activeSignal(sender) }
    
    func event_editingDidBegin(_ sender: UIControl)           { activeSignal(sender) }
    func event_editingDidEnd(_ sender: UIControl)             { activeSignal(sender) }
    func event_editingDidEndOnExit(_ sender: UIControl)       { activeSignal(sender) }
    func event_editingChanged(_ sender: UIControl)            { activeSignal(sender) }
    
    func event_allTouchEvents(_ sender: UIControl)            { activeSignal(sender) }
    func event_allEditingEvents(_ sender: UIControl)          { activeSignal(sender) }
    func event_allEvents(_ sender: UIControl)                 { activeSignal(sender) }
    
    func event_applicationReserved(_ sender: UIControl)       { activeSignal(sender) }
    func event_systemReserved(_ sender: UIControl)            { activeSignal(sender) }
    
}

private var kUIControlSignalsAssociateKey:UInt = 1202328502
extension UIControl {
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
