//
//  QXTimer.swift
//  Block
//
//  Created by Richard.q.x on 16/6/27.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//


/// 解决 NSTimer 无法销毁的问题

import UIKit

enum QXTimerType {
    case timer
    case displayLink
}

enum QXTimerLinkMode {
    case `default`
    case commons
}

class QXTimer: NSObject {
    
    var loop: ((_ timer: QXTimer) -> ())?
    func remove() {
        switch _type {
        case .timer:
            _timer?.invalidate()
            _timer = nil
        case .displayLink:
            if let runLoop = _displayRunLoop {
                if let model = _displayLinkMode {
                    _displayLink?.remove(from: runLoop, forMode: RunLoopMode(rawValue: model))
                }
            }
            _displayLink = nil
        }
    }
    
    init(duration: TimeInterval) {
        super.init()
        self._type = .timer
        self._timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(QXTimer._loop), userInfo: nil, repeats: true)
    }
    
    init(triggerCount: CGFloat? = nil, runLoop: RunLoop = RunLoop.main, mode: QXTimerLinkMode) {
        super.init()
        self._type = .displayLink
        self._displayLink = CADisplayLink(target: self, selector: #selector(QXTimer._loop))
        self._displayTriggerCount = triggerCount
        switch mode {
        case .default:
            self._displayLinkMode = RunLoopMode.defaultRunLoopMode.rawValue
        case .commons:
            self._displayLinkMode = RunLoopMode.commonModes.rawValue
        }
        self._displayRunLoop = RunLoop.main
        self._displayLink?.add(to: self._displayRunLoop!, forMode: RunLoopMode(rawValue: self._displayLinkMode!))
    }
    
    fileprivate var _type: QXTimerType = .timer
    fileprivate var _timer: Timer?
    fileprivate var _displayLink: CADisplayLink?
    fileprivate var _displayTriggerCount: CGFloat?
    fileprivate var _displayCounter: CGFloat = 0
    fileprivate var _displayLinkMode: String?
    fileprivate var _displayRunLoop: RunLoop?
    
    func _loop() {
        switch _type {
        case .timer:
            loop?(self)
        case .displayLink:
            if let triggerCount  = _displayTriggerCount {
                _displayCounter += 1
                if _displayCounter == triggerCount {
                    loop?(self)
                    _displayCounter = 0
                }
            } else {
                loop?(self)
            }
        }
    }
    
    deinit {
        print("timer deinit")
    }
    
}
