//
//  Comment.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class Comment: NSObject {
    
    var id: String?
    var articleId: String?
    
    var articleAuthorId: String?
    var targetCommentId: String?
    var originalCommentId: String?

    var content: String?
    
    var user: User = User()
    var replyUser: User?
    
    var createDate: Date?
    
    var dateForPaging: String?
    
    func update(_ dic: [String: Any]) {
        id = dic.nullableString("id")
        
        articleId = dic.nullableString("articleId")
        articleAuthorId = dic.nullableString("articleAuthorId")
        targetCommentId = dic.nullableString("targetCommentId")
        originalCommentId = dic.nullableString("originalCommentId")
        
        content = dic.nullableString("content")
        
        if let dic = dic["fromUser"] as? [String: Any] {
            user.updateInCircle(dic)
        }
        if let dic = dic["targetUser"] as? [String: Any] {
            let user = User()
            user.updateInCircle(dic)
            if NotNullText(user.id) {
                if user.id != "0" {
                    self.replyUser = user
                }
            }
        }
        dateForPaging = dic.nullableString("date")
        createDate = dic.nullableDate("date")
    }
}

class NewsComment {
    
    var id: String?
    var targetId: String?
    var targetType: NewsType?
    var content: String?
    var targetContent: String? // 冗余
    var createDate: Date?
    var agreeCount: Int?
    var commentUser: User?
    var targetUser: User?
    
    var userId: String?
    
    func update(_ dic: [String: Any]) {
        
        id = dic.nullableString("id")
        targetId = dic.nullableString("targetid")
        if let type = dic.nullableString("targettype") {
            if type == "news" {
                targetType = .news
            } else if type == "report" {
                targetType = .report
            }
        }
        content = dic.nullableString("content")
        targetContent = dic.nullableString("targetcontent")
        createDate = dic.nullableDate("createdate")
        agreeCount = dic.nullableInt("likecount")
        if let dic = dic["commentUser"] as? [String: Any] {
            let user = User()
            user.update(dic)
            commentUser = user
        }
        if let dic = dic["targetUser"] as? [String: Any] {
            let user = User()
            user.update(dic)
            targetUser = user
        }
        
        userId = dic.nullableString("userid")
    }
    
}

class NewsCommentGroup {
    var comment: NewsComment = NewsComment()
    var replays: [NewsComment] = [NewsComment]()
    func update(_ dic: [String: Any]) {
        comment.update(dic)
        if let dic = dic["userInfo"] as? [String: Any] {
            let user = User()
            user.update(dic)
            comment.commentUser = user
        }
        replays.removeAll()
        if let arr = dic["commentList"] as? [[String: Any]] {
            for dic in arr {
                let comment = NewsComment()
                comment.update(dic)
                replays.append(comment)
            }
        }
    }
}


