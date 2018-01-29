//
//  ToLoginViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ToLoginViewController: RootViewController {
    
    weak var comeFromVc: UIViewController?
    
    lazy var loginView: ToLoginView = {
        let one = ToLoginView()
        one.respondLogin = { [unowned self] in
            let vc = LoginViewController()
            vc.comeFromVc = self.comeFromVc
            vc.showRegistOnAppear = false
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondRegist = { [unowned self] in
            let vc = LoginViewController()
            vc.comeFromVc = self.comeFromVc
            vc.showRegistOnAppear = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    var popVC:UIViewController?//登录成功后pop到的vc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        loginView.IN(view).LEFT.RIGHT.TOP(-20).BOTTOM.MAKE()

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
    
}
