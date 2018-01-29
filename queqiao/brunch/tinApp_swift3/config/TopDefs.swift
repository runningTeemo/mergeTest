//
//  TopDefs.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

let kWebErrMsg = "网络不给力"

let kScreenSize: CGSize = UIScreen.main.bounds.size
let kScreenW: CGFloat = kScreenSize.width
let kScreenH: CGFloat = kScreenSize.height

let kScreen320x480: Bool = (kScreenW == 320) && (kScreenH == 480)
let kScreen320x568: Bool = (kScreenW == 320) && (kScreenH == 568)
let kScreen375x667: Bool = (kScreenW == 375) && (kScreenH == 667)
let kScreen540x960: Bool = (kScreenW == 540) && (kScreenH == 960)

let kSizeRatio: CGFloat = kScreenW / 350

func HEX(_ s: String) -> UIColor {
    return MyColor.colorWithHexString(s)
}

func RGBA(_ R: CGFloat, _ G: CGFloat, _ B: CGFloat, _ A: CGFloat) -> UIColor {
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A/255.0)
}

var NewBreakLine: UIView {
    let one = UIView()
    one.backgroundColor = HEX("#e1e1e1")
    return one
}

var NewKeyboardLine: UIView {
    let one = UIView()
    one.backgroundColor = HEX("#8c8c8c")
    one.frame = CGRect(x: 0, y: 0, width: 0, height: 0.5)
    return one
}

let kSizBorder: CGFloat = 0.5
let kSizBtnHeight: CGFloat = 44

let kSizLrMargin: CGFloat = 12.5
let kSizTbMargin: CGFloat = 15

let kClrWhite = UIColor.white
let kClrBlack = UIColor.black
let kClrOrange = HEX("#d61f26")
let kClrBtnDown = HEX("#c01a21")
let kClrBlue = HEX("#3aaaf1")
let kClrDeepGray = HEX("#333333")
let kClrDarkGray = HEX("#666666")
let kClrGray = HEX("#999999")
let kClrLightGray = HEX("#bdbdbd")
let kClrSlightGray = HEX("#f2f2f2")
let kClrBackGray = HEX("#eaeeef")
let kClrBreak = HEX("#e1e1e1")

let kFontBigTitle = UIFont.systemFont(ofSize: 20)
let kFontTitle = UIFont.systemFont(ofSize: 18)
let kFontSubTitle = UIFont.systemFont(ofSize: 16)
let kFontNormal = UIFont.systemFont(ofSize: 14)
let kFontSmall = UIFont.systemFont(ofSize: 12)
let kFontTip = UIFont.systemFont(ofSize: 12)

let kClrBigTitle = kClrDeepGray
let kClrTitle = kClrDeepGray
let kClrSubTitle = kClrDeepGray
let kClrNormalTxt = kClrDarkGray
let kClrTip = kClrGray

let kUserDefaultKeyFontSize = "userFontSize"
let kUserDefaultUserName = "userName"
let kUserDefaultUserPwd = "userPwd"


// 收到认证成功的推送
let kNotificationAuthorSuccess = NSNotification.Name(rawValue: "kNotificationAuthorSuccess")
// 收到认证失败的推送
let kNotificationAuthorFailed = NSNotification.Name(rawValue: "kNotificationAuthorFailed")
// 收到异地登陆的推送
let kNotificationLoginInOtherPlace = NSNotification.Name(rawValue: "kNotificationLoginInOtherPlace")
// 验签失败（调用接口）
let kNotificationTokenErrorFailed = NSNotification.Name(rawValue: "kNotificationTokenErrorFailed")
// 登陆成功发送
let kNotificationLogin = NSNotification.Name(rawValue: "kNotificationLogin")
// 登陆失败发送
let kNotificationLogout = NSNotification.Name(rawValue: "kNotificationLogout")

let ReciveMessage = NSNotification.Name(rawValue: "kReciveMessage")
let replyApplyCheck = NSNotification.Name(rawValue: "kreplyApplyCheck")

func XYDEBUG<T>(_ message: T, file: NSString = #file, method: String = #function, line: Int = #line)
{
    //    该打印函数会打印文件名,方法名
    #if DEBUG
        print("\(method)[\(line)]: \(message)")
    #endif
}



//REMARKS

//cvappp@$$word
