//
//  Collection.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum MyCollectionType: String {
    case news = "news"
    case report = "report"
    case conference = "conference"
    case figure = "figure"
    case institution = "institution"
    case enterprise = "enterprise"
}

class MyCollection: RootModel {
    
    var userId: String?
    var type: MyCollectionType?
    var targetId: String?
    var targetUrl: String?
    var targetContent: String?
    var targetDescri: String?
    var targetImage: String?
    
    var collectDate: Date?
    
    override func update(_ dic: [String : Any]) {
        super.update(dic)
        userId = dic.nullableString("userid")
        if let t = dic.nullableString("favtype") {
            type = MyCollectionType(rawValue: t)
        }
        targetId = dic.nullableString("targetid")
        targetUrl = dic.nullableString("targeturl")
        targetContent = dic.nullableString("targetcontent")
        targetDescri = dic.nullableString("targetdesc")
        targetImage = dic.nullableString("targetimg")
        
        collectDate = dic.nullableDate("favdate")

    }
    
}
