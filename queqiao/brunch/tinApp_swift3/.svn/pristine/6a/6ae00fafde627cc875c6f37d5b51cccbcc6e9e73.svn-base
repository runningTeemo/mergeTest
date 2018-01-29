//
//  LoginViewController1.swift
//  touzhong
//
//  Created by zerlinda on 16/8/24.
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



class LoginViewController: RootViewController, UIScrollViewDelegate {
    
    var responceAfterLogin:(()->())?//登录成功后回调界面代码
    var popVC:UIViewController?//登录成功后pop到的vc
    
    var showRegistOnAppear: Bool = false
    
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
        let one = SegmentDotControl(titles: "登录", "注册")
        one.respondSelect = { [unowned self] idx in
            idx == 0 ? self.showLogin() : self.showRegist()
        }
        return one
    }()
    
    lazy var loginView: LoginView = {
        let one = LoginView()
        one.forgetPwdBtn.signal_event_touchUpInside.head({ [unowned self] (signal) in
            let vc = FindPwdViewController()
            vc.comeFromVc = self.comeFromVc
            vc.loginVc = self
            self.navigationController?.pushViewController(vc, animated: true)
        })
        return one
    }()
    lazy var registView: RegistView = {
        let one = RegistView()
        return one
    }()
    
    lazy var bottomLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 12)
        one.textColor = UIColor.lightGray
        one.text = "Copyright © 2005-2017 ChinaVenture 投中网"
        return one
    }()
    
    func showLogin() {
        loginView.isHidden = false
        registView.isHidden = true
    }
    func showRegist() {
        loginView.isHidden = true
        registView.isHidden = false
    }
    
    var inputTopY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        _=scrollView.IN(view).LEFT.RIGHT.TOP(-20).BOTTOM.MAKE()
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(segmentView)
        
        scrollView.addSubview(loginView)
        scrollView.addSubview(registView)
        
        scrollView.addSubview(bottomLabel)

        let imgH = kScreenW * 362 / 750
        
        var topMargin: CGFloat = 0
        _=imageView.IN(scrollView).LEFT.TOP.SIZE(kScreenW, imgH).MAKE()
        topMargin += imgH
        _=segmentView.IN(scrollView).LEFT.TOP(topMargin).SIZE(kScreenW, 53).MAKE()
        topMargin += 53
        topMargin += 31
        
        _=loginView.IN(scrollView).LEFT(15).WIDTH(kScreenW - 15 * 2).TOP(topMargin).HEIGHT(loginView.viewHeight).MAKE()
        _=registView.IN(scrollView).LEFT(15).WIDTH(kScreenW - 15 * 2).TOP(topMargin).HEIGHT(registView.viewHeight).MAKE()

        topMargin += max(loginView.viewHeight, registView.viewHeight)
        
        if kScreen320x480 {
            _=bottomLabel.IN(scrollView).TOP(topMargin + 40 + 11 + 21).CENTER.MAKE()
            scrollView.contentSize = CGSize(width: 0, height: topMargin + 40 + 11 + 21)
        } else {
            _=bottomLabel.IN(scrollView).TOP(kScreenH - 21 - 11).CENTER.MAKE()
            scrollView.contentSize = CGSize(width: 0, height: kScreenH)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        inputTopY = imgH - 20 - 64
        showLogin()
        
        setupLoginBussiness()
        setupRegistBussiness()
        
        setupCustomNav()
        customNavView.changeAlpha(0)
        customNavView.setupBackButton()
        customNavView.backBlackBtn.isHidden = true
        customNavView.respondBack = { [unowned self] in
            _=self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if showRegistOnAppear {
            segmentView.selectIdx = 1
            showRegist()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
    }
    
    /// 输入是否合法
    var isLoginAccountInLegal: Bool = false
    var isRegistAccountInLegal: Bool = false
    var isVerifyInLegal: Bool = false
    
    func setupLoginBussiness() {
        
        loginView.loginBtn.forceDisable(true)
        
        // 账户内容变化
        let accountChange = loginView.acountInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 11
            if let text = self.loginView.acountInput.textField.text {
                if text.characters.count > charLimit {
                    self.loginView.acountInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
                self.isLoginAccountInLegal = false
                if let text = self.loginView.acountInput.textField.text {
                    for char in text.characters {
                        if !"1234567890".characters.contains(char) {
                            self.isLoginAccountInLegal = true
                        }
                    }
                    if text.characters.count > 0 {
                        let first = text.substring(to: text.characters.index(text.startIndex, offsetBy: 1))
                        if first != "1" {
                            self.isLoginAccountInLegal = true
                        }
                    }
                }
                if self.isLoginAccountInLegal {
                    self.loginView.acountInput.setAlertStyle()
                } else {
                    self.loginView.acountInput.setNormalStyle()
                }
            }
        }
        
        // 密码内容变化
        let pwdChange = loginView.passwordInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 99
            if let text = self.loginView.passwordInput.textField.text {
                if text.characters.count > charLimit {
                    self.loginView.passwordInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
            }
        }
        
        // 根据文本内容确定登录按钮是否能点击
        QXSignal.combine(accountChange, pwdChange).head { [unowned self] (signal) in
            // 账户名、密码合法后，登录按钮可点击
            if self.loginView.acountInput.textField.text?.characters.count == 11 &&
                self.loginView.passwordInput.textField.text?.characters.count >= 6 &&
                self.isLoginAccountInLegal == false {
                self.loginView.loginBtn.forceDisable(false)
            } else {
                self.loginView.loginBtn.forceDisable(true)
            }
        }
        
        // 点击登录按钮
        loginView.loginBtn.signal_event_touchUpInside.head { [unowned self] (signal) in
            
            let name = self.loginView.acountInput.textField.text!
            let pwd = self.loginView.passwordInput.textField.text!
            
            for view in self.scrollView.subviews {
                view.isUserInteractionEnabled = false
            }
            let ennableTheView = { [unowned self] in
                for view in self.scrollView.subviews {
                    view.isUserInteractionEnabled = true
                }
                self.loginView.loginBtn.stopLoading()
            }
            self.view.endEditing(true)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                
                LoginManager.shareInstance.login(name, password: pwd, success: { [weak self] (code, msg, data) in
                    ennableTheView()
                    if code == 0 {
                        if let dic = data as? [String: Any] {
                            Account.sharedOne.setContent(dic)
                            Account.sharedOne.saveToLocal()
                            self?.responceAfterLogin?()
                            DispatchQueue.global().async {
                                ChatManage.shareInstance.loginHuanxin()
                            }
                            SendLoginNotification()
                            LoginManager.shareInstance.sendLoginLogInBackground()
                            
                            // 记住账号
                            UserDefaults.standard.set(name, forKey: kUserDefaultUserName)
                            UserDefaults.standard.set(pwd, forKey: kUserDefaultUserPwd)
                            self?.view.endEditing(true)
                    
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                                if let vc = self?.comeFromVc {
                                    _ = self?.navigationController?.popToViewController(vc, animated: true)
                                } else {
                                    _ = self?.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        } else {
                            //assert(true, "格式错误")
                        }
                    } else {
                        QXTiper.showWarning(msg, inView: self?.view, cover: true)
                    }
                    }, failed: { [weak self] (err) in
                        ennableTheView()
                        QXTiper.showFailed(kWebErrMsg + "(\(err.code))", inView: self?.view, cover: true)
                })
                
            }
        }

    }
    
    func setupRegistBussiness() {

        registView.registBtn.forceDisable(true)
        registView.verifyBtn.forceDisable(true)

        // 账户内容变化
        let accountChange = registView.acountInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 11
            if let text = self.registView.acountInput.textField.text {
                if text.characters.count > charLimit {
                    self.registView.acountInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
                self.isRegistAccountInLegal = false
                if let text = self.registView.acountInput.textField.text {
                    for char in text.characters {
                        if !"1234567890".characters.contains(char) {
                            self.isRegistAccountInLegal = true
                        }
                    }
                    if text.characters.count > 0 {
                        let first = text.substring(to: text.characters.index(text.startIndex, offsetBy: 1))
                        if first != "1" {
                            self.isRegistAccountInLegal = true
                        }
                    }
                }
                if self.isRegistAccountInLegal {
                    self.registView.acountInput.setAlertStyle()
                } else {
                    self.registView.acountInput.setNormalStyle()
                }
            }
            self.registView.passwordInput.textField.text = nil
            self.registView.verifyInput.textField.text = nil
            self.registView.verifyBtn.reset()
        }
        
        // 密码内容变化
        let pwdChange = registView.passwordInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 99
            if let text = self.registView.passwordInput.textField.text {
                if text.characters.count > charLimit {
                    self.registView.passwordInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
            }
        }
        
        // 验证码样式变化
        let verifyChange = registView.verifyInput.textField.signal_event_editingChanged.head { [unowned self] (signal) in
            let charLimit: Int = 6
            if let text = self.registView.verifyInput.textField.text {
                if text.characters.count > charLimit {
                    self.registView.verifyInput.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
                self.isVerifyInLegal = false
                if let text = self.registView.verifyInput.textField.text {
                    for char in text.characters {
                        if !"1234567890".characters.contains(char) {
                            self.isVerifyInLegal = true
                        }
                    }
                }
                if self.isVerifyInLegal {
                    self.registView.verifyInput.setAlertStyle()
                } else {
                    self.registView.verifyInput.setNormalStyle()
                }
            }
        }
        
        // 根据文本内容确定登录按钮是否能点击
        QXSignal.combine(accountChange, pwdChange, verifyChange).head { [unowned self] (signal) in
            // 账户名合法后，申请验证码可点击
            if self.registView.acountInput.textField.text?.characters.count == 11 &&
                self.isVerifyInLegal == false {
                if !self.registView.verifyBtn.isCounting {
                    self.registView.verifyBtn.forceDisable(false)
                }
            } else {
                self.registView.verifyBtn.forceDisable(true)
            }
            // 账户名、验证码、密码合法后，注册按钮可点击
            if self.registView.acountInput.textField.text?.characters.count == 11 &&
                self.registView.passwordInput.textField.text?.characters.count >= 6 &&
                self.registView.verifyInput.textField.text?.characters.count == 6 &&
                self.isVerifyInLegal == false &&
                self.isRegistAccountInLegal == false {
                self.registView.registBtn.forceDisable(false)
            } else {
                self.registView.registBtn.forceDisable(true)
            }
        }
        
        // 点击获取验证码
        registView.verifyBtn.signal_event_touchUpInside.head { [unowned self] (signal) in
            let name = self.registView.acountInput.textField.text!
            self.registView.verifyBtn.forceDisable(true)
            LoginManager.shareInstance.getCaptcha(name, success: { [weak self] (code, msg, data) in
                if code == 0 {
                    self?.registView.verifyBtn.fire()
                } else {
                    self?.registView.verifyBtn.forceDisable(false)
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
            }) { [weak self] (error) in
                self?.registView.verifyBtn.forceDisable(false)
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
        }
        
        // 点击注册
        registView.registBtn.signal_event_touchUpInside.head { [unowned self] (signal) in
            
            let name = self.registView.acountInput.textField.text!
            let pwd = self.registView.passwordInput.textField.text!
            let verify = self.registView.verifyInput.textField.text!
            
            for view in self.scrollView.subviews {
                view.isUserInteractionEnabled = false
            }
            let ennableTheView = { [unowned self] in
                for view in self.scrollView.subviews {
                    view.isUserInteractionEnabled = true
                }
                self.registView.registBtn.stopLoading()
            }
            
            self.view.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                LoginManager.shareInstance.register(name, password: pwd, captcha: verify, success: { [weak self] (code, msg, data) in
                    ennableTheView()
                    if code == 0 {
                        self?.autoLogin(name, pwd: pwd)
                        
                    } else {
                        QXTiper.showWarning(msg, inView: self?.view, cover: true)
                    }
                }) { [weak self] (error) in
                    ennableTheView()
                    QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                }
            }
        }

    }

    /// 自动登录
    func autoLogin(_ name: String, pwd: String) {
        let wait = QXTiper.showWaiting("自动登录中...", inView: self.view, cover: true)
        
        self.segmentView.selectIdx = 0
        self.showLogin()
        loginView.acountInput.textField.text = name
        loginView.passwordInput.textField.text = pwd
        loginView.loginBtn.startLoading()
        
        LoginManager.shareInstance.login(name, password: pwd, success: { [weak self] (code, msg, data) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                
                if let dic = data as? [String: Any] {
                    Account.sharedOne.setContent(dic)
                    Account.sharedOne.saveToLocal()
                    // 记住账号
                    UserDefaults.standard.set(name, forKey: kUserDefaultUserName)
                    UserDefaults.standard.set(pwd, forKey: kUserDefaultUserPwd)
                    let vc = GuideChooseAttentionsViewController()
                    vc.comeFromVc = self?.comeFromVc
                    _ = self?.navigationController?.pushViewController(vc, animated: true)
                    SendLoginNotification()
                    LoginManager.shareInstance.sendLoginLogInBackground()
                    
                } else {
                    //assert(true, "格式错误")
                }
            } else {
                self?.loginView.loginBtn.stopLoading()
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            self?.loginView.loginBtn.stopLoading()
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
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

