//
//  InvestEvent.swift
//  touzhong
//
//  Created by zerlinda on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InvestEventDataModel: RootEventDataModel,DictModelProtocol{

    var eventId:String?
    var amount:String?
    var happenDate:String?
    var round:String?
    var eventTitle:String?
    var desc:String?
    var category:String?
    var growth:String?
    var currencyType:String?
    var aimedEnterprise:AimedEnterpriseDataModel?
    var investInstitutionList:[InstitutionDataModel]?
    
    
    static func customClassMapping() -> [String : String]? {
        return ["investInstitutionList":"InstitutionDataModel"]
    }
    
}

class AimedEnterpriseDataModel:RootDataModel,DictModelProtocol{
    
    var id:String?
    var shortCnName:String?
    var cnName:String?
    var industry:[IndustryDataModel]?
    
    static func customClassMapping() -> [String : String]? {
        return ["investInstitutionList":"InstitutionDataModel"]
    }
}
