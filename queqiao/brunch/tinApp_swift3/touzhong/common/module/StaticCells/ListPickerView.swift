//
//  ListPickerView.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/31.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class ListPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var responder: ((_ key: String?) -> ())?
    var keys: [String] = [String]() {
        didSet {
            currentKey = keys.first
        }
    }
    
    var asycLoad: Bool = false
    var asyLoadKeys: ((_ done: ((_ keys: [String]?, _ err: Bool) -> ())) -> ())? {
        didSet {
            ascyLoadKeys()
        }
    }
    
    func ascyLoadKeys() {
        showLoading()
        asyLoadKeys? { keys, err in
            if err {
                self.showFailed()
            } else {
                if let keys = keys {
                    self.keys = keys
                    self.showSuccess()
                }
            }
        }
    }
    
    lazy var picker: UIPickerView = {
        let one = UIPickerView()
        one.dataSource = self
        one.delegate = self
        return one
    }()
    lazy var indicator: UIActivityIndicatorView = {
        let one = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        one.hidesWhenStopped = true
        return one
    }()
    lazy var failIcon: UIImageView = {
        let one =  UIImageView()
        one.image = UIImage(named: "keyboard_icon_fail")
        return one
    }()
    lazy var failLabel: UILabel = {
        let one = UILabel()
        one.text = "加载失败，"
        one.font = UIFont.systemFont(ofSize: 15)
        return one
    }()
    lazy var failBtn: UIButton = {
        let one = UIButton()
        let name = "点击重试"
        let attri = NSAttributedString(string: name, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName: HEX("#2692d8")
            ])
        one.setAttributedTitle(attri, for: UIControlState())
        one.addTarget(self, action: #selector(ListPickerView.failClick), for: .touchUpInside)
        return one
    }()
    lazy var failBg: UIView = {
        let one = UIView()
        one.isHidden = true
        return one
    }()
    func failClick() {
        ascyLoadKeys()
    }
    
    func showLoading() {
        indicator.startAnimating()
        picker.isHidden = true
        failBg.isHidden = true
    }
    func showFailed() {
        indicator.stopAnimating()
        picker.isHidden = true
        failBg.isHidden = false
    }
    func showSuccess() {
        indicator.stopAnimating()
        picker.isHidden = false
        failBg.isHidden = true
        picker.reloadAllComponents()
    }
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
            self.responder?(self.currentKey)
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
        
        addSubview(failBg)
        failBg.addSubview(failIcon)
        failBg.addSubview(failLabel)
        failBg.addSubview(failBtn)
        addSubview(indicator)

        picker.IN(self).LEFT.TOP.BOTTOM.RIGHT.MAKE()
        toolView.IN(self).LEFT.RIGHT.TOP.HEIGHT(40).MAKE()
        doneBtn.IN(self).RIGHT.TOP.WIDTH(60).HEIGHT(40).MAKE()
        cancelBtn.IN(self).RIGHT(60).TOP.WIDTH(60).HEIGHT(40).MAKE()
        
        failBg.IN(self).HEIGHT(100).CENTER.MAKE()
        failIcon.IN(failBg).LEFT.SIZE(13, 13).CENTER.MAKE()
        failLabel.RIGHT(failIcon).OFFSET(5).CENTER.MAKE()
        failBtn.RIGHT(failLabel).OFFSET(3).CENTER.MAKE()
        failBtn.RIGHT.EQUAL(failBg).MAKE()
        
        toolViewLineA.IN(toolView).LEFT.RIGHT.TOP.HEIGHT(0.5).MAKE()
        toolViewLineB.IN(toolView).BOTTOM.LEFT.RIGHT.HEIGHT(0.5).MAKE()
        
        indicator.IN(self).CENTER.MAKE()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UIPickerViewDelegate, UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return keys.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return keys[row]
    }
    
    private var currentKey: String?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        responder?(keys[row])
        currentKey = keys[row]
    }
    
}
