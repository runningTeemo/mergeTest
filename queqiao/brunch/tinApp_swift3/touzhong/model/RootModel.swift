//
//  RootModel.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

/// 根模型，大部分模型继承自他
class RootModel: NSObject {
    
    /// 唯一标示
    var id: String? {
        didSet{
            let hid = id?.replacingOccurrences(of: "-", with: "_")
            self.huanXinId = SafeUnwarp(hid, holderForNull: "")
        }
    }
    var huanXinId:String = ""
    /// 创建时间
    var createDate: Date?
    /// 更新时间
    var updateDate: Date?
    
    var deleted: Bool?
    
    func update(_ dic: [String: Any]) {
        id = dic.nullableString("id")
        createDate = dic.nullableDate("createdate")
        updateDate = dic.nullableDate("updatedate")
        deleted = dic.nullableBool("deleted")
    }
        
}
