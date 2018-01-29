//
//  LocationPickerEntry.swift
//  LocationPickerEntryDemo
//
//  Created by Richard.q.x on 2016/11/28.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import Foundation

class LocationModel {
    var id: String?
    var name: String?
    var childrens: [LocationModel]?
    func update(dic: [String: Any]) {
        id = dic.nullableString("id")
        name = dic.nullableString("name_cn")
        if let arr = dic["children"] as? [[String: Any]] {
            var childrens = [LocationModel]()
            for dic in arr {
                let children = LocationModel()
                children.update(dic: dic)
                childrens.append(children)
            }
            self.childrens = childrens
        }
    }
    var pinYin: String?
}

class LocationPinYinGroupModel {
    let pinYinFirstChar: String
    var arr: [LocationModel] = [LocationModel]()
    required init(pinYinFirstChar: String) {
        self.pinYinFirstChar = pinYinFirstChar
    }
}

class LocationDataEntry {
    
    static let hotCityNames = ["上海", "北京", "广州", "深圳", "武汉", "天津", "西安", "南京", "杭州", "成都" ,"重庆"]
    static let directCityNames = ["北京", "上海", "天津", "重庆"]
    
    static let sharedOne = LocationDataEntry()
    
    lazy var allModels: [LocationModel] = LocationDataEntry._getAllModels()
    
    lazy var modelsWithoutChina: [LocationModel] = {
        var one = [LocationModel]()
        for model in self.allModels {
            if model.name != "中国" {
                one.append(model)
            }
        }
        return one
    }()
    lazy var modelsWithoutChinaGroups: [LocationPinYinGroupModel] = {
        var modelsWithoutChina = self.modelsWithoutChina
        for modelWithoutChina in modelsWithoutChina {
            modelWithoutChina.pinYin = LocationDataEntry._getPinYin(modelWithoutChina.name)
        }
        modelsWithoutChina.sort { (a, b) -> Bool in
            if a.pinYin != nil && b.pinYin != nil {
                return a.pinYin! < b.pinYin!
            }
            return true
        }
        var lastChar: String = ""
        var group: LocationPinYinGroupModel!
        var groups = [LocationPinYinGroupModel]()
        for modelWithoutChina in modelsWithoutChina {
            var char = "*"
            if let c = LocationDataEntry._getPinYinFirstLetter(modelWithoutChina.pinYin) {
                char = c
            }
            if lastChar != char {
                lastChar = char
                group = LocationPinYinGroupModel(pinYinFirstChar: char)
                group.arr.append(modelWithoutChina)
                groups.append(group)
            } else {
                group.arr.append(modelWithoutChina)
            }
            lastChar = char
        }
        return groups
    }()
    
    lazy var chinaModel: LocationModel = {
        let one = LocationModel()
        one.name = "中国"
        for model in self.allModels {
            if model.name == "中国" {
                return model
            }
        }
        return one
    }()
    
    var currentCity: LocationModel?
    func tryGetCurrentCity() {
        if let mark = LocationGetter.shareOne.currentMark {
            currentCity = _tryGetLocation(mark: mark)
        }
    }
    func _tryGetLocation(mark: CLPlacemark) -> LocationModel? {
        if let code = mark.isoCountryCode {
            if code == "CN" || code == "cn" {
                if let city = mark.locality {
                    return LocationDataEntry.sharedOne.searchChinaCity(name: city)
                }
            } else {
                if let country = mark.country {
                    return LocationDataEntry.sharedOne.searchCountry(name: country)
                }
            }
        }
        return nil
    }
    
    func searchChinaCity(name: String) -> LocationModel? {
        _searchChinaCityResult = nil
        if name.characters.count < 1 { return nil }
        var _name = name
        if name.substring(from: name.index(before: name.endIndex)) == "市" {
            _name = name.substring(to: name.index(before: name.endIndex))
        }
        _searchChinaCity(name: _name, inLoc: chinaModel)
        return _searchChinaCityResult
    }
    private var _searchChinaCityResult: LocationModel?
    func _searchChinaCity(name: String, inLoc: LocationModel) {
        if let childrens = inLoc.childrens, childrens.count > 0 {
            for loc in childrens {
                _searchChinaCity(name: name, inLoc: loc)
            }
        } else {
            if let _name = inLoc.name {
                if _name.contains(name) {
                    _searchChinaCityResult = inLoc
                }
            }
        }
    }
    
    func searchCountry(name: String) -> LocationModel? {
        for model in modelsWithoutChina {
            if let _name = model.name {
                if _name.contains(name) {
                    return model
                }
            }
            
        }
        return nil
    }
    
    class func _getAllModels() -> [LocationModel] {
        let path = Bundle.main.path(forResource: "locations", ofType: "json")!
        let data = NSData(contentsOfFile: path) as! Data
        var models = [LocationModel]()
        do {
            let jsonArr = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

            if let arr = jsonArr as? [[String: Any]] {
                for dic in arr {
                    let model = LocationModel()
                    model.update(dic: dic)
                    models.append(model)
                }
            }
        } catch {
            print(error)
        }
        return models
    }
    
    private class func _getPinYin(_ text: String?) -> String? {
        if let text = text {
            let mText = NSMutableString(string: text) as CFMutableString
            if CFStringTransform(mText, nil, kCFStringTransformMandarinLatin, false) {
                if CFStringTransform(mText, nil, kCFStringTransformStripDiacritics, false) {
                    return mText as String
                }
            }
        }
        return nil
    }
    private class func _getPinYinFirstLetter(_ text: String?) -> String? {
        if let text = text {
            if text.characters.count > 0 {
                return "\(text.characters.first!)".uppercased()
            }
        }
        return nil
    }
    
}
