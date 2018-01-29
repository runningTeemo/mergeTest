//
//  News.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class Tag {
    var type: String?
    var name: String?
}

class KeyWord {
    var id: String?
    var content: String?
}

enum NewsStyle: String {
    case Adv = "ADV"
    case News = "NEWS"
}

enum NewsType {
    case news
    case report
}

class News: NSObject {
    
    var id: Int?
    var channel: String?
    var industryId: String?
    var tag: Tag = Tag()

    var title: String? // 新闻标题
    var coverImage: String?
    var introduction: String? // 简介
    
    var publishDate: Date?
    var shareInfo: [String: Any]?
    
    var author: String?
    
    var style: NewsStyle?
    
    var keyWords: [KeyWord] = [KeyWord]()
    
    var url: String?
    
    var type: NewsType
    var advType: BannerType?
    
    var dateForPaging: String?
    
    init(type: NewsType) {
        self.type = type
        super.init()
    }
    
    func update(_ dic: [String: Any]) {
        id = dic.nullableInt("id")
        channel = dic.nullableString("newsChannelId")
        industryId = dic.nullableString("industryId")
        tag.name = dic.nullableString("tagName")
        tag.type = dic.nullableString("tagType")
        
        coverImage = dic.nullableString("coverImg")
        title = dic.nullableString("title")
        introduction = dic.nullableString("introduction")
        
        publishDate = dic.nullableDate("publishAt")
        dateForPaging = dic.nullableString("publishAt")
        
        if let str = dic.nullableString("reqType") {
            style = NewsStyle(rawValue: str)
        }
        
        shareInfo = dic["shareData"] as? [String: Any]
        
        if let arr = dic["keywords"] as? [[String: Any]] {
            keyWords.removeAll()
            for dic in arr {
                let keyword = KeyWord()
                keyword.content = dic.nullableString("keyword")
                keyword.id = dic.nullableString("id")
                keyWords.append(keyword)
            }
        }
        
        author = dic.nullableString("author")
        
        url = dic.nullableString("detailUrl")
        
        advType = nil
        if let t = dic.nullableString("advType") {
            advType = BannerType(rawValue: t)
        }

        if let type = advType {
            if type == .news {
                self.type = .news
            } else if type == .report {
                self.type = .report
            }
        }
        
    }
}
