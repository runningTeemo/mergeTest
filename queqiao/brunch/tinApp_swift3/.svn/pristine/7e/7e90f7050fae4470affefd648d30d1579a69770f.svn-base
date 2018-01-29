//
//  EnterpriseCueDataModel.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/24.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum cueEventType :String{
    case exite = "exite"
    case invest = "invest"
    case merger = "merger"
}

class EnterpriseCueDataModel: RootDataModel,DictModelProtocol {
    var id:String?
    var logoUrl:String?
    var shortCnName:String?
    var cnName:String?
    var industryName:String?
    var list:String?
    var setUpTime:String?
    var stocks:[StockDataModel]?
    var events:[RootEventDataModel]?
    static func customClassMapping() -> [String : String]? {
        return ["stocks":"StockDataModel","events":"RootEventDataModel"]
    }
    
    func parseEventsModel(investEvents:[Dictionary<String, AnyObject>]){
        for i in 0..<investEvents.count {
            if events?[i].objectType == cueEventType.exite.rawValue {
                let dic = investEvents[i]
                let model = ExitEventViewModel.objectWithKeyValues(dic as NSDictionary) as! ExitEventDataModel
                events?[i] = model
            }else if events?[i].objectType == cueEventType.invest.rawValue {
                let dic = investEvents[i]
                let model = InvestEventDataModel.objectWithKeyValues(dic as NSDictionary) as! InvestEventDataModel
                events?[i] = model
            }else if events?[i].objectType == cueEventType.merger.rawValue {
                let dic = investEvents[i]
                let model = MergerDataModel.objectWithKeyValues(dic as NSDictionary) as! MergerDataModel
                events?[i] = model
            }
            
        }
    }
}
