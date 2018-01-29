//
//  RegistView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RegistView: UIView {
    
    var viewHeight: CGFloat { return kSizBtnHeight + 12.5 + kSizBtnHeight + 12.5 + kSizBtnHeight + 32 + kSizBtnHeight }
    
    lazy var acountInput: IconTextInput = {
        let one = IconTextInput(showRightIcon: false)
        one.leftIconView.image = UIImage(named: "loginTell")
        one.textField.placeholder = "手机号码"
        one.textField.keyboardType = .phonePad
        one.textField.inputAccessoryView = NewKeyboardLine
        return one
    }()
    
    lazy var passwordInput: IconTextInput = {
        let one = IconTextInput(showRightIcon: true)
        one.leftIconView.image = UIImage(named: "loginPassword")
        one.textField.placeholder = "密码"
        one.textField.isSecureTextEntry = true
        one.rightIconView.iconView.image = UIImage(named: "loginPasswordEye")
        one.rightIconCLick = { [unowned one] icon in
            one.textField.isSecureTextEntry = !one.textField.isSecureTextEntry
            let text = one.textField.text
            one.textField.text = nil
            one.textField.text = text
            one.textField.font = UIFont.systemFont(ofSize: 14)
            if one.textField.isSecureTextEntry {
                one.rightIconView.iconView.image = UIImage(named: "loginPasswordEye")
            } else {
                one.rightIconView.iconView.image = UIImage(named: "loginPasswordEyeSelect")
            }
        }
        return one
    }()
    
    lazy var verifyInput: IconTextInput = {
        let one = IconTextInput(showRightIcon: false)
        one.leftIconView.image = UIImage(named: "loginCheck")
        one.textField.placeholder = "验证码"
        one.textField.keyboardType = .numberPad
        one.textField.inputAccessoryView = NewKeyboardLine
        //one.isUserInteractionEnabled = false
        return one
    }()
    
    lazy var verifyBtn: CountButton = {
        let one = CountButton()
        one.title = "获取验证码"
//        CaptchaCounter.shareOne.respondUpdate = { [weak one] sec in
//            one?.title = "\(sec) 秒"
//        }
//        CaptchaCounter.shareOne.respondBegin = {  [weak self, weak one] in
//            self?.acountInput.isUserInteractionEnabled = false
//            //self?.verifyInput.isUserInteractionEnabled = true
//        }
//        CaptchaCounter.shareOne.respondDone = { [weak self, weak one] in
//            one?.title = "获取验证码"
//            one?.forceDisable(false)
//            self?.acountInput.isUserInteractionEnabled = true
//            //self?.verifyInput.isUserInteractionEnabled = false
//        }
//        
//        if CaptchaCounter.shareOne.isCounting {
//            one.title = "\(CaptchaCounter.shareOne.currentSec) 秒"
//            one.forceDisable(true)
//        }
        return one
    }()
    /// 验证码的按钮， 这里包在view里是为了剪切按钮上的半边圆角
    lazy var verifyBtnView: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor.white
        one.clipsToBounds = true
        one.addSubview(self.verifyBtn)
        self.verifyBtn.IN(one).LEFT(-5).TOP.BOTTOM.RIGHT.MAKE()
        return one
    }()
    
    lazy var registBtn: LoadingButton = {
        let one = LoadingButton()
        one.title = "注  册"
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(acountInput)
        addSubview(passwordInput)
        addSubview(verifyInput)
        addSubview(verifyBtnView)
        addSubview(registBtn)
        
        acountInput.IN(self).LEFT.TOP.RIGHT.HEIGHT(kSizBtnHeight).MAKE()
        passwordInput.BOTTOM(acountInput).OFFSET(12.5).LEFT.RIGHT.HEIGHT(kSizBtnHeight).MAKE()
        verifyInput.BOTTOM(passwordInput).OFFSET(12.5).LEFT.HEIGHT(kSizBtnHeight).MAKE()
        verifyBtnView.BOTTOM(passwordInput).OFFSET(12.5).RIGHT.HEIGHT(kSizBtnHeight).WIDTH(100).MAKE()
        verifyInput.RIGHT.EQUAL(verifyBtnView).LEFT.OFFSET(5).MAKE()
        registBtn.BOTTOM(verifyInput).OFFSET(32).LEFT.HEIGHT(kSizBtnHeight).MAKE()
        registBtn.RIGHT.EQUAL(self).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
