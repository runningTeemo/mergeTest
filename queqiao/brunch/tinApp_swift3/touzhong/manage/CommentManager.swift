//
//  CommentManager.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias NetWorkNewsCommentsSuccess = (_ code: Int, _ msg: String, _ comments: [NewsComment]?, _ pageInfo: WebPage?) -> ()
typealias NetWorkNewsCommentGroupsSuccess = (_ code: Int, _ msg: String, _ groups: [NewsCommentGroup]?, _ pageInfo: WebPage?) -> ()

class CommentManager {
    
    static let shareInstance = CommentManager()
    
    func getNewsDetail(_ type: NewsType, userId: String?, newsId: Int, success: @escaping ((_ code: Int, _ message: String, _ commentCount: Int, _ isFav: Bool) -> ()), failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: userId, holderForNull: "")
        dic.append("newsId", value: newsId, holderForNull: "")
        if type == .news {
            dic.append("targetType", notNullValue: "news")
        } else {
            dic.append("targetType", notNullValue: "report")
        }
        NetWork.shareInstance.get(.userCenter, "uc/mobile/news/prop", params: dic, success: { (code, message, data) in
            if code == 0 {
                var commentCount: Int = 0
                var isFav: Bool = false
                if let dic = data as? [String: Any] {
                    if let i = dic.nullableInt("commentCount") {
                        commentCount = i
                    }
                    if let b = dic.nullableBool("fav") {
                        isFav = b
                    }
                }
                success(code, message, commentCount, isFav)
            } else {
                success(code, message, 0, false)
            }
        }, failed: failed)
    }
    
    /// targetId 可为新闻id或评论id，userId 为nil表示匿名，replayUserId 为回复的人的id
    func saveComment(_ type: NewsType, userId: String?, replayUserId: String?, targetId: String, content: String, newsBref: String?, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("userid", value: userId)
        dic.checkOrAppend("targetid", value: targetId)
        dic.checkOrAppend("content", value: content)
        dic.checkOrAppend("targetuserid", value: replayUserId)
        if type == .news {
            dic.checkOrAppend("targettype", value: "news")
        } else {
            dic.checkOrAppend("targettype", value: "report")
        }
        dic.checkOrAppend("targetcontent", value: newsBref)
        
        NetWork.shareInstance.post(.userCenter, "user/comment/save", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    
    func getCommentList(_ type: NewsType, targetId: Int, pageIndex: Int, pageSize: Int, success: @escaping NetWorkNewsCommentsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("targetid", value: targetId, holderForNull: 0)
        if type == .news {
            dic.append("targettype", notNullValue: "news")
        } else {
            dic.append("targettype", notNullValue: "report")
        }
        dic.append("pageIndex", notNullValue: pageIndex)
        dic.append("pageSize", notNullValue: pageSize)
        
        NetWork.shareInstance.get(.cvSource, "mobile/uc/comment/list.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var comments: [NewsComment] = [NewsComment]()
                var page: WebPage?
                if let dic = data as? [String: Any] {
                    if let pageDic = dic["pageInfo"] as? [String: Any] {
                        let _page = WebPage(
                            pageIndex: pageDic.nullableInt("pageIndex"),
                            pageSize: pageDic.nullableInt("pageSize"),
                            pageCount: pageDic.nullableInt("totalPage"),
                            total: pageDic.nullableInt("totalCount"))
                        page = _page
                    }
                    if let arr = dic["dataList"] as? [[String: Any]] {
                        for dic in arr {
                            let comment = NewsComment()
                            comment.update(dic)
                            comments.append(comment)
                        }
                    }
                }
                success(code, message, comments, page)
            } else {
                success(code, message, nil, nil)
            }
        }, failed: failed)
    }
    
    func getCommentGroupList(_ type: NewsType, targetId: Int, pageIndex: Int, pageSize: Int, success: @escaping NetWorkNewsCommentGroupsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("targetid", value: targetId, holderForNull: 0)
        if type == .news {
            dic.append("targettype", notNullValue: "news")
        } else {
            dic.append("targettype", notNullValue: "report")
        }
        dic.append("pageIndex", notNullValue: pageIndex)
        dic.append("pageSize", notNullValue: pageSize)
        
        NetWork.shareInstance.get(.cvSource, "mobile/uc/comment/list/group.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var groups: [NewsCommentGroup] = [NewsCommentGroup]()
                var page: WebPage?
                if let dic = data as? [String: Any] {
                    if let pageDic = dic["pageInfo"] as? [String: Any] {
                        let _page = WebPage(
                            pageIndex: pageDic.nullableInt("pageIndex"),
                            pageSize: pageDic.nullableInt("pageSize"),
                            pageCount: pageDic.nullableInt("totalPage"),
                            total: pageDic.nullableInt("totalCount"))
                        page = _page
                    }
                    if let arr = dic["dataList"] as? [[String: Any]] {
                        for dic in arr {
                            let group = NewsCommentGroup()
                            group.update(dic)
                            groups.append(group)
                        }
                    }
                }
                success(code, message, groups, page)
            } else {
                success(code, message, nil, nil)
            }
        }, failed: failed)
    }
    
    
    func agree(user: User?, targetId: String, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("targetid", value: targetId)
        dic.checkOrAppend("userid", value: user?.id)
        NetWork.shareInstance.post(.userCenter, "user/like/save", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
}
