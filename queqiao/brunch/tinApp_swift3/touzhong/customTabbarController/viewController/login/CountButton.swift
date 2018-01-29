//
//  CountButton.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/22.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class CountButton: TitleButton {
    
    /// 当前计数（秒）
    private var currentSec: Int = 0
    /// 是否在计数
    private(set) var isCounting: Bool = false
    /// 倒计时长
    let maxCount: Int = 90
    
    private var timer: QXTimer?
    
    func reset() {
        self.cancel()
        self.title = self.title
        self.forceDisable(false)
    }
    
    private var tmpTitle: String?
    func fire() {
        if isCounting { return }
        isCounting = true
        forceDisable(true)
        timer = QXTimer(duration: 1)
        self.currentSec = maxCount
        tmpTitle = self.title
        timer?.loop = { [weak self] timer in
            if let s = self {
                s.currentSec -= 1
                s.myTitleLabel.text = "\(s.currentSec) 秒"
                if s.currentSec == 0 {
                    s.reset()
                }
            }
        }
    }
    private func cancel() {
        timer?.remove()
        isCounting = false
        currentSec = 0
    }
    
    required init() {
        super.init()
        norTitlefont = UIFont.systemFont(ofSize: 14)
        dowTitlefont = UIFont.systemFont(ofSize: 14)
        norTitleColor = HEX("#ffffff")
        dowTitleColor = HEX("#ffffff")
        norBgColor = HEX("#71c6ed")
        dowBgColor = HEX("#b8e2f6")
        cornerRadius = 5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
