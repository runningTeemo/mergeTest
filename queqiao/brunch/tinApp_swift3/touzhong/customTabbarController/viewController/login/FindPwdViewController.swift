//
//  FindPwdViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class FindPwdViewController: RootViewController, UIScrollViewDelegate {
    
    weak var loginVc: LoginViewController?
    weak var comeFromVc: UIViewController?

    lazy var scrollView: UIScrollView = {
        let one = UIScrollView()
        one.showsVerticalScrollIndicator = false
        one.backgroundColor = UIColor.white
        one.delegate = self
        one.alwaysBounceVertical = true
        return one
    }()
    
    lazy var imageView: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "loginTopImg")
        return one
    }()
    
    lazy var segmentView: SegmentDotControl = {
        let one = SegmentDotControl(titles: "找回密码", "")
        one.isUserInteractionEnabled = false
        return one
    }()
    
    lazy var findPwdView: FindPwdView = {
        let one = FindPwdView()
        return one
    }()
    
    var inputTopY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBackWhiteButton(nil)
        
        view.addSubview(scrollView)
        scrollView.IN(view).LEFT.RIGHT.TOP(-64).BOTTOM.MAKE()
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(segmentView)
        
        scrollView.addSubview(findPwdView)
        
        let imgH = kScreenW * 362 / 750
        
        var topMargin: CGFloat = 0
        imageView.IN(scrollView).LEFT.TOP.SIZE(kScreenW, imgH).MAKE()
        topMargin += imgH
        segmentView.IN(scrollView).LEFT.TOP(topMargin).SIZE(kScreenW, 53).MAKE()
        topMargin += 53
        topMargin += 31
        
        findPwdView.IN(scrollView).LEFT(15).WIDTH(kScreenW - 15 * 2).TOP(topMargin).HEIGHT(findPwdView.viewHeight).MAKE()
        
        topMargin += findPwdView.viewHeight
        
        if kScreen320x480 {
            scrollView.contentSize = CGSize(width: 0, height: topMargin + 40 + 11 + 21)
        } else {
            scrollView.contentSize = CGSize(width: 0, height: kScreenH)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(FindPwdViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FindPwdViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        inputTopY = imgH - 64 - 64
        
        setupFindPwdBussiness()
        
        setupCustomNav()
        customNavView.changeAlpha(0)
        customNavView.setupBackButton()
        customNavView.backBlackBtn.isHidden = true
        customNavView.respondBack = { [unowned self] in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
    }
    
    /// 输入是否合法
    var isAccountInLegal: Bool = false
    var isVerifyInLegal: Bool = false
    
    func setupFindPwdBussiness() {
        
        findPwdView.findBtn.forceDisable(true)
        findPwdView.verifyBtn.forceDisable(true)
        
        // 账户内容变化
        let accountChange = findPwdView.acountInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 11
            if let text = self.findPwdView.acountInput.textField.text {
                if text.characters.count > charLimit {
                    self.findPwdView.acountInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
                self.isAccountInLegal = false
                if let text = self.findPwdView.acountInput.textField.text {
                    for char in text.characters {
                        if !"1234567890".characters.contains(char) {
                            self.isAccountInLegal = true
                        }
                    }
                    if text.characters.count > 0 {
                        let first = text.substring(to: text.characters.index(text.startIndex, offsetBy: 1))
                        if first != "1" {
                            self.isAccountInLegal = true
                        }
                    }
                }
                if self.isAccountInLegal {
                    self.findPwdView.acountInput.setAlertStyle()
                } else {
                    self.findPwdView.acountInput.setNormalStyle()
                }
            }
        }
        
        // 密码内容变化
        let pwdChange = findPwdView.passwordInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 99
            if let text = self.findPwdView.passwordInput.textField.text {
                if text.characters.count > charLimit {
                    self.findPwdView.passwordInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
            }
        }
        
        // 验证码样式变化
        let verifyChange = findPwdView.verifyInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 6
            if let text = self.findPwdView.verifyInput.textField.text {
                if text.characters.count > charLimit {
                    self.findPwdView.verifyInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
                self.isVerifyInLegal = false
                if let text = self.findPwdView.verifyInput.textField.text {
                    for char in text.characters {
                        if !"1234567890".characters.contains(char) {
                            self.isVerifyInLegal = true
                        }
                    }
                }
                if self.isVerifyInLegal {
                    self.findPwdView.verifyInput.setAlertStyle()
                } else {
                    self.findPwdView.verifyInput.setNormalStyle()
                }
            }
        }
        
        // 根据文本内容确定登录按钮是否能点击
        QXSignal.combine(accountChange, pwdChange, verifyChange).head { [unowned self] (signal) in
            // 账户名合法后，申请验证码可点击
            if self.findPwdView.acountInput.textField.text?.characters.count == 11 &&
                self.isVerifyInLegal == false {
                if !self.findPwdView.verifyBtn.isCounting {
                    self.findPwdView.verifyBtn.forceDisable(false)
                }
            } else {
                self.findPwdView.verifyBtn.forceDisable(true)
            }
            // 账户名、验证码、密码合法后，注册按钮可点击
            if self.findPwdView.acountInput.textField.text?.characters.count == 11 &&
                self.findPwdView.passwordInput.textField.text?.characters.count >= 6 &&
                self.findPwdView.verifyInput.textField.text?.characters.count == 6 &&
                self.isVerifyInLegal == false &&
                self.isAccountInLegal == false {
                self.findPwdView.findBtn.forceDisable(false)
            } else {
                self.findPwdView.findBtn.forceDisable(true)
            }
        }
        
        // 点击获取验证码
        findPwdView.verifyBtn.signal_event_touchUpInside.head { [unowned self] (signal) in
            let name = self.findPwdView.acountInput.textField.text!
            self.findPwdView.verifyBtn.forceDisable(true)
            LoginManager.shareInstance.getCaptcha(name, success: { [weak self] (code, msg, data) in
                if code == 0 {
                    self?.findPwdView.verifyBtn.fire()
                } else {
                    self?.findPwdView.verifyBtn.forceDisable(false)
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
            }) { [weak self] (error) in
                self?.findPwdView.verifyBtn.forceDisable(false)
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
        }
        
        // 点击找回
        findPwdView.findBtn.signal_event_touchUpInside.head { [unowned self] (signal) in
            
            let name = self.findPwdView.acountInput.textField.text!
            let pwd = self.findPwdView.passwordInput.textField.text!
            let verify = self.findPwdView.verifyInput.textField.text!
            
            for view in self.scrollView.subviews {
                view.isUserInteractionEnabled = false
            }
            let ennableTheView = { [unowned self] in
                for view in self.scrollView.subviews {
                    view.isUserInteractionEnabled = true
                }
                self.findPwdView.findBtn.stopLoading()
            }
            
            self.view.endEditing(true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                
                LoginManager.shareInstance.checkCaptcha(name, userName: name, captcha: verify, success: { [weak self] (code, msg, data) in
                    
                    if code == 0 {
                        
                        LoginManager.shareInstance.retrievePassword(name, password: pwd, success: { [weak self] (code, msg, data) in
                            ennableTheView()
                            if code == 0 {
                                self?.autoLogin(name, pwd: pwd, verify: verify)
                            } else {
                                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                            }
                            }, failed: { (error) in
                                ennableTheView()
                                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        })
                        
                    } else {
                        ennableTheView()
                        QXTiper.showWarning(msg, inView: self?.view, cover: true)
                    }
                    }, failed: { [weak self] (error) in
                        ennableTheView()
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                })
            }
        }

    }
    
    /// 自动登录
    func autoLogin(_ name: String, pwd: String, verify: String) {
        let wait = QXTiper.showWaiting("自动登录中...", inView: self.view, cover: true)

        LoginManager.shareInstance.login(name, password: pwd, success: { [weak self] (code, msg, data) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                if let dic = data as? [String: Any] {
                    Account.sharedOne.setContent(dic)
                    Account.sharedOne.saveToLocal()
                    // 记住账号
                    UserDefaults.standard.set(name, forKey: kUserDefaultUserName)
                    UserDefaults.standard.set(pwd, forKey: kUserDefaultUserPwd)
                    SendLoginNotification()
                    
                    if let vc = self?.comeFromVc {
                        _ = self?.navigationController?.popToViewController(vc, animated: true)
                    } else {
                        _ = self?.navigationController?.popToRootViewController(animated: true)
                    }
                    LoginManager.shareInstance.sendLoginLogInBackground()
                } else {
                    //assert(true, "格式错误")
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    if let s = self {
                        if code == -7 { // 用户不存在
                            s.loginVc?.loginView.acountInput.textField.text = nil
                            s.loginVc?.loginView.passwordInput.textField.text = nil
                            s.loginVc?.registView.acountInput.textField.text = name
                            s.loginVc?.registView.passwordInput.textField.text = pwd
                            s.loginVc?.registView.verifyInput.textField.text = verify
                            s.loginVc?.registView.verifyBtn.forceDisable(false)
                            s.loginVc?.registView.registBtn.forceDisable(false)
                            s.loginVc?.showRegist()
                            s.loginVc?.segmentView.selectIdx = 1
                            _ = s.navigationController?.popToViewController(s.loginVc!, animated: true)
                        } else {
                            s.loginVc?.segmentView.selectIdx = 0
                            s.loginVc?.showLogin()
                            s.loginVc?.loginView.acountInput.textField.text = name
                            s.loginVc?.loginView.passwordInput.textField.text = pwd
                            s.loginVc?.loginView.loginBtn.forceDisable(false)
                            _ = s.navigationController?.popToViewController(s.loginVc!, animated: true)
                        }
                    }
                }
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                if let s = self {
                    s.loginVc?.segmentView.selectIdx = 0
                    s.loginVc?.showLogin()
                    s.loginVc?.loginView.acountInput.textField.text = name
                    s.loginVc?.loginView.passwordInput.textField.text = pwd
                    _ = s.navigationController?.popToViewController(s.loginVc!, animated: true)
                    s.loginVc?.loginView.loginBtn.forceDisable(false)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: UIScrollViewDelegate
    var isKeyboardShow: Bool = false
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    func keyboardWillShow(_ notice: Notification) {
        scrollView.contentOffset = CGPoint(x: 0, y: inputTopY)
        isKeyboardShow = true
    }
    func keyboardWillHide(_ notice: Notification) {
        scrollView.contentOffset = CGPoint.zero
        isKeyboardShow = false
    }
    deinit {
        print("loginVc deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
}

