//
//  Career.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class Career: RootModel {
    
    var userId: String?
    var userRoleType: Int? // 用户的RoleType
    
    /// 公司
    var companyId: Int?
    var company: String?
    var companyType: OrganizationType?
    
    var possition: String?
    var quited: Bool?
    var email: String?
    
    var startDate: Date?
    var endDate: Date?

    var emailStatus: String?
    var cardImage: String?
    var thumbCardImage: String?
    
    var authorStatus: Author?
    var authorType: AuthorType?
    
    var isUsedForUserAuthor: Bool?
    
    override func update(_ dic: [String : Any]) {
        super.update(dic)
        
        userId = dic.nullableString("userid")
        userRoleType = dic.nullableInt("userType")
        
        companyId = dic.nullableInt("companyId")
        company = dic.nullableString("company")
        if let n = dic.nullableInt("companyType") {
            if n == 0 || n == 1 {
                companyType = OrganizationType(rawValue: n)
            }
        }
        
        possition = dic.nullableString("duties")
        quited = dic.nullableBool("quited")
        
        startDate = dic.nullableDate("startDate")
        endDate = dic.nullableDate("endDate")
        
        emailStatus = dic.nullableString("emailStatus")
        cardImage = dic.nullableString("cardImg")
        thumbCardImage = dic.nullableString("tCardImg")

        if let c = dic.nullableInt("oauthStatus") {
            authorStatus = Author(rawValue: c)
        }
        if let c = dic.nullableInt("oauthType") {
            authorType = AuthorType(rawValue: c)
        }
        if let c = dic.nullableInt("oauthType") {
            if c == 0 {
                isUsedForUserAuthor = false
            } else {
                isUsedForUserAuthor = true
            }
        }
    }
    
    func toDic() -> [String: Any] {
        var dic = [String: Any]()
        
        dic.checkOrAppend("userId", value: userId)
        
        dic.checkOrAppend("id", value: id)
        dic.checkOrAppend("userType", value: userRoleType)

        dic.checkOrAppend("companyId", value: companyId)
        dic.checkOrAppend("company", value: company)
        dic.checkOrAppend("companyType", value: companyType?.rawValue)
        
        dic.checkOrAppend("duties", value: possition)
        dic.checkOrAppend("quited", value: quited?.appToString())
        
        dic.checkOrAppend("email", value: email)
        dic.checkOrAppend("emailStatus", value: emailStatus)
        
        dic.checkOrAppend("cardImg", value: cardImage)
        dic.checkOrAppend("tCardImg", value: thumbCardImage)

        dic.checkOrAppend("oauthStatus", value: authorStatus?.rawValue.appToString())
        dic.checkOrAppend("oauthType", value: authorType?.rawValue.appToString())
        
        dic.checkOrAppend("startDate", value: startDate?.appToString())
        dic.checkOrAppend("endDate", value: endDate?.appToString())
        
        return dic
    }
    
}
