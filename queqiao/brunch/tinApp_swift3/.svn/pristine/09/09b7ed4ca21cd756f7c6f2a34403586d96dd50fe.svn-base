//
//  Organisation.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum OrganizationType: Int {
    case company = 0
    case institution = 1
    case combine = -3
    func toString() -> String {
        switch self {
        case .company:
            return "企业"
        case .institution:
            return "机构"
        case .combine:
            return "混合"
        }
    }
}

class Organization {
    var type: OrganizationType?
    var id: Int?
    var name: String?
    func update(dic: [String: Any]) {
        if let n = dic.nullableInt("category") {
            type = OrganizationType(rawValue: n)
        }
        id = dic.nullableInt("id")
        name = dic.nullableString("tipWord")
        // category==-3: 表示同时补全机构和企业，
        // category== 0 : 只补充企业名
        // category== 1 : 只补充机构名
        // 返回参数新增cnName，shortCnName，
    }
    
    fileprivate(set) var attriStr: NSAttributedString?
    func updateAttri(_ key: String) {
        if let text = name {
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
