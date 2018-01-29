//
//  IndustryMember.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/20.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class IndustryMember {
    var user: User = User()
    var createDate: Date?
    var isParty: Bool?
    
    var dateForPaging: String?
    
    func update(_ dic: [String: Any]) {
        user.updateInCircle(dic)
        if let d = dic.nullableInt("memberType") {
            if d == 0 {
                isParty = true
            } else {
                isParty = false
            }
        }
        createDate = dic.nullableDate("timestamp")
        dateForPaging = dic.nullableString("timestamp")
    }
    
}
