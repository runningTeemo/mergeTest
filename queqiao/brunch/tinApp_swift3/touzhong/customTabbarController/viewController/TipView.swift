//
//  TipView.swift
//  Demo
//
//  Created by Richard.q.x on 2016/12/28.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class TipView: UIView {
    
    static let oneForIndex = TipView()
    
    var inView: UIView? {
        didSet {
            if let view = inView {
                view.addSubview(self)
                self._tmpFrame = view.frame
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            super.frame = frame
            self._tmpFrame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height)
        }
    }
    
    func showMsg(_ msg: String) {
        if inView == nil { return }
        if !_timerStarted {
            _timerStarted = true
            _startTimer()
        }
        _counter = 100
        _msgLabel.text = msg
    }
    
    
    //MARK: private
    
    private var _timerStarted: Bool = false
    private var _counter: Int = 100
    private func _handleLoop() {
        _counter -= 1
        if _counter > 0 {
            if _counter < 20 {
                _performHideView()
            } else if _counter >= 80 {
                _performShow()
            }
        } else {
            self.isHidden = true
            _endTimer()
        }
    }
    private var _timer: QXTimer?
    private func _startTimer() {
        _timer = QXTimer(triggerCount: nil, runLoop: .main, mode: .commons)
        _timer?.loop = { [weak self] t in
            self?._handleLoop()
        }
    }
    private func _endTimer() {
        _timerStarted = false
        _timer?.remove()
    }
    
    
    private var _tmpFrame: CGRect = CGRect.zero {
        didSet {
            _bgView.frame = _tmpFrame
            _msgLabel.frame = _bgView.bounds
        }
    }
    private func _performShow() {
        self.isHidden = false
        var y = self._tmpFrame.minY
        if y > 0 {
            y -= 1
        } else {
            return
        }
        self._tmpFrame = CGRect(x: 0, y: y, width: self.bounds.width, height: self.bounds.height)
    }
    private func _performHideView() {
        var y = self._tmpFrame.minY
        if y < self._tmpFrame.height {
            y += 1
        } else {
            self.isHidden = true
            return
        }
        self._tmpFrame = CGRect(x: 0, y: y, width: self.bounds.width, height: self.bounds.height)
    }
    
    private lazy var _bgView: UIView = {
        let one = UIView()
        one.clipsToBounds = true
        one.backgroundColor = kClrBlue
        return one
    }()
    private lazy var _msgLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 13)
        one.textColor = UIColor.white
        one.textAlignment = .center
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(_bgView)
        _bgView.addSubview(_msgLabel)
        self.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
