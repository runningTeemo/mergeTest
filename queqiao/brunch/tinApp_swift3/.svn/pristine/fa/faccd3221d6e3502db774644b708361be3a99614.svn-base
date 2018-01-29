//
//  CommonSearchManager.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias NetWorkSearchResultSuccess = (_ code: Int, _ msg: String, _ result: MainSearchResultsItem?) -> ()
typealias NetWorkSearchTipsSuccess = (_ code: Int, _ msg: String, _ tips: [SearchTip]?, _ summits: [SearchTipSummit]?, _ totalCount: Int?) -> ()
typealias NetWorkSearchOrganisationTipsSuccess = (_ code: Int, _ msg: String, _ tips: [Organization]?, _ totalCount: Int?) -> ()
typealias NetWorkSearchTypeResultSuccess = (_ code: Int, _ msg: String, _ arr: [[String: Any]]?, _ totalCount: Int?) -> ()

class CommonSearchManager {
    static let shareInstance = CommonSearchManager()
    
    func searchOrganisationTips(key: String, type: OrganizationType, success: @escaping NetWorkSearchOrganisationTipsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("kw", value: key, holderForNull: "")
        dic.append("reqFromCode", notNullValue: 0)
        dic.append("category", value: type.rawValue, holderForNull: 0)
        NetWork.shareInstance.get(.cvSource, "mobile/tip1.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var tips = [Organization]()
                var totalCount: Int = 0
                if let dic = data as? [String: Any] {
                    if let arr = dic["data"] as? [[String: Any]] {
                        for dic in arr {
                            let tip = Organization()
                            tip.update(dic: dic)
                            tip.updateAttri(key)
                            tips.append(tip)
                        }
                    }
                    totalCount = SafeUnwarp(dic.nullableInt("totalCount"), holderForNull: 0)
                }
                success(code, message, tips, totalCount)
            } else {
                success(code, message, nil, nil)
            }
        }, failed: failed)
    }
    
    
    func search(_ key: String, success: @escaping NetWorkSearchResultSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("kw", value: key, holderForNull: "")
        dic.append("reqFromCode", notNullValue: 0)
        NetWork.shareInstance.get(.cvSource, "mobile/search/full.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                let result = MainSearchResultsItem()
                if let dic = data as? [String: Any] {
                    result.update(dic)
                }
                success(code, message, result)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    func searchTip(user: User, key: String, commonSearch: Bool, success: @escaping NetWorkSearchTipsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("kw", value: key, holderForNull: "")
        dic.append("reqFromCode", notNullValue: 0)
        dic.append("category", notNullValue: commonSearch ? -2 : -4)
        dic.append("userId", value: user.id, holderForNull: "")
        
        NetWork.shareInstance.get(.cvSource, "mobile/tip2.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var summits = [SearchTipSummit]()
                var tips = [SearchTip]()
                var totalCount: Int = 0
                var eventsCount: Int = 0
                if let dic = data as? [String: Any] {
                    
                    if commonSearch {
                        
                        if let arr = dic["top"] as? [[String: Any]] {
                            for dic in arr {
                                let summit = SearchTipSummit()
                                summit.update(dic)
                                if let type = summit.type {
                                    if type == .invest || type == .merge || type == .exsit {
                                        eventsCount += summit.count
                                    } else {
                                        if summit.count > 0 {
                                            summits.append(summit)
                                        }
                                    }
                                }
                            }
                        }
                        if eventsCount > 0 {
                            let summit = SearchTipSummit()
                            summit.count = eventsCount
                            summit.tipword = "事件"
                            summit.type = .combine
                            if summit.count > 0 {
                                summits.append(summit)
                            }
                        }
                        if let arr = dic["data"] as? [[String: Any]] {
                            for dic in arr {
                                let tip = SearchTip()
                                tip.update(dic)
                                tip.updateAttri(key)
                                tips.append(tip)
                            }
                        }
                        totalCount = SafeUnwarp(dic.nullableInt("totalCount"), holderForNull: 0)
                        
                    } else {
                        
                        if let arr = dic["top"] as? [[String: Any]] {
                            for dic in arr {
                                let summit = SearchTipSummit()
                                summit.update(dic)
                                if let type = summit.type {
                                    if
                                        type == .article_normal ||
                                            //type == .article_manpower ||
                                            //type == .article_activity ||
                                            type == .article_project {
                                        //if summit.count > 0 {
                                        summits.append(summit)
                                        //}
                                    }
                                }
                            }
                        }
                        
                        if let arr = dic["data"] as? [[String: Any]] {
                            for dic in arr {
                                let tip = SearchTip()
                                tip.update(dic)
                                tip.updateAttri(key)
                                tips.append(tip)
                            }
                        }
                        totalCount = SafeUnwarp(dic.nullableInt("totalCount"), holderForNull: 0)
                        
                    }
                    
                }
                success(code, message, tips, summits, totalCount)
            } else {
                success(code, message, nil, nil, nil)
            }
        }, failed: failed)
    }
    
    func search(_ key: String, type: SearchType, start: Int, rows: Int, success: @escaping NetWorkSearchTypeResultSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("kw", value: key, holderForNull: "")
        dic.append("reqFromCode", notNullValue: 0)
        dic.append("start", value: start, holderForNull: 0)
        dic.append("rows", value: rows, holderForNull: 0)
        dic.append("category", value: type.rawValue, holderForNull: 0)
        NetWork.shareInstance.get(.cvSource, "mobile/search/category.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var count: Int = 0
                var arr: [[String: Any]] = [[String: Any]]()
                if let dic = data as? [String: Any] {
                    if let arr1 = dic["items"] as? [[String: Any]] {
                        arr = arr1
                    }
                    count = SafeUnwarp(dic.nullableInt("totalCount"), holderForNull: 0)
                }
                success(code, message, arr, count)
            } else {
                success(code, message, nil, nil)
            }
        }, failed: failed)
    }
    
}
