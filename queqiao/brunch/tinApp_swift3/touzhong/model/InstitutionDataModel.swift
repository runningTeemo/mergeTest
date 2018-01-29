//
//  InstitutionDataModel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionDataModel: RootDataModel,DictModelProtocol{
    var id:String?
    var shortCnName:String?//简称
    var user:PersonageDataModel?//
    var cnName:String?//全称
    var setUpTime:String?//成立时间
    var logoUrl:String?
    var insType:String?//机构类型
    var capitalFrom:String?//资本来源
    var institutionFieldList:[InstitutionFieldDataModel]?//所属行业
    var amount:String?
    var followCount:String?//关注个数
    var users:[PersonageDataModel]?
    var openInvest:String?//开放投资
    var webSite:String?//网址
    var enName:String?
    var lastestEventLabel:AimedEnterpriseDataModel?
    var hotestEventLabel:AimedEnterpriseDataModel?
    var funds:[Funds]?//管理基金
    var desc:String?//描述
    var capitalAmount:String?//管理资金
    var currencyType:String?
    var capitalAmountUs:String?
    var analysis:[String]?
    var contact:[Contact]?
    var investmentCount:String?//投资个数
    var exitCount:String?//退出事件个数
    static func customClassMapping() -> [String : String]? {
        return ["institutionFieldList":"InstitutionFieldDataModel","users":"PersonageDataModel","funds":"Funds","contact":"Contact"/*,"exits":"ExitEventDataModel","investments":"InvestEventDataModel"*/]
    }
}

class InstitutionFieldDataModel: RootDataModel {
    
    var id:String?
    var name:String?
    
}
class Contact:RootModel{
  //  var id:String?
    var contacter:String?//联系人
    var tel:String?//电话
    var email:String?//email
    var zipCode:String?//邮编
    var fax:String?
    var address:String?//地址
}
class Funds: RootModel {
//    var id: String?
    var cnName: String?
    var shortCnName:String?
    var fundType:String?
}


