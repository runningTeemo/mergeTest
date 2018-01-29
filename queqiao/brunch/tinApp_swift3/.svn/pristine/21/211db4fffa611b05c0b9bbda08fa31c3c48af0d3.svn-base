//
//  User.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum Author: Int {
    case not = 0
    case progressing = 1
    case isAuthed = 2
    case failed = 3
}

enum AuthorType: Int {
    case author
    case change
}

//enum Gender: String {
//    case Male = "男"
//    case Female = "女"
//}
//
//let kRoleTypes: [(name: String, code: String)] = [
//    ("投资人", "investor"),
//    ("创业者", "enterpriser"),
//    ("其他", "other"),
//    ("企业", "ENT"),
//    ("GP", "GP"),
//    ("LP", "LP"),
//    ("FA", "FA")
//]

class User: RootModel {
    
    /// 登录名
    var loginName: String?
    /// 昵称
    //var nickName: String?
    /// 真实姓名
    var realName: String?
    /// 用户名
    var userName: String?
    
    /// 授权
    var author: Author?
    
    /// 头像
    var avatar: String?
    
    /// 公司
    var companyId: Int?
    var company: String?
    var companyType: OrganizationType?

    /// 邮箱
    var email: String?
    /// 认证邮箱
    var exmail: String?

    /// 性别
    var gender: String?
    /// 手机号
    var mobile: String?
    /// 职位
    var position: String?
    /// GP/LP/企业
    var roleType: Int?
    
    var cnName: String?
    var duty: String?
    var isFriend: Bool?
    var industry: Industry? // 所属
    var industries: [Industry] = [Industry]() // 关注

    func isMe() -> Bool {
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            return me.id == id
        }
        return false
    }
        
    override func update(_ dic: [String : Any]) {
        super.update(dic)
        
        id = dic.nullableString("userid")
        
        loginName = dic.nullableString("loginname")
        //nickName = dic.nullableString("nickname")
        realName = dic.nullableString("realname")
        userName = dic.nullableString("username")

        avatar = dic.nullableString("avatar")
        
        companyId = dic.nullableInt("companyId")
        company = dic.nullableString("company")
        if let n = dic.nullableInt("commpanyType") {
            if n == 0 || n == 1 {
                companyType = OrganizationType(rawValue: n)
            }
        }
        
        email = dic.nullableString("email")
        exmail = dic.nullableString("exmail")
        
        gender = dic.nullableString("gender")
        
        mobile = dic.nullableString("mobile")
        position = dic.nullableString("position")
        
        roleType = dic.nullableInt("roletype")
        
        if let n = dic.nullableInt("oauthStatus") {
            author = Author(rawValue: n)
        }
        
        if let arr = dic["oindustrys"] as? [[String: Any]] {
            if let dic = arr.first {
                let industry = Industry()
                industry.update(dic)
                self.industry = industry
            }
        }
        
        if let arr = dic["findustrys"] as? [[String: Any]] {
            var industries = [Industry]()
            for dic in arr {
                let industry = Industry()
                industry.update(dic)
                industries.append(industry)
            }
            self.industries = industries
        }
        
    }
    
    func toDic() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("userid", value: id)
        dic.checkOrAppend("loginname", value: loginName)
        //dic.checkOrAppend("nickname", value: nickName)
        dic.checkOrAppend("realname", value: realName)
        dic.checkOrAppend("userName", value: userName)
        
        dic.checkOrAppend("avatar", value: avatar)
        
        dic.checkOrAppend("companyId", value: companyId)
        dic.checkOrAppend("company", value: company)
        dic.checkOrAppend("commpanyType", value: companyType?.rawValue)

        dic.checkOrAppend("email", value: email)
        dic.checkOrAppend("exmail", value: exmail)
        
        dic.checkOrAppend("gender", value: gender)
        
        dic.checkOrAppend("mobile", value: mobile)
        dic.checkOrAppend("position", value: position)
        dic.checkOrAppend("roletype", value: roleType)
        dic.checkOrAppend("oauthStatus", value: author?.rawValue)
        
        if let industry = industry {
            dic["oindustrys"] = [industry.toDic()]
        }
        do {
            var arr = [[String: Any]]()
            for industry in industries {
                arr.append(industry.toDic())
            }
            dic["findustrys"] = arr
        }
        return dic
    }
    
    /// 用在投资圈里
    func updateInCircle(_ dic: [String : Any]) {
        
        id = dic.nullableString("id")
        realName = dic.nullableString("name")

        companyId = dic.nullableInt("companyId")
        company = dic.nullableString("company")
        if let n = dic.nullableInt("companyType") {
            if n == 0 || n == 1 {
                companyType = OrganizationType(rawValue: n)
            }
        }
        
        duty = dic.nullableString("duty")
        roleType = dic.nullableInt("roleType")
        avatar = dic.nullableString("avator")
        isFriend = dic.nullableBool("isFriend")
        if let n = dic.nullableInt("oauthStatus") {
            author = Author(rawValue: n)
        }
        
        if let dic = dic["majorIndustry"] as? [String: Any] {
            let ind = Industry()
            ind.update(dic)
            ind.isParty = true
            self.industry = ind
        }
        if let arr = dic["interestIndustry"] as? [[String: Any]] {
            var inds = [Industry]()
            for dic in arr {
                let ind = Industry()
                ind.update(dic)
                ind.isParty = false
                inds.append(ind)
            }
            self.industries = inds
        }
    }
    
    /// 用在投资圈里
    func updateInUserSearch(_ dic: [String : Any]) {
        
        id = dic.nullableString("userId")
        realName = dic.nullableString("enName")
        //nickName = dic.nullableString("cnName")
        
        company = dic.nullableString("company")
        
        duty = dic.nullableString("duty")
        
        avatar = dic.nullableString("headImg")
        
        isFriend = dic.nullableBool("friend")
        
        mobile = dic.nullableString("mobile")
        
        if let n = dic.nullableInt("oauthStatus") {
            author = Author(rawValue: n)
        }
        
        if let id = dic.nullableString("industryId") {
            let ind = Industry()
            ind.id = id
            ind.name = dic.nullableString("industryName")
            self.industry = ind
        }
        
        if let arr = dic["concermIndustry"] as? [[String: Any]] {
            var inds = [Industry]()
            for dic in arr {
                let ind = Industry()
                ind.update(dic)
                ind.isParty = false
                inds.append(ind)
            }
            self.industries = inds
        }
    }
    
    /// 用在投资圈里
    func toDicOld() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("id", value: id)
        dic.checkOrAppend("name", value: realName)
        return dic
    }
    
}
