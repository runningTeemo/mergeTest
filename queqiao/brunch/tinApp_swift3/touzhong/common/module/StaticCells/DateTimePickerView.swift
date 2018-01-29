//
//  DateTimePickerView.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/27.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class DateTimePickerView: UIView {
    
    var responder: ((_ date: Date?) -> ())?
    
    var type: UIDatePickerMode = .date {
        didSet {
            picker.datePickerMode = type
        }
    }
    
    lazy var picker: UIDatePicker = {
        let one = UIDatePicker()
        one.datePickerMode = self.type
        one.signal_event_valueChanged.head({ [unowned self] (signal) in
            self.responder?(self.picker.date)
            })
        return one
    }()
    
    lazy var cancelBtn: TitleButton = {
        let one = TitleButton()
        one.title = "取消"
        one.norTitlefont = UIFont.systemFont(ofSize: 18)
        one.dowTitlefont = UIFont.systemFont(ofSize: 18)
        one.norTitleColor = RGBA(132, 140, 147, 255)
        one.dowTitleColor = kClrSlightGray
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.responder?(nil)
            UIApplication.shared.keyWindow?.endEditing(true)
        })
        return one
    }()
    lazy var doneBtn: TitleButton = {
        let one = TitleButton()
        one.title = "完成"
        one.norTitlefont = UIFont.systemFont(ofSize: 18)
        one.dowTitlefont = UIFont.systemFont(ofSize: 18)
        one.norTitleColor = RGBA(132, 140, 147, 255)
        one.dowTitleColor = kClrSlightGray
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.responder?(self.picker.date)
            UIApplication.shared.keyWindow?.endEditing(true)
            })
        return one
    }()
    
    lazy var toolView: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#ffffff")
        return one
    }()
    
    lazy var toolViewLineA: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBreak
        return one
    }()
    lazy var toolViewLineB: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBreak
        return one
    }()
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 220))
        backgroundColor = HEX("#f9f9f9")
        addSubview(picker)
        addSubview(toolView)
        addSubview(cancelBtn)
        addSubview(doneBtn)
        addSubview(toolViewLineA)
        addSubview(toolViewLineB)
        picker.IN(self).LEFT.TOP(40).BOTTOM.RIGHT.MAKE()
        toolView.IN(self).LEFT.RIGHT.TOP.HEIGHT(40).MAKE()
        doneBtn.IN(self).RIGHT.TOP.WIDTH(60).HEIGHT(40).MAKE()
        cancelBtn.IN(self).RIGHT(60).TOP.WIDTH(60).HEIGHT(40).MAKE()
        toolViewLineA.IN(toolView).LEFT.RIGHT.TOP.HEIGHT(0.5).MAKE()
        toolViewLineB.IN(toolView).BOTTOM.LEFT.RIGHT.HEIGHT(0.5).MAKE()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
