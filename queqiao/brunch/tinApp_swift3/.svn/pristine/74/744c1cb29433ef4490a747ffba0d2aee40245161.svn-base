//
//  AticleProjectDataModel.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class AticleProjectDataModel: RootDataModel ,DictModelProtocol{
    var userType:String?
    var companyType:String?
    var name:String?
    var subjectId:String?
    var subjectName:String?
    var projectRelation:String?
    var signedIssue:String?
    var commission:String?
    var currentRound:String?
    var lastRound:String?
    var currency:String?
    var amount:String?
    var investStockRatio:String?
    var isDetailPublic:String?
    var isSpeaker:String?
    var desc:String?
    var industry:[Industry]?
    var imgList:[AticleImageModel]?
    static func customClassMapping() -> [String : String]? {
        return ["industry":"Industry","imgList":"AticleImageModel"]
    }
}

class AticleImageModel:RootModel{
    var oUrl:String?
    var sUrl:String?
}

