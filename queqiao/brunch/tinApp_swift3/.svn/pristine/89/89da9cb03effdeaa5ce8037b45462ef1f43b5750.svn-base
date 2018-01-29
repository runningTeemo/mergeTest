//
//  MergerDataModel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MergerDataModel: RootEventDataModel,DictModelProtocol{
    var eventTitle:String?
    var eventId:String?
    var amount:String?
    var happenDate:String?
    var storkRight:String?
    var aimedEnterprise:AimedEnterpriseDataModel?
    var buyEnterpriseList:[BuyEnterpriseDataModel]?
    var desc:String?
    static func customClassMapping() -> [String : String]? {
        return ["buyEnterpriseList":"BuyEnterpriseDataModel"]
    }
}
class BuyEnterpriseDataModel: RootDataModel {
    var id:String?
    var shortCnName:String?
    var cnName:String?
    var amount:String?
    var buyStorkRight:String?
    var businessType:String = "0"//0代表买，1代表卖
}
