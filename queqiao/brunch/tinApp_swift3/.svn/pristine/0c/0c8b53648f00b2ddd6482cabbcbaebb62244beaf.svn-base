//
//  LoginManeger.swift
//  touzhong
//
//  Created by zerlinda on 16/8/24.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LoginManager: NSObject {
    
    static let shareInstance = LoginManager()
    
    func sendLoginLogInBackground() {
        LocationGetter.shareOne.getLocation { (_, loc, mark) in
            
            if !Account.sharedOne.isLogin { return }
            
            let userId = Account.sharedOne.user.id
            let deviceId = Account.sharedOne.deviceId
            self._sendLoginLog(userId: userId, deviceId: deviceId, location: loc, placeMark: mark, success: { (code, msg, _) in
                if code == 0 {
                } else {
                    print("登陆日志发送失败: \(msg)")
                }
            }, failed: { (error) in
                print("登陆日志发送失败: \(error)")
            })
        }
    }
    
    
    private func _sendLoginLog(userId: String?, deviceId: String?, location: CLLocation?, placeMark: CLPlacemark?,  success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("userId", value: userId)
        dic.checkOrAppend("loginFrom", value: "0")
        
        dic.checkOrAppend("country", value: placeMark?.country)
        dic.checkOrAppend("province", value: placeMark?.administrativeArea)
        dic.checkOrAppend("city", value: placeMark?.subAdministrativeArea)
        dic.checkOrAppend("county", value: placeMark?.subLocality)
        dic.checkOrAppend("location", value: placeMark?.name)
        
        dic.checkOrAppend("longitude", value: location?.coordinate.longitude)
        dic.checkOrAppend("latitude", value: location?.coordinate.latitude)
        
        dic.checkOrAppend("deviceId", value: deviceId)
        dic.checkOrAppend("osVersion", value: UIDevice.current.systemVersion)
        dic.checkOrAppend("modelName", value: UIDevice.current.name)
        
        dic.checkOrAppend("phoneType", value: DeviceTool.getDeviceType())
        
        NetWork.shareInstance.post(.cvSource, "mobile/appuser/saveLoginLog.do", params: dic, success: success, failed: failed)
        
    }
    
    /**
     登录
     
     - author: zerlinda
     - date: 16-08-25 10:08:50
     
     - parameter mobile:   手机号
     - parameter password: 密码
     */
    func login(_ mobile:String, password:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed){
        
        var id: String?
        DataManager.shareInstance.getDeviceId { (_id) in
            id = _id
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            
            if let id = id {
                var dic = [String: Any]()
                dic.checkOrAppend("username", value: mobile)
                dic.checkOrAppend("password", value: password)
                dic.checkOrAppend("deviceid", value: id)
                dic.checkOrAppend("source", value: "TI")
                NetWork.shareInstance.post(.userCenter, "sso/login", params: dic, success: { (code, msg, data) in
                    if code == 0 {
                        if let dic = data as? [String: Any] {
                            var _newDic = dic
                            _newDic["deviceId"] = id
                            success(code, msg, _newDic)
                        } else {
                            success(code, msg, data)
                        }
                    } else {
                        success(code, msg, data)
                    }
                }, failed: failed)
                
            } else {
                let err = NSError(domain: "deviceId 获取失败", code: 999, userInfo: nil)
                failed(err)
            }
        }
    }
    
    func logout(_ mobile:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed){
        var dic = [String: Any]()
        dic.append("username", value: mobile, holderForNull: "")
        NetWork.shareInstance.get(.userCenter, "sso/logout", params: dic, success: success, failed: failed)
    }
    
    /**
     注册
     
     - author: zerlinda
     - date: 16-08-25 17:08:50
     
     - parameter mobile:   手机号
     - parameter password: 密码
     - parameter captcha:  验证码
     - parameter success:  成功
     - parameter failed:   失败
     */
    func register(_ mobile:String, password:String, captcha:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed){
        var dic = [String: Any]()
        dic.checkOrAppend("username", value: mobile)
        dic.checkOrAppend("password", value: password)
        dic.checkOrAppend("regtype", value: "mobile")
        dic.checkOrAppend("captcha", value: captcha)
        dic.checkOrAppend("reqFromCode", value: 1)
        NetWork.shareInstance.post(.userCenter, "register", params: dic, success: success, failed: failed)
    }
    /**
     获取验证码
     
     - author: zerlinda
     - date: 16-08-25 10:08:14
     
     - parameter mobile: 手机号
     */
    func getCaptcha(_ mobile:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed){
        
        var dic = [String: Any]()
        dic.append("mobile", value: mobile, holderForNull: "")
        dic.append("reqFrom", notNullValue: "APP")
        NetWork.shareInstance.get(.userCenter, "captcha/mobile/send", params: dic, success: success, failed: failed)
    }
    /**
     找回密码之前检验验证码
     
     - author: zerlinda
     - date: 16-08-25 10:08:45
     
     - parameter mobile:   手机号
     - parameter userName: 手机号
     - parameter captcha:  验证码
     */
    
    func checkCaptcha(_ mobile:String, userName:String, captcha:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed){
        var dic = [String: Any]()
        dic.checkOrAppend("mobile", value: mobile)
        dic.checkOrAppend("username", value: userName)
        dic.checkOrAppend("captcha", value: captcha)
        dic.checkOrAppend("regtype", value: "mobile")
        NetWork.shareInstance.post(.userCenter, "captcha/check", params: dic, success: success, failed: failed)
    }
    
    /**
     重置密码
     
     - author: zerlinda
     - date: 16-08-25 10:08:27
     
     - parameter mobile:   手机号
     - parameter userName: 手机号
     - parameter password: 密码
     */
    func retrievePassword(_ mobile:String, password:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed){
        var dic = [String: Any]()
        dic.checkOrAppend("username", value: mobile)
        dic.checkOrAppend("password", value: password)
        dic.checkOrAppend("regtype", value: "mobile")
        NetWork.shareInstance.post(.userCenter, "profile/sec/forgetpwd", params: dic, success: success, failed: failed)
    }
    
}
