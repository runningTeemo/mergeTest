//
//  Picture.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class Picture: NSObject {
    
    var url: String?
    var thumbUrl: String?
    
    func update(_ dic: [String: Any]) {
        url = dic.nullableString("oUrl")
        thumbUrl = dic.nullableString("sUrl")
    }
    
    func toDicOld() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("oUrl", value: url)
        dic.checkOrAppend("sUrl", value: thumbUrl)
        return dic
    }
    
}
