//
//  ChangeModel.swift
//  touzhong
//
//  Created by zerlinda on 16/8/16.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ChangeModel: NSObject {

    /**
     view夜间模式切换
     
     - author: zerlinda
     - date: 16-08-16 15:08:56
     
     - returns: 如果是夜间模式返回深色，不是夜间模式返回白色
     */
    class func changeModelColor()->UIColor{
        if DataManager.shareInstance.nightModel {
            return UIColor.darkGray
        }
        return UIColor.white
    }
    /**
     controller夜间模式切换
     
     - author: zerlinda
     - date: 16-08-16 15:08:53
     
     - returns: 如果是夜间模式返回深色，
     */
    class func changeControllerModelColor()->UIColor{
        if DataManager.shareInstance.nightModel {
            return UIColor.darkGray
        }
        return MyColor.colorWithHexString("#f5f5fa")
    }
    /**
     文字夜间模式切换
     
     - author: zerlinda
     - date: 16-08-16 17:08:25
     
     - parameter textColor: 文字本来的颜色
     
     - returns: 夜间模式返回白色
     */
    class func changeViewModelTextColor(_ textColor:UIColor)->UIColor{
        if DataManager.shareInstance.nightModel {
            return UIColor.white
        }
        return textColor
    }
    
}
