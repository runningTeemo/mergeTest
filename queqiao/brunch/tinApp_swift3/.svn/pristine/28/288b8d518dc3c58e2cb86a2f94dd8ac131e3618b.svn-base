//
//  LoginView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    var viewHeight: CGFloat { return kSizBtnHeight + 12.5 + kSizBtnHeight + 32 + kSizBtnHeight + 32 + 20 }
    
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

    lazy var loginBtn: LoadingButton = {
        let one = LoadingButton()
        one.title = "登  录"
        return one
    }()
    
    lazy var forgetPwdBtn: TitleButton = {
        let one = TitleButton()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = UIColor.gray
        one.dowTitleColor = UIColor.gray
        one.norTitlefont = UIFont.systemFont(ofSize: 13)
        one.dowTitlefont = UIFont.systemFont(ofSize: 13)
        one.title = "忘记密码？"
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(acountInput)
        addSubview(passwordInput)
        addSubview(loginBtn)
        addSubview(forgetPwdBtn)
                
       _ = acountInput.IN(self).LEFT.RIGHT.TOP.HEIGHT(kSizBtnHeight).MAKE()
       _ = passwordInput.BOTTOM(acountInput).OFFSET(12.5).LEFT.RIGHT.HEIGHT(kSizBtnHeight).MAKE()
       _ = loginBtn.BOTTOM(passwordInput).OFFSET(32).LEFT.RIGHT.HEIGHT(kSizBtnHeight).MAKE()
       _ = forgetPwdBtn.BOTTOM(loginBtn).OFFSET(32).RIGHT.MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
