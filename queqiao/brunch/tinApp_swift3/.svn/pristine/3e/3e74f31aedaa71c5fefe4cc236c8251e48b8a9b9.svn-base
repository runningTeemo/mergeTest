//
//  PersonageDataModel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PersonageDataModel: RootDataModel,DictModelProtocol {
    var cnName: String?
    var userId: String?
    var imgUrl: String?
    var enName: String?
    var duties: String?
    var companyName: String?
    var cnDescription: String?
    var followCount:String?//关注个数
    var quited:String?//是否离职
    var careers: [CareerDataModel]?
    var invests: [InvestEventDataModel]?
    
    static func customClassMapping() -> [String : String]? {
        return ["careers":"CareerDataModel","invests":"InvestEventDataModel"]
    }
}

