//
//  ConfirmTool.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/27.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

typealias DoneClosure = () -> ()

struct Confirmer {
    
    static func show(_ title: String?, message: String?, confirm: String = "确定", confirmHandler: (() -> ())?, cancel: String = "取消", cancelHandler: (() -> ())? = nil, inVc: UIViewController?) {
        if inVc == nil { return }
        let vc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: confirm, style: .destructive) { (act) in
            confirmHandler?()
        }
        let cancel = UIAlertAction(title: cancel, style: .cancel) { (act) in
            cancelHandler?()
        }
        vc.addAction(confirm)
        vc.addAction(cancel)
        inVc?.present(vc, animated: true, completion: nil)
    }
    
}

struct ActionSheet {
    
    static func show(_ title: String?, actions: [(title: String, handler: (()->())?)], inVc: UIViewController?) {
        if inVc == nil { return }
        let vc = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for action in actions {
            let action = UIAlertAction(title: action.title, style: .default) { (act) in
                action.handler?()
            }
            vc.addAction(action)
        }
        let action = UIAlertAction(title: "取消", style: .cancel) { (act) in
        }
        vc.addAction(action)
        inVc?.present(vc, animated: true, completion: nil)
    }
    
}
