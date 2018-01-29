//
//  ArticleWriteLimitChecker.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/19.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class ArticleWriteLimitChecker {
    
    class func check(onVc: UIViewController, operation: String) -> Bool {
        
        if Account.sharedOne.isLogin {
            
            let me = Account.sharedOne.user
            
            if let author = me.author {
                switch author {
                case .not:
                    Confirmer.show("提示", message: "未认证用户无法\(operation)，是否去认证？", confirm: "去认证", confirmHandler: { [weak onVc] in
                        if let vc = onVc {
                            self.gotoAuthor(vc: vc)
                        }
                        }, cancel: "取消", cancelHandler: {
                        }, inVc: onVc)
                    return false
                case .progressing:
                    Confirmer.show("提示", message: "正在认证中，通过后可\(operation)", confirm: "确定", confirmHandler: {
                        }, cancel: "取消", cancelHandler: {
                        }, inVc: onVc)
                    return false
                case .isAuthed:
                    if let _ = me.industry {
                        return true
                    } else {
                        Confirmer.show("提示", message: "未设置所属行业无法\(operation)，去设置？", confirm: "去设置", confirmHandler: { [weak onVc] in
                            if let vc = onVc {
                                self.pushToIndustryPicker(vc: vc)
                            }
                            }, cancel: "取消", cancelHandler: {
                            }, inVc: onVc)
                        return false
                    }
                case .failed:
                    Confirmer.show("提示", message: "认证失败，认证成功后可\(operation)，查看认证信息？", confirm: "查看认证信息", confirmHandler: { [weak onVc] in
                        if let vc = onVc {
                            self.gotoAuthor(vc: vc)
                        }
                        }, cancel: "取消", cancelHandler: {
                        }, inVc: onVc)
                    return false
                }
                
            } else {
                return false
            }
        }
        return false
    }
    
    class func gotoAuthor(vc: UIViewController) {
        vc.tabBarController?.selectedIndex = 4
    }
    
    class func gotoInfo(vc: UIViewController) {
        let infovc = MeInformationViewController()
        infovc.hidesBottomBarWhenPushed = true
        vc.navigationController?.pushViewController(infovc, animated: true)
    }
    
    class func pushToIndustryPicker(vc: UIViewController) {
        let indVc = SetIndustryViewController()
        indVc.isAttentionMode = false
        indVc.hidesBottomBarWhenPushed = true
        vc.navigationController?.pushViewController(indVc, animated: true)
    }
    
    
    
}
