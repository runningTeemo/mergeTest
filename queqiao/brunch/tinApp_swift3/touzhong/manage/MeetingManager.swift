//
//  MeetingManager.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias NetWorkMeetingsSuccess = (_ code: Int, _ message: String, _ meetings: [Meeting]?) -> ()
typealias NetWorkMeetingTipsSuccess = (_ code: Int, _ message: String, _ tips: [MeetingTip]?) -> ()

class MeetingManager {
    
    static let shareInstance = MeetingManager()
    
    func getMeetingList(_ type: MeetingType?, sort: MeetingSort?, order: MeetingOrderBy?, weekDay: Bool?, weekEnd: Bool?, meetDate: String?,  keyWords: [String]?, addresses: [String]?, guests: [String]?, success: @escaping NetWorkMeetingsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("begin", value: 0)
        dic.checkOrAppend("end", value: 100)
        dic.checkOrAppend("size", value: 100)
        dic.checkOrAppend("totalRecords", value: 100)
        dic.checkOrAppend("pageNo", value: 0)
        dic.checkOrAppend("pageCount", value: 0)
        if let weekDay = weekDay {
            dic.checkOrAppend("weekDay", value: weekDay ? 1 : 2)
        }
        if let weekEnd = weekEnd {
            dic.checkOrAppend("weekEnd", value: weekEnd ? 1 : 2)
        }
        dic.checkOrAppend("sort", value: sort?.rawValue)
        dic.checkOrAppend("orderBy", value: order?.rawValue)
        dic.checkOrAppend("searchType", value: type?.rawValue)
        dic.checkOrAppend("meetDay", value: meetDate)
        
        dic.checkOrAppend("keyWordList", value: keyWords)
        dic.checkOrAppend("addressList", value: addresses)
        dic.checkOrAppend("guestList", value: guests)
        
        NetWork.shareInstance.post(.cvSource, "mobile/meet/list.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var meetings = [Meeting]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let meeting = Meeting()
                        meeting.update(dic)
                        meetings.append(meeting)
                    }
                }
                success(code, message, meetings)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
        
    }
    
    /// 暂时用这个
    func getMeetingListNew(_ dateForPaging: String?, rows: Int, keyword: String?, type: MeetingType?, sort: MeetingSort?, order: MeetingOrderBy?, weekDay: Bool?, weekEnd: Bool?, meetDate: String?,  addresses: [String]?, guests: [String]?, success: @escaping NetWorkMeetingsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("publishAt", value: dateForPaging)
        dic.checkOrAppend("rows", value: rows)
        dic.checkOrAppend("sortType", value: sort?.rawValue)
        if let weekDay = weekDay {
            dic.checkOrAppend("weekDay", value: weekDay ? 1 : 2)
        }
        if let weekEnd = weekEnd {
            dic.checkOrAppend("weekEnd", value: weekEnd ? 1 : 2)
        }
        dic.checkOrAppend("startDate", value: meetDate)
        
        dic.checkOrAppend("orderBy", value: order?.rawValue)
        dic.checkOrAppend("keyword", value: keyword)
        
        dic.checkOrAppend("addressList", value: addresses)
        dic.checkOrAppend("guestList", value: guests)
        
        NetWork.shareInstance.post(.cvSource, "mobile/meet/list.do", params: dic, success: { (code, message, data) in
            if code == 0 || code == 1001 {
                var meetings = [Meeting]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let meeting = Meeting()
                        meeting.update(dic)
                        meetings.append(meeting)
                    }
                }
                success(code, message, meetings)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
        
    }
    
    func getTouInMeetingList(_ success: @escaping NetWorkMeetingsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("begin", value: 0)
        dic.checkOrAppend("end", value: 100)
        //dic.checkOrAppend("size", value: 100)
        //dic.checkOrAppend("totalRecords", value: 100)
        //dic.checkOrAppend("pageNo", value: 0)
        //dic.checkOrAppend("pageCount", value: 0)
        dic.checkOrAppend("type", value: 4)
        NetWork.shareInstance.post(.cvSource, "mobile/meet/cvMeet.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var meetings = [Meeting]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let meeting = Meeting()
                        meeting.update(dic)
                        meetings.append(meeting)
                    }
                }
                success(code, message, meetings)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    func getBanners(_ success: @escaping NetWorkBannersSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("begin", value: 0)
        dic.checkOrAppend("end", value: 4)
        dic.checkOrAppend("size", value: 5)
        dic.checkOrAppend("totalRecords", value: 5)
        dic.checkOrAppend("pageNo", value: 0)
        dic.checkOrAppend("pageCount", value: 1)
        NetWork.shareInstance.post(.cvSource, "mobile/meet/headList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var banners = [Banner]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let banner = Banner()
                        banner.update(dic)
                        banners.append(banner)
                    }
                }
                success(code, message, banners)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    func getTopics(_ success: @escaping NetWorkMeetingTipsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("begin", value: 0)
        dic.checkOrAppend("end", value: 14)
        NetWork.shareInstance.post(.cvSource, "mobile/meet/tagList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var tips = [MeetingTip]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let tip = MeetingTip()
                        tip.update(dic)
                        tips.append(tip)
                    }
                }
                success(code, message, tips)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    func getGuests(_ success: @escaping NetWorkMeetingTipsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("begin", value: 0)
        dic.checkOrAppend("end", value: 14)
        NetWork.shareInstance.post(.cvSource, "mobile/meet/guestList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var tips = [MeetingTip]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let tip = MeetingTip()
                        tip.update(dic)
                        tips.append(tip)
                    }
                }
                success(code, message, tips)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    
}
