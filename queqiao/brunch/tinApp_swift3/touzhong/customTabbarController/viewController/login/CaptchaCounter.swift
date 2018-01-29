//
//  CaptchaCounter.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

/// 用于验证码倒计时的单例，保证全局计时
class CaptchaCounter {
    
    static let shareOne = CaptchaCounter()
    static let shareOneForFind = CaptchaCounter()
    
    var respondBegin: (() -> ())?
    var respondUpdate: ((_ currentSec: Int) -> ())?
    var respondDone: (() -> ())?

    /// 当前计数（秒）
    var currentSec: Int = 0
    /// 是否在计数
    var isCounting: Bool = false
    /// 倒计时长
    let maxCount: Int = 90
    
    fileprivate var timer: QXTimer?
    
    func fire() {
        if isCounting { return }
        isCounting = true
        respondBegin?()
        timer = QXTimer(duration: 1)
        self.currentSec = maxCount
        timer?.loop = { [unowned self] timer in
            self.currentSec -= 1
            self.respondUpdate?(self.currentSec)
            if self.currentSec == 0 {
                self.respondDone?()
                self.cancel()
            }
        }
    }
    func cancel() {
        timer?.remove()
        isCounting = false
        currentSec = 0
    }
    
}
