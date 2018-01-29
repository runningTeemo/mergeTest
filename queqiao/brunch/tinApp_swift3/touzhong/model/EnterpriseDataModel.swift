//
//  EnterpriseModel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

 class EnterpriseDataModel: NSObject {//企业列表和企业详情公用此model
    var id : String?
    var shortCnName : String?
    var cnName : String?
    var industry:[IndustryDataModel]?
    var setUpTime : String?//成立时间
    var regLocation : String?
    var financingCount : String?
    var happenDate : String?
    var investRound : String?{
        didSet{

        }
    }
    var logoUrl : String?
    var enName : String?
    var shortEnName : String?
    var followCount : String?
    var desc:String?
    var growth: String?
    var legalRep : String?//法人代表、管理者
    var website : String?
    var products : String?//相关产品
    var employCount: String?//规模
    var stocks:[StockDataModel]?
    var financingEvents:[InvestEventDataModel]?
    var mergerEvents:[MergerDataModel]?
    var list : String = "0"//是否上市
    var contact:[Contact]?
    
    static func customClassMapping() -> [String : String]? {
        return ["financingEvents":"InvestEventDataModel","mergerEvents":"MergerDataModel","stocks":"StockDataModel","contact":"Contact","industry":"IndustryDataModel"]
    }
}
class StockDataModel: RootModel {
    //var id:String?
    var stockCode:String?//股票代码
    var stockName:String?//股票名称
    var stockMess:String?//上市信息
    var stockExchange:String?//交易所信息
}

