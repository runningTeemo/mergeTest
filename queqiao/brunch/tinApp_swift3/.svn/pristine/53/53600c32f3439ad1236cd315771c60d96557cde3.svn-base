//
//  Banner.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum BannerType: String {
    case news = "news"
    case report = "report"
}

/// 首页条幅的模型
class Banner: NSObject {
    
    var id: String!
    var name: String?
    var desc: String?
    
    var picture: String?
    var url: String?
    
    var subName: String?
    
    var locImage: String?
    
    var type: BannerType?
    
    var shareInfo: [String: Any]?
    
    func hasUrl() -> Bool {
        return url != nil
    }
    
    func checkOrMakeNews() -> News? {
        if let type = type {
            if type == .news {
                let news = News(type: .news)
                news.id = (SafeUnwarp(id, holderForNull: "") as NSString).integerValue
                news.url = url
                news.shareInfo = shareInfo
                return news
            } else if type == .report {
                let news = News(type: .report)
                news.id = (SafeUnwarp(id, holderForNull: "") as NSString).integerValue
                news.url = url
                news.shareInfo = shareInfo
                return news
            }
        }
        return nil
    }
    
    func update(_ dic: [String: Any]) {
        id = dic.nullableString("id")
        name = dic.nullableString("name")
        desc = dic.nullableString("description")
        picture = dic.nullableString("imgUrl")
        url = dic.nullableString("link")
        
        shareInfo = dic["shareData"] as? [String: Any]

        type = nil
        if let t = dic.nullableString("type") {
            type = BannerType(rawValue: t)
        }
    }
    
}
