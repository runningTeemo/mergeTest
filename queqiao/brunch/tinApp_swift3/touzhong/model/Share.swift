//
//  Share.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class Share: NSObject {
    var id: String!
    var user: User = User()
    var createDate: Date?
    
    func update(_ dic: [String: Any]) {
        id = dic.nullableString("id")
        if let dic = dic["user"] as? [String: Any] {
            user.updateInCircle(dic)
        }
        createDate = dic.nullableDate("date")
    }
}
