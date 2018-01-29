//
//  Account.swift
//  tinCRM
//
//  Created by Richard.q.x on 16/8/3.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import Foundation

/// 这是一个单例，用于表示当前账户
class Account: NSObject {
    
    /// 单例
    static let sharedOne: Account = Account()
    
    /// 接口使用的token
    var token: String {
//        assert(_accessToken != nil, "token不能为空")
//        return _accessToken!
        return SafeUnwarp(_accessToken, holderForNull: "")
    }
    
    /// 接口使用的token
    var deviceId: String {
//        assert(_deviceId != nil, "_deviceId不能为空")
//        return _deviceId!
        return SafeUnwarp(_deviceId, holderForNull: "")
    }
    
    /// 当前用户
    var user: User {
//        assert(_user != nil, "用户不能为空")
//        return _user!
        return SafeUnwarp(_user, holderForNull: User())
    }
    
    /// 是否登录
    var isLogin: Bool {
        if _accessToken != nil && _user?.id != nil {
            return true
        } else {
            return false
        }
    }
    
    /// 可选userId
    var optionalUserId: String? {
        if isLogin {
            return user.id
        }
        return nil
    }
    
    var friendsBadge:Int = 0{//加好友徽章
        didSet{
            UIApplication.shared.applicationIconBadgeNumber = Account.sharedOne.amountBadge
        }
    }
    var messagesBadge:Int = 0{//发消息徽章
        didSet{
            UIApplication.shared.applicationIconBadgeNumber = Account.sharedOne.amountBadge
        }
    }
    var associateBadge:Int = 0{
        didSet{
            UIApplication.shared.applicationIconBadgeNumber = Account.sharedOne.amountBadge
        }
    }
    var amountBadge:Int {//总徽章数
        get{
            return Account.sharedOne.friendsBadge + Account.sharedOne.messagesBadge + Account.sharedOne.associateBadge
        }
    }
    var associateMessage:String?//与我相关
    
    var lastMessage:EMMessage?//收到的最新一条消息
    
    
    fileprivate var _accessToken: String?
    fileprivate var _deviceId: String? = ""
    fileprivate var _user: User?
    fileprivate var _dic: [String: Any]?
    
    func setContent(_ dic: [String: Any]) {
        if let d = dic["user"] {
            let userDic = d as! [String: Any]
            _user = User()
            _user?.update(userDic)
        }
        if let d = dic["access_token"] {
            _accessToken = d as? String
        }
        if let d = dic["deviceId"] {
            _deviceId = d as? String
        }
        _dic = dic
    }

    var userCachePath: String {
        return PathTool.document + "/account.cache"
    }
    
    /**
     把用户存到本地
     - author: zerlinda
     - date: 16-09-02 14:09:45
     */
    func saveToLocal() {
        if let d = _dic {
            do {
                let data = try JSONSerialization.data(withJSONObject: d, options: JSONSerialization.WritingOptions(rawValue: 0))
                if !((try? data.write(to: URL(fileURLWithPath: userCachePath), options: [.atomic])) != nil) {
                    print("保存用户失败，保存失败")
                }
            } catch {
                print("用户数据序列化保存失败\(error)")
            }
        }
    }
    
    /// 保存用户某个参数
    func saveUser(_ key: String, _ value: Any?) {
        if var user = _dic?["user"] as? [String: Any] {
            user[key] = value
            _dic?["user"] = user as AnyObject?
        }
        saveToLocal()
    }
    
    func saveUser() {
        _dic?["user"] = user.toDic() as AnyObject?
        saveToLocal()
    }
    
    func saveUser(user: User) {
        _user = user
        saveUser()
    }
    
    func checkOrAppend(industry: Industry) {
        var notExsit: Bool = true
        for myIndustry in user.industries {
            if SafeUnwarp(industry.id, holderForNull: "") == SafeUnwarp(myIndustry.id, holderForNull: "") {
                notExsit = false
            }
        }
        if notExsit {
            user.industries.append(industry)
        }
        saveToLocal()
    }
    
    func checkOrRemove(industry: Industry) {
        var idx: Int?
        for i in 0..<user.industries.count {
            let myIndustry = user.industries[i]
            if SafeUnwarp(industry.id, holderForNull: "") == SafeUnwarp(myIndustry.id, holderForNull: "") {
                idx = i
            }
        }
        if let idx = idx {
            user.industries.remove(at: idx)
        }
        saveToLocal()
    }

    /**
     读取本地
     - author: zerlinda
     - date: 16-09-02 14:09:02
     - returns: <#return value description#>
     */

    func loadLocal() -> Bool {

        
        if !FileManager.default.fileExists(atPath: userCachePath) {
            return false
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: userCachePath), options: NSData.ReadingOptions(rawValue: 0))
            do {
                let obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let dic = obj as? [String: Any] {
                    setContent(dic)
                    return true
                } else {
                    //assert(true, "本地accout数据解析得到的不是字典")
                }
            } catch {
                print("本地accout数据json解析失败\(error)")
            }
        } catch {
            print("本地accout数据加载失败\(error)")
        }
        return false
    }
    
    /**
     删除本地用户数据
     
     - author: zerlinda
     - date: 16-09-02 14:09:14
     */
    func clearUser() {
        do {
            try FileManager.default.removeItem(atPath: userCachePath)
            _accessToken = nil
            _user = nil
            _dic = nil
        } catch {
            print("删除用户数据失败:\n\(error)")
        }
    }
    
    func logout() {
        clearUser()
        ChatManage.shareInstance.outLogin()
        SendLogoutNotification()
    }

}

