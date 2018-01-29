//
//  Industry.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class Industry: labelProtocol {
    
    var id: String?
    var name: String?
    var icon: String?
    
    var content: String? {
        return id
    }
        
    func update(_ dic: [String : Any]) {
        id = dic.nullableString("id")
        name = dic.nullableString("name")
        icon = dic.nullableString("img")
    }
    
    /// 用在投资圈里
    func toDicOld() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("id", value: id)
        dic.checkOrAppend("name", value: name)
        return dic
    }
    
    func toDic() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("id", value: id)
        dic.checkOrAppend("name", value: name)
        dic.checkOrAppend("img", value: icon)
        return dic
    }
    
    var isParty: Bool?

    
}
