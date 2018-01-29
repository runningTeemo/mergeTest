//
//  SearchTip.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/10.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum SearchType: Int {
    case enterprise = 0 // 企业
    case institution = 1 // 机构
    case identity = 2 // 身份 /
    case person = 3 // 人物
    case funds = 4 // 基金 /
    case invest = 5 // 投资  -
    case merge = 6 // 并购 -
    case exsit = 7 // 退出 -
    case news = 8 // 新闻
    case report = 9 // 研究报告 /
    case meeting = 10 // 会议
    
    case combine = 101
    
    case article_all = 200
    case article_normal = 201 // 文章
    case article_manpower = 202 // 人才
    case article_activity = 203 // 活动
    case article_project = 204 // 项目
    
    func toString() -> String {
        switch self {
        case .enterprise: return "企业"
        case .institution: return "机构"
        case .identity: return "身份"
        case .person: return "人物"
        case .funds: return "基金"
        case .invest: return "投资"
        case .merge: return "并购"
        case .exsit: return "退出"
        case .news: return "新闻"
        case .report: return "研究报告"
        case .meeting: return "会议"
        case .combine: return "事件"
            
        case .article_all: return "发现"
        case .article_normal: return "文章"
        case .article_manpower: return "人才"
        case .article_activity: return "活动"
        case .article_project: return "项目"
            
        }
    }
}

/// 搜索出的个数提示模型
class SearchTipSummit: SearchTip {
    var tipword: String?
    override func update(_ dic: [String : Any]) {
        super.update(dic)
        tipword = dic.nullableString("tipWord")
    }
}

/// 搜索出的提示模型
class SearchTip {
    
    var type: SearchType?
    var count: Int = 0
    var content: String?
    var id: String?
    func update(_ dic: [String: Any]) {
        if let i = dic.nullableInt("category") {
            type = SearchType(rawValue: i)
        }
        
        count = SafeUnwarp(dic.nullableInt("count"), holderForNull: 0)
        id = dic.nullableString("id")
        content = dic.nullableString("cnName")
        if let title = dic.nullableString("title") {
            content = title
        }
    }
    
    fileprivate(set) var attriStr: NSAttributedString?
    func updateAttri(_ key: String) {
        if let text = content {
            let norDic = [
                NSForegroundColorAttributeName: kClrDarkGray,
                NSFontAttributeName: UIFont.systemFont(ofSize: 15)
            ]
            let keyDic = [
                NSForegroundColorAttributeName: kClrOrange,
                NSFontAttributeName: UIFont.systemFont(ofSize: 15)
            ]
            let mAttr = NSMutableAttributedString(string: text, attributes: norDic)
            let range = (text as NSString).range(of: key)
            mAttr.addAttributes(keyDic, range: range)
            attriStr = mAttr
        } else {
            attriStr = nil
        }
    }
    
}
