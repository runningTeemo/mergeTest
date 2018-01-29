//
//  UserDetail.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/7.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class UserDetail {
    
    var user: User = User()
    
    var articlesCount: Int?
    var circlesCount: Int?
    var commentsCount: Int?
    
    func update(_ dic: [String: Any]) {
        articlesCount = dic.nullableInt("articleCount")
        circlesCount = dic.nullableInt("intrestIndustryCount")
        commentsCount = dic.nullableInt("commentCount")
        if let userDic = dic["user"] as? [String: Any] {
            user.updateInCircle(userDic)
        }
        
        user.isFriend = dic.nullableBool("isFriend")
        if let dic = dic["ownIndustry"] as? [String: Any] {
            let industry = Industry()
            industry.update(dic)
            if industry.id != nil {
                user.industry = industry
            }
        }
    }
    
}
