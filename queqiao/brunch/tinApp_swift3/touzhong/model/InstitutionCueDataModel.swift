//
//  InstitutionCueDataModel.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionCueDataModel: RootDataModel,DictModelProtocol {

    var id:String?
    var cnName:String?
    var shortCnName:String?
    var setUpTime:String?
    var logoUrl:String?
    var insType:String?
    var capitalFrom:String?
    var investEvents:[RootEventDataModel]?
    static func customClassMapping() -> [String : String]? {
        return ["investEvents":"RootEventDataModel"]
    }
    func parseEventsModel(investEvents:[Dictionary<String, AnyObject>]){
        for i in 0..<investEvents.count {
            if self.investEvents?[i].objectType == cueEventType.exite.rawValue {
                let dic = investEvents[i]
                let model = ExitEventDataModel.objectWithKeyValues(dic as NSDictionary) as! ExitEventDataModel
                self.investEvents?[i] = model
            }else if self.investEvents?[i].objectType == cueEventType.invest.rawValue {
                let dic = investEvents[i]
                let model = InvestEventDataModel.objectWithKeyValues(dic as NSDictionary) as! InvestEventDataModel
                self.investEvents?[i] = model
            }else if self.investEvents?[i].objectType == cueEventType.merger.rawValue {
                let dic = investEvents[i]
                let model = MergerDataModel.objectWithKeyValues(dic as NSDictionary) as! MergerDataModel
                self.investEvents?[i] = model
            }
            
        }
    }
    
}
