//
//  ArticleDetailHelper.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/15.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

struct ArticleDetailHelper {
    
    static func checkListShow(article: Article?) -> (agree: Bool, see: Bool, comment: Bool, count: Int, agreeIsAttention: Bool) {
        
        var agree = false
        var agreeIsAttention = false
        var see = false
        var comment = false
        var count = 0
        
        if let article = article {
            if article.type == .normal {
                agree = true
                see = false
                comment = true
            } else if article.type == .activity {
                agree = article.user.isMe()
                see = false
                comment = true
                agreeIsAttention = true
            } else if article.type == .manpower {
                agree = article.user.isMe()
                see = false
                comment = true
                agreeIsAttention = true
            } else if article.type == .project {
                agree = false
                see = article.user.isMe()
                comment = true
                agreeIsAttention = true
            }
        }
        
        if agree { count += 1 }
        if see { count += 1 }
        if comment { count += 1 }
        
        return (agree, see, comment, count, agreeIsAttention)
        
    }
    
    static func canView(article: Article) -> Bool {
        if article.type != .project || article.user.isMe() {
            return true
        } else {
            if article.type == .project {
                let isPublic = SafeUnwarp((article.attachments as! ArticleProjectAttachments).detailPublic, holderForNull: false)
                if isPublic {
                    return true
                } else {
                    if article.viewType == .success {
                        return true
                    }
                }
            }
        }
        return false
    }
    
}
