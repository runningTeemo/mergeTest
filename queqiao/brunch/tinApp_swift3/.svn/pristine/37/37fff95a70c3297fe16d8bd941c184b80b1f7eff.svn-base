//
//  PositionsDataEntry.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class PositionModel {
    var id: String?
    var name: String?
    var childrens: [PositionModel] = [PositionModel]()
    func update(dic: [String: Any]) {
        id = dic.nullableString("id")
        name = dic.nullableString("name")
        if let arr = dic["children"] as? [[String: Any]] {
            var childrens = [PositionModel]()
            for dic in arr {
                let children = PositionModel()
                children.update(dic: dic)
                childrens.append(children)
            }
            self.childrens = childrens
        }
    }
}

class PositionsDataEntry {
    
    static let sharedOne = PositionsDataEntry()

    lazy var models: [PositionModel] = {
        let one = PositionsDataEntry._getAllModels()
        return one
    }()
    
    
    class func _getAllModels() -> [PositionModel] {
        let path = Bundle.main.path(forResource: "positions", ofType: "json")!
        let data = NSData(contentsOfFile: path) as! Data
        var models = [PositionModel]()
        do {
            let jsonArr = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let arr = jsonArr as? [[String: Any]] {
                for dic in arr {
                    let model = PositionModel()
                    model.update(dic: dic)
                    models.append(model)
                }
            }
        } catch {
            print(error)
        }
        return models
    }
    
}
