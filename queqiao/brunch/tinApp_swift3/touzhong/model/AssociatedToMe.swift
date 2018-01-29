//
//  AssociatedToMe.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class AssociatedToMe {
    
    var article: Article = Article()
    var comment: Comment = Comment()
    var comments: [Comment] = [Comment]()
    
    func update(_ dic: [String: Any]) {
        if let dic = dic["searchData"] as? [String: Any] {
            article.update(dic)
        }
        if let dic = dic["comment"] as? [String: Any] {
            comment.update(dic)
        }
        if let arr = dic["listComment"] as? [[String: Any]] {
            comments.removeAll()
            for dic in arr {
                let comment = Comment()
                comment.update(dic)
                comments.append(comment)
            }
        }
    }
    
    
}
