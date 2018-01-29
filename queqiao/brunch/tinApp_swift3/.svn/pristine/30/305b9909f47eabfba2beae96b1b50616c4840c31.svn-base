//
//  Circle.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class Circle {
    
    var industry: Industry = Industry()
    
    var isAttentioned: Bool?
    var userCount: Int?
    var articleCount: Int?
    
    var isParty: Bool =  false
    //var isReachedLimit: Bool = false
    
    func update(_ dic: [String : Any]) {
        isAttentioned = dic.nullableBool("concern")
        userCount = dic.nullableInt("memberCount")
        articleCount = dic.nullableInt("articleCount")
    }
    
    func updateSummarise(_ dic: [String : Any]) {
        self.industry.update(dic)
        userCount = dic.nullableInt("userNum")
        articleCount = dic.nullableInt("articleNum")
    }
    
    func updateUserIndustry(_ dic: [String : Any]) {
        self.industry.update(dic)
        if let t = dic.nullableString("type") {
            if t == "O" {
                isParty = true
            }
        }
    }
    
}
