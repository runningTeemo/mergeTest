//
//  RankList.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

/// 一级榜单模型
class RankList: SubRankList {
    
    var meetId: String?
    var coverImage: String?
    var year: Int?
    var publishDate: Date?

    var publishStatus: Int?
    
    override func update(_ dic: [String : Any]) {
        super.update(dic)
        meetId = dic.nullableString("meetId")
        coverImage = dic.nullableString("coverImg")
        year = dic.nullableInt("year")
        publishStatus = dic.nullableInt("publishStatus")
    }
    
}

/// 榜单类型
enum RankType: Int {
    case subRankList = 0 // 二级菜单
    case institution = 1 // 机构
    case person = 2 // 人物
    case other = 3 // 其他
    case `case` = 4 // 案例(企业)
}

/// 主榜类型
enum RankOrderType: Int {
    case pe = 1
    case vc = 2
    case lp = 3
}

/// 二级榜单
class SubRankList {
    
    var id: Int?
    
    var parentId: String?
    
    var type: RankType? // 榜单类型
    
    var orderType: RankOrderType?
    
    var name: String?
    var descri: String?
    var location: String?
    var remark: String?
    
    var createUserId: String?
    var updateUserId: String?
    
    var delStatus: Int?
    
    var createDate: Date?
    var updateDate: Date?
    
    func update(_ dic: [String : Any]) {
        
        id = dic.nullableInt("id")
        
        name = dic.nullableString("name")
        descri = dic.nullableString("description")
        createDate = dic.nullableDate("createAt")
        updateDate = dic.nullableDate("updateAt")
        location = dic.nullableString("location")
        
        remark = dic.nullableString("remark")
        
        createUserId = dic.nullableString("createUserId")
        updateUserId = dic.nullableString("updateUserId")
        
        delStatus = dic.nullableInt("delStatus")
        
        if let i = dic.nullableInt("type") {
            if i < 5 {
                type = RankType(rawValue: i)
            }
        }
        parentId = dic.nullableString("parentId")
        if let i = dic.nullableInt("orderType") {
            if i >= 1 && i <= 3 {
                orderType = RankOrderType(rawValue: i)
            }
        }
    }
    
}

/// 榜单详情
class RankDetail {
    var id: Int!
    var type: RankType?
    
    var createDate: Date?
    var updateDate: Date?
    var createUserId: String?
    var updateUserId: String?
    
    var cvId: String?
    var delStatus: Int?
    var picture: String?
    var icon: String?

    var name: String?
    var descri: String?
    
    var rankCatalogId: Int?
    
    var institutions: String? // 用于RankType.Case
    
    var rankType: RankType?
    
    func update(_ dic: [String: Any]) {
        
        id = dic.nullableInt("id")
                
        name = dic.nullableString("name")
        descri = dic.nullableString("description")

        createDate = dic.nullableDate("createAt")
        updateDate = dic.nullableDate("updateAt")
        
        createUserId = dic.nullableString("createUserId")
        updateUserId = dic.nullableString("updateUserId")
        
        delStatus = dic.nullableInt("delStatus")
        icon = dic.nullableString("logoUrl")
        picture = dic.nullableString("coverImg")
        
        cvId = dic.nullableString("cvId")

        if let i = dic.nullableInt("type") {
            if i < 5 {
                type = RankType(rawValue: i)
            }
        }
        institutions = dic.nullableString("institutions")
    }
    
}

