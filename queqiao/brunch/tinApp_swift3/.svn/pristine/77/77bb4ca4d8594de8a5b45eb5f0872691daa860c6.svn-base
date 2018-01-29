//
//  RankManager.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias NetWorkRankListsSuccess = (_ code: Int, _ msg: String, _ lists: [RankList]?) -> ()
typealias NetWorkSubRankListsSuccess = (_ code: Int, _ msg: String, _ lists: [SubRankList]?) -> ()
typealias NetWorkRankDetailsSuccess = (_ code: Int, _ msg: String, _ details: [RankDetail]?) -> ()

class RankManager {
    
    static let shareInstance = RankManager()
    
    func getRankLists(_ success: @escaping NetWorkRankListsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("begin", value: 0)
        dic.checkOrAppend("end", value: 19)
        NetWork.shareInstance.post(.cvSource, "mobile/rank/oneLevel.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var lists = [RankList]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let year = dic.nullableInt("rankYear")
                        if let arr = dic["rankList"] as? [[String: Any]] {
                            for dic in arr {
                                let list = RankList()
                                list.update(dic)
                                list.year = year
                                lists.append(list)
                            }
                        }
                    }
                }
                success(code, message, lists)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
        
    }
    
    /// begin 从0开始
    func getSubRankList(_ rankId: Int, type: RankType?, begin: Int, success: @escaping NetWorkSubRankListsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("rankId", value: rankId)
        dic.checkOrAppend("begin", value: begin)
        dic.checkOrAppend("end", value: begin + 19)
        dic.checkOrAppend("type", value: type?.rawValue)
        NetWork.shareInstance.post(.cvSource, "mobile/rank/twoLevel.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var lists = [SubRankList]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let list = SubRankList()
                        list.update(dic)
                        lists.append(list)
                    }
                }
                success(code, message, lists)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    func getRankDetail(_ rankId: Int, type: RankType?, begin: Int, success: @escaping NetWorkRankDetailsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("rankId", value: rankId)
        dic.checkOrAppend("begin", value: begin)
        dic.checkOrAppend("end", value: begin + 19)
        dic.checkOrAppend("type", value: type?.rawValue)
        NetWork.shareInstance.post(.cvSource, "mobile/rank/threeLevel.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var details = [RankDetail]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let detail = RankDetail()
                        detail.update(dic)
                        detail.rankType = type
                        details.append(detail)
                    }
                }
                success(code, message, details)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    
}
