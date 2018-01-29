//
//  Meeting.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum MeetingType: Int {
    case year = 1
    case other = 2
    case tinCoorp = 3
    case tin = 4
}

enum MeetingSort: Int {
    case time = 1
    case recommend = 2
    case hot = 3
}

enum MeetingOrderBy: String {
    case DateAsc = "start_date asc"
    case DateDesc = "start_date desc"
    case WeightAsc = "weight asc"
    case WeightDesc = "weight desc"
    case ClickAsc = "total_click asc"
    case ClickDesc = "total_click desc"
}

class Meeting {
    
    var id: Int?
    var name: String?
    var provinceId: Int?
    
    var cityId: Int?
    
    var address: String?
    
    var sponsor: String?
    
    var startDate: Date?
    var endDate: Date?
    
    var startWeek: Int?
    var endWeek: Int?
    
    var coverImage: String?
    
    var url: String?
    
    var introduction: String?
    
    var type: MeetingType?
    
    var meetProcess: String?
    var weight: Int?
    var publishStatus: Int?
    var publishDate: Date?
    
    var createUserId: String?
    var updateUserId: String?
    
    var createDate: Date?
    var updateDate: Date?
    
    var delStatus: Int?
    
    var tags: [String]?
    
    var dateForPaging: String?
    
    func update(_ dic: [String: Any]) {
                
        id = dic.nullableInt("id")
        name = dic.nullableString("name")
        provinceId = dic.nullableInt("provinceId")
        cityId = dic.nullableInt("cityId")
        
        address = dic.nullableString("address")
        sponsor = dic.nullableString("sponsor")
        
        startDate = dic.nullableDate("startDate")
        endDate = dic.nullableDate("endDate")
        
        startWeek = dic.nullableInt("startWeek")
        endWeek = dic.nullableInt("endWeek")
        
        coverImage = dic.nullableString("coverImg")
        
        url = dic.nullableString("url")
        introduction = dic.nullableString("introduction")
        if let i = dic.nullableInt("type") {
            if i > 0 && i < 5 {
                type = MeetingType(rawValue: i)
            }
        }
        meetProcess = dic.nullableString("meetProcess")
        weight = dic.nullableInt("weight")
        publishStatus = dic.nullableInt("publishStatus")
        publishDate = dic.nullableDate("publishAt")
        
        dateForPaging = dic.nullableString("publishAt")
        
        createUserId = dic.nullableString("createUserId")
        updateUserId = dic.nullableString("updateUserId")
        createDate = dic.nullableDate("createAt")
        updateDate = dic.nullableDate("updateAt")
        delStatus = dic.nullableInt("delStatus")
        
        if let arr = dic["tagList"] as? [String] {
            var tags = [String]()
            for tag in arr {
                tags.append(tag)
            }
            self.tags = tags
        }
        
    }
    
}


class MeetingTip: RootModel {
    
    var createUserId: String?
    var updateUserId: String?
    var weight: Int?
    
    var name: String?

    override func update(_ dic: [String: Any]) {
        id = dic.nullableString("id")
        createDate = dic.nullableDate("createAt")
        updateDate = dic.nullableDate("updateAt")
        deleted = dic.nullableBool("delStatus")
        createUserId = dic.nullableString("createUserId")
        updateUserId = dic.nullableString("updateUserId")
        weight = dic.nullableInt("weight")

        name = dic.nullableString("name")
    }
}
