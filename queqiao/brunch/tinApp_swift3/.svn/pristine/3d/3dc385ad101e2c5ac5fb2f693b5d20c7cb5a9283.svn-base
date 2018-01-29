//
//  UserManager.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias NetWorkFriendRequestsSuccess = (_ code: Int, _ msg: String, _ requests: [FriendRequest]?) -> ()
typealias NetWorkUsersSuccess = (_ code: Int, _ msg: String, _ users: [User]?) -> ()

class UserManager: NSObject {
    
    static let shareInstance = UserManager()
    
    /// 获取用户详情
    func getUserDetail(user: User, targetUser: User, success: @escaping NetWorkUserDetailSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("targetUserId", value: targetUser.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/sns/getProfile.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                let userDetail = UserDetail()
                if let dic = data as? [String: Any] {
                    userDetail.update(dic)
                } else {
                    userDetail.user = user
                }
                success(code, message, userDetail)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    //    /// 获取用户评论（废弃，只返回八卦）
    //    func getUserComments(dateForPaging: String?, user: User, targetUser: User, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
    //        var dic = [String: Any]()
    //        dic.append("userId", value: user.id, holderForNull: "")
    //        dic.append("targetUserId", value: targetUser.id, holderForNull: "")
    //        dic.append("date", value: dateForPaging, holderForNull: "0")
    //        NetWork.shareInstance.get(.cvSource, "mobile/sns/getArticleCommentList.do", params: dic, success: { (code, message, data) in
    //            if code == 0 {
    //                var articles = [Article]()
    //                if let arr = data as? [[String: Any]] {
    //                    for dic in arr {
    //                        let article = Article()
    //                        article.update(dic)
    //                        articles.append(article)
    //                    }
    //                }
    //                success(code, message, articles)
    //            } else {
    //                success(code, message, nil)
    //            }
    //            }, failed: failed)
    //    }
    
    /// 获取用户评论
    func getUserComments(targetUser: User, start: Int, rows: Int, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: targetUser.id, holderForNull: "")
        dic.append("rows", notNullValue: rows)
        dic.append("start", notNullValue: start)
        //        dic.append("date", value: dateForPaging, holderForNull: "0")
        NetWork.shareInstance.get(.cvSource, "mobile/sns/getArticleCommentListByUserId.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var articles = [Article]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let article = Article()
                        article.update(dic)
                        articles.append(article)
                    }
                }
                success(code, message, articles)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    //    /// 获取用户文章（废弃，只返回八卦）
    //    func getUserArticles(dateForPaging: String?, user: User, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
    //        var dic = [String: Any]()
    //        dic.append("targetUserId", value: user.id, holderForNull: "")
    //        dic.append("date", value: dateForPaging, holderForNull: "0")
    //        NetWork.shareInstance.get(.cvSource, "mobile/sns/getArticleList.do", params: dic, success: { (code, message, data) in
    //            if code == 0 {
    //                var articles = [Article]()
    //                if let arr = data as? [[String: Any]] {
    //                    for dic in arr {
    //                        let article = Article()
    //                        article.updateBrief(dic)
    //                        articles.append(article)
    //                    }
    //                }
    //                success(code, message, articles)
    //            } else {
    //                success(code, message, nil)
    //            }
    //            }, failed: failed)
    //    }
    
    /// 获取用户文章
    func getUserArticles(dateForPaging: String?, user: User, targetUser: User, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("targetUserId", value: targetUser.id, holderForNull: "")
        dic.append("rows", notNullValue: 10)
        dic.append("publishAt", value: dateForPaging, holderForNull: "0")
        dic.append("reqFromCode", notNullValue: 0)
        NetWork.shareInstance.post(.cvSource, "mobile/home/getArticleListNew.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var articles = [Article]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let article = Article()
                        article.update(dic)
                        articles.append(article)
                    }
                }
                success(code, message, articles)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    
    /// 发送好友请求
    func sendFriendRequest(user: User, toUser: User, message: String, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("reqUserId", value: user.id)
        dic.checkOrAppend("reqUserName", value: SafeUnwarp(user.realName, holderForNull: ""))
        dic.checkOrAppend("reqDuties", value: SafeUnwarp(user.duty, holderForNull: ""))
        dic.checkOrAppend("reqCompany", value: SafeUnwarp(user.company, holderForNull: ""))
        
        dic.checkOrAppend("targetId", value: toUser.id)
        dic.checkOrAppend("targetUserName", value: SafeUnwarp(toUser.realName, holderForNull: ""))
        
        dic.checkOrAppend("requestMsg", value: message)
        dic.checkOrAppend("reqId", value: "")
        dic.checkOrAppend("requestType", value: 0)
        dic.checkOrAppend("osFlag", value: "1")
        NetWork.shareInstance.post(.cvSource, "mobile/friend/commitReq.do", params: dic, success: { (code , msg, data) in
            // 1017: 已是好友,不可重复添加
            // 1016: 已请求，请等待对方确认
            if code == 0 {
                success(code, msg, true)
            } else {
                success(code, msg, false)
            }
        }, failed: failed)
    }
    
    /// 处理好友请求
    func handleFriendRequest(user: User, handleType: FriendRequestHanldeType, request: FriendRequest, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("reqUserId", value: request.user.id)
        dic.checkOrAppend("reqUserName", value: request.user.realName)
        dic.checkOrAppend("reqDuties", value: request.user.duty)
        dic.checkOrAppend("reqCompany", value: request.user.company)
        
        dic.checkOrAppend("targetId", value: user.id)
        dic.checkOrAppend("targetUserName", value: user.realName)
        
        dic.checkOrAppend("requestMsg", value: request.message)
        dic.checkOrAppend("reqId", value: request.id)
        dic.checkOrAppend("requestType", value: handleType.rawValue)
        dic.checkOrAppend("osFlag", value: "1")
        
        NetWork.shareInstance.post(.cvSource, "mobile/friend/commitReq.do", params: dic, success: { (code , msg, data) in
            if code == 0 {
                success(code, msg, true)
            } else {
                success(code, msg, false)
            }
        }, failed: failed)
    }
    
    func getFriendRequests(dateForPaging: String?, user: User, success: @escaping NetWorkFriendRequestsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("date", value: dateForPaging, holderForNull: "0")
        dic.append("userId", value: user.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/friend/getReqList.do", params: dic, success: { (code, msg, data) in
            if code == 0 {
                var requests = [FriendRequest]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let request = FriendRequest()
                        request.update(dic)
                        requests.append(request)
                    }
                }
                success(code, msg, requests)
            } else {
                success(code, msg, nil)
            }
        }, failed: failed)
    }
    
    ///删除好友请求
    func deleteFriendRequests(request: FriendRequest, success: @escaping NetWorkFriendRequestsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("id", value: request.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/friend/deleteReq.do", params: dic, success: { (code, msg, data) in
            if code == 0 {
                var requests = [FriendRequest]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let request = FriendRequest()
                        request.update(dic)
                        requests.append(request)
                    }
                }
                success(code, msg, requests)
            } else {
                success(code, msg, nil)
            }
        }, failed: failed)
    }
    
    /// 获取好友列表
    func getFriends(dateForPaging: String?, user: User, success: @escaping NetWorkUsersSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("date", value: dateForPaging, holderForNull: "0")
        dic.append("userId", value: user.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/friend/myFriends.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var users = [User]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let user = User()
                        user.updateInCircle(dic)
                        user.isFriend = true
                        users.append(user)
                    }
                }
                success(code, message, users)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 删除好友
    func deleteFriend(user: User, friend: User, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("friendId", value: friend.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/friend/delFriend.do", params: dic, success: { (code , msg, data) in
            if code == 0 {
                success(code, msg, true)
            } else {
                success(code, msg, false)
            }
        }, failed: failed)
    }
    
    /// 检索用户(keyword长度大于0)
    func searchUsers(user: User, keyword: String, success: @escaping NetWorkUsersSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("kw", notNullValue: keyword)
        NetWork.shareInstance.get(.cvSource, "mobile/friend/find2Add.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var users = [User]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let user = User()
                        user.updateInUserSearch(dic)
                        users.append(user)
                    }
                }
                success(code, message, users)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 推荐用户
    func suggestUsers(user: User, industry: Industry, success: @escaping NetWorkUsersSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("industryId", value: industry.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/friend/suggest.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var users = [User]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let user = User()
                        user.updateInUserSearch(dic)
                        users.append(user)
                    }
                }
                success(code, message, users)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
}
