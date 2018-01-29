//
//  FriendRequest.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/21.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum FriendRequestHanldeType: Int {
    case notHandle = 0
    case accept = 1
    case refuse = 2
    case ignore = 3
}

class FriendRequest: RootModel {
    var user: User = User()
    var handleType: FriendRequestHanldeType?
    var message: String?
    override func update(_ dic: [String : Any]) {
        super.update(dic)
        
        user.id = dic.nullableString("id")
        user.realName = dic.nullableString("name")
        user.avatar = dic.nullableString("avator")
        
        user.company = dic.nullableString("company")
        user.duty = dic.nullableString("duty")
        
        id = dic.nullableString("reqId")
        message = dic.nullableString("reqMsg")
        
        if let s = dic.nullableInt("requestType") {
            handleType = FriendRequestHanldeType(rawValue: s)
        }
    }
    
}
