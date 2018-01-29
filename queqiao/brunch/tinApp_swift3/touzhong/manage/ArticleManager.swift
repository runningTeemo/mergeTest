//
//  ArticleManager.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias NetWorkArticleSuccess = (_ code: Int, _ msg: String, _ article: Article?) -> ()
typealias NetWorkArticlesSuccess = (_ code: Int, _ msg: String, _ articles: [Article]?) -> ()
typealias NetWorkIndustriesSuccess = (_ code: Int, _ msg: String, _ industries: [Industry]?) -> ()
typealias NetWorkCircleSuccess = (_ code: Int, _ msg: String, _ circle: Circle?) -> ()
typealias NetWorkCirclesSuccess = (_ code: Int, _ msg: String, _ circles: [Circle]?) -> ()

typealias NetWorkPicturesSuccess = (_ code: Int, _ msg: String, _ pictures: [Picture]?) -> ()
typealias NetWorkCommentsSuccess = (_ code: Int, _ msg: String, _ comments: [Comment]?) -> ()
typealias NetWorkAgreesSuccess = (_ code: Int, _ msg: String, _ agrees: [Agree]?) -> ()
typealias NetWorkSharesSuccess = (_ code: Int, _ msg: String, _ shares: [Share]?) -> ()
typealias NetWorkViewsSuccess = (_ code: Int, _ msg: String, _ views: [ProjectViewCommitDataModel]?) -> ()

typealias NetWorkUserDetailSuccess = (_ code: Int, _ msg: String, _ userDetail: UserDetail?) -> ()

typealias NetWorkAssociatedToMesSuccess = (_ code: Int, _ msg: String, _ associatedToMes: [AssociatedToMe]?) -> ()

typealias NetWorkIndustryMembersSuccess = (_ code: Int, _ msg: String, _ industryMembers: [IndustryMember]?) -> ()

enum ArticleFilterOrderType: Int {
    //case auto = 1
    case new = 2
    case attention = 3
    case hot = 4
}

class ArticleFilter: NSObject {
    
    var articleType: ArticleType = .all
    
    var locations: [String] = [String]()
    
    var industries: [Industry] = [Industry]()
    var rounds: [Int] = [Int]()
    var currency: [Int] = [Int]()
    var authorRoles: [Int] = [Int]()
    var dealTypes: [Int] = [Int]()
    var minAmount: Int = -1
    var maxAmount: Int = -1
    
    var duties: [String] = [String]()
    var reqAges: [Int] = [Int]()
    var reqDegrees: [Int] = [Int]()
    var salarys: [Int] = [Int]()
    
    var startTime: Double = 0
    var endTime: Double = 0
    
    var orderType: ArticleFilterOrderType = .new
}


class ArticleManager {
    
    static let shareInstance = ArticleManager()
    
    /// 获取行业列表(在第一次获取成功后不再访问网络)
    var cacheIndustries: [Industry]?
    func getIndustries(_ success: @escaping NetWorkIndustriesSuccess, failed : @escaping NetWorkFailed) {
        
        if let cacheIndustries = cacheIndustries {
            success(0, "内存获取", cacheIndustries)
            return
        }
        
        let dic = [String: Any]()
        NetWork.shareInstance.post(.cvSource, "mobile/industry/getAllList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var industries = [Industry]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let industry = Industry()
                        industry.update(dic)
                        industries.append(industry)
                    }
                }
                self.cacheIndustries = industries
                success(code, message, industries)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    // 获取关注行业
    func getUserCircles(targetUser: User, success: @escaping NetWorkCirclesSuccess, failed : @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: targetUser.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/industry/getUserIndustryList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var circles = [Circle]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let circle = Circle()
                        circle.updateUserIndustry(dic)
                        circles.append(circle)
                    }
                }
                success(code, message, circles)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    // 获取关注行业
    func getCircles(_ user: User, success: @escaping NetWorkCirclesSuccess, failed : @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/industry/getOwnIndustrySNS.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var circles = [Circle]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let circle = Circle()
                        circle.updateSummarise(dic)
                        circles.append(circle)
                    }
                }
                success(code, message, circles)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    // 设置关注行业(industries个数不为0)
    func setAttentionIndustries(_ user: User, industries: [Industry], success: @escaping NetWorkBoolSuccess, failed : @escaping NetWorkFailed) {
        var dic = [String: Any]()
        var s = ""
        for i in industries {
            s += SafeUnwarp(i.id,holderForNull:"null_industry_id") + ","
        }
        if s.characters.count > 0 {
            s = s.substring(to: s.characters.index(s.endIndex, offsetBy: -1))
        }
        dic.append("userId", value: user.id, holderForNull: "")
        dic.checkOrAppend("inId", value: s)
        print(dic as NSDictionary)
        NetWork.shareInstance.get(.cvSource, "mobile/industry/updateConcerm.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    // 设置所属行业
    func setPartyIndustry(_ user: User, industry: Industry, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("industryId", value: industry.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/industry/addOrUpdateOwn.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    
    // 设置单个关注行业
    func setAttentionIndustry(_ user: User, industry: Industry, attention: Bool, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("industryId", value: industry.id, holderForNull: "")
        if attention {
            NetWork.shareInstance.get(.cvSource, "mobile/industry/addConcerm.do", params: dic, success: { (code, message, data) in
                if code == 0 {
                    success(code, message, true)
                } else {
                    success(code, message, false)
                }
            }, failed: failed)
        } else {
            NetWork.shareInstance.get(.cvSource, "mobile/industry/cancelConcerm.do", params: dic, success: { (code, message, data) in
                if code == 0 {
                    success(code, message, true)
                } else {
                    success(code, message, false)
                }
            }, failed: failed)
        }
    }
    
    func getCircleInfo(_ user: User, industry: Industry, success: @escaping NetWorkCircleSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("industryId", value: industry.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/industry/getArticleTop.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                let circle = Circle()
                circle.industry = industry
                if let dic = data as? [String: Any] {
                    circle.update(dic)
                }
                success(code, message, circle)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 发布八卦
    func publishBaGua(_ user: User, indusrty: Industry, content: String?, pics: [Picture]?, horn: HornDataModel?, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("content", value: SafeUnwarp(content, holderForNull: ""))
        dic.checkOrAppend("industry", value: indusrty.toDicOld())
        dic.checkOrAppend("user", value: user.toDicOld())
        var images = [[String: Any]]()
        if let pics = pics {
            for pic in pics {
                images.append(pic.toDicOld())
            }
        }
        dic.checkOrAppend("images", value: images)
        dic.checkOrAppend("speakerId", value: horn?.id)
        dic.checkOrAppend("broadcast", value: (horn != nil))
        
        NetWork.shareInstance.post(.cvSource, "mobile/article/publish.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 发布活动
    func publishActivity(_ user: User, attachments: ArticleActivityAttachments, pics: [Picture]?, horn: HornDataModel?, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("userId", value: user.id)
        dic.append(attachments.toDic())
        var images = [[String: Any]]()
        if let pics = pics {
            for pic in pics {
                images.append(pic.toDicOld())
            }
        }
        dic.checkOrAppend("imgList", value: images)
        dic.checkOrAppend("speakerId", value: horn?.id)
        dic.checkOrAppend("broadcast", value: (horn != nil))
        
        NetWork.shareInstance.post(.cvSource, "mobile/activity/publish.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 发布项目
    func publishProject(_ user: User, attachments: ArticleProjectAttachments, pics: [Picture]?, horn: HornDataModel?, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("userId", value: user.id)
        dic.append(attachments.toDic())
        var images = [[String: Any]]()
        if let pics = pics {
            for pic in pics {
                images.append(pic.toDicOld())
            }
        }
        dic.checkOrAppend("imgList", value: images)
        dic.checkOrAppend("speakerId", value: horn?.id)
        dic.checkOrAppend("broadcast", value: (horn != nil))
        
        NetWork.shareInstance.post(.cvSource, "mobile/project/publish.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 发布人才
    func publishManPower(_ user: User, attachments: ArticleManpowerAttachments, horn: HornDataModel?, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("userId", value: user.id)
        dic.append(attachments.toDic())
        dic.checkOrAppend("speakerId", value: horn?.id)
        dic.checkOrAppend("broadcast", value: (horn != nil))
        
        NetWork.shareInstance.post(.cvSource, "mobile/talent/publish.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    func filterIndexArticles(user: User, dateForPaging: String?, startForPaging: Int, rows: Int, filter: ArticleFilter, keyword: String?, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("userId", value: user.id)
        dic.append("reqFromCode", notNullValue: 0)
        
        dic.append("rows", notNullValue: 10)
        dic.append("publishAt", value: dateForPaging, holderForNull: "0")
        dic.append("start", value: startForPaging, holderForNull: 0)
        
        dic.checkOrAppend("keyword", value: keyword)
        
        dic.append("category", notNullValue: filter.articleType.rawValue)
        
        var inds = [String]()
        for i in filter.industries {
            if let s = i.id {
                inds.append(s)
            }
        }
        dic.append("industryIds", notNullValue: inds)
        dic.append("rounds", notNullValue: filter.rounds)
        dic.append("currency", notNullValue: filter.currency)
        dic.append("authorRoles", notNullValue: filter.authorRoles)
        dic.append("dealTypes", notNullValue: filter.dealTypes)
        dic.append("locations", notNullValue: filter.locations)
        dic.append("minAmount", notNullValue: filter.minAmount)
        dic.append("maxAmount", notNullValue: filter.maxAmount)
        dic.append("duties", notNullValue: filter.duties)
        dic.append("reqAges", notNullValue: filter.reqAges)
        dic.append("reqDegrees", notNullValue: filter.reqDegrees)
        dic.append("salarys", notNullValue: filter.salarys)
        dic.append("startTime", notNullValue: filter.startTime)
        dic.append("endTime", notNullValue: filter.endTime)
        
        dic.append("sortType", notNullValue: filter.orderType.rawValue)
        
        dic.append("isAdv", notNullValue: true)
        
        NetWork.shareInstance.post(.cvSource, "mobile/home/getDiscovery.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var articles = [Article]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let article = Article()
                        article.update(dic)
                        if article.type != .all {
                            articles.append(article)
                        }
                    }
                }
                success(code, message, articles)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    //    /// 圈子首页
    //    func getIndexArticlesNew(_ user: User, dateForPaging: String?, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
    //        var dic = [String: Any]()
    //        dic.append("date", value: dateForPaging, holderForNull: "0")
    //        NetWork.shareInstance.get(.cvSource, "mobile/home/getNewArticleList.do", params: dic, success: { (code, message, data) in
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
    //        }, failed: failed)
    //    }
    
    
    //    /// 圈子列表
    //    func getIndustryArticles(_ user: User, dateForPaging: String?, industry: Industry?, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
    //        var dic = [String: Any]()
    //        dic.append("date", value: dateForPaging, holderForNull: "0")
    //        dic.append("industryId", value: industry?.id, holderForNull: "0")
    //        dic.append("userId", value: user.id, holderForNull: "")
    //        NetWork.shareInstance.get(.cvSource, "mobile/home/getArticleList.do", params: dic, success: { (code, message, data) in
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
    
    /// 圈子列表新
    func getIndustryArticlesNew(_ user: User, dateForPaging: String?, startForPaging: Int, rows: Int, industry: Industry?, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("industryId", value: industry?.id, holderForNull: "0")
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("category", notNullValue: 200)
        dic.append("reqFromCode", notNullValue: 0)
        dic.append("rows", notNullValue: rows)
        dic.append("publishAt", value: dateForPaging, holderForNull: "0")
        dic.append("start", value: startForPaging, holderForNull: 0)
        NetWork.shareInstance.post(.cvSource, "mobile/home/getDiscovery.do", params: dic, success: { (code, message, data) in
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
    
    /// 获取文章详情
    func getArticleDetail(_ user: User, article: Article, success: @escaping NetWorkArticleSuccess, failed: @escaping NetWorkFailed) {
        
        switch article.type {
        case .normal:
            var dic = [String: Any]()
            dic.append("articleId", value: article.id, holderForNull: "")
            dic.append("userId", value: user.id, holderForNull: "")
            NetWork.shareInstance.get(.cvSource, "mobile/article/detail.do", params: dic, success: { (code, message, data) in
                if code == 0 {
                    let article = Article()
                    if let arr = data as? [[String: Any]] {
                        if let dic = arr.first {
                            article.update(dic)
                        }
                    }
                    success(code, message, article)
                } else {
                    success(code, message, nil)
                }
            }, failed: failed)
            
        case .activity:
            var dic = [String: Any]()
            dic.append("id", value: article.id, holderForNull: "")
            dic.append("userId", value: user.id, holderForNull: "")
            NetWork.shareInstance.get(.cvSource, "mobile/activity/detail.do", params: dic, success: { (code, message, data) in
                if code == 0 {
                    let article = Article()
                    article.type = .activity
                    if let dic = data as? [String: Any] {
                        article.update(dic)
                    }
                    success(code, message, article)
                } else {
                    success(code, message, nil)
                }
            }, failed: failed)
            
        case .manpower:
            var dic = [String: Any]()
            dic.append("articleId", value: article.id, holderForNull: "")
            dic.append("userId", value: user.id, holderForNull: "")
            NetWork.shareInstance.get(.cvSource, "mobile/talent/detail.do", params: dic, success: { (code, message, data) in
                if code == 0 {
                    let article = Article()
                    article.type = .manpower
                    if let dic = data as? [String: Any] {
                        article.update(dic)
                    }
                    success(code, message, article)
                } else {
                    success(code, message, nil)
                }
            }, failed: failed)
            
        case .project:
            var dic = [String: Any]()
            dic.append("id", value: article.id, holderForNull: "")
            dic.append("userId", value: user.id, holderForNull: "")
            NetWork.shareInstance.get(.cvSource, "mobile/project/detail.do", params: dic, success: { (code, message, data) in
                if code == 0 {
                    let article = Article()
                    article.type = .project
                    if let dic = data as? [String: Any] {
                        article.update(dic)
                    }
                    success(code, message, article)
                } else {
                    success(code, message, nil)
                }
            }, failed: failed)
            
        case .all:
            break
        }
        
    }
    
    /// 获取评论
    func getComments(_ article: Article, dateForPaging: String?, success: @escaping NetWorkCommentsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("date", value: dateForPaging, holderForNull: "0")
        dic.append("articleId", value: article.id, holderForNull: "")
        dic.append("type", notNullValue: article.type.rawValue)
        dic.append("rows", notNullValue: 20)
        NetWork.shareInstance.get(.cvSource, "mobile/article/detail/getCommentList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var comments = [Comment]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let comment = Comment()
                        comment.update(dic)
                        comments.append(comment)
                    }
                }
                success(code, message, comments)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 获取点赞
    func getAgrees(_ article: Article, dateForPaging: String?, success: @escaping NetWorkAgreesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("date", value: dateForPaging, holderForNull: "0")
        dic.append("type", notNullValue: article.type.rawValue)
        dic.append("articleId", value: article.id, holderForNull: "")
        dic.append("rows", notNullValue: 20)
        NetWork.shareInstance.get(.cvSource, "mobile/article/detail/getLikeList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var agrees = [Agree]()
                if let dic = data as? [String: Any] {
                    if let arr = dic["list"] as? [[String: Any]] {
                        for dic in arr {
                            let agree = Agree()
                            agree.update(dic)
                            agrees.append(agree)
                        }
                    }
                }
                success(code, message, agrees)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 获取查看列表
    func getViews(_ article: Article, dateForPaging: String?, success: @escaping NetWorkViewsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("date", value: dateForPaging, holderForNull: "0")
        dic.append("projectId", value: article.id, holderForNull: "")
        dic.append("rows", notNullValue: 20)
        NetWork.shareInstance.get(.cvSource, "mobile/project/view/list.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var views = [ProjectViewCommitDataModel]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let view = ProjectViewCommitDataModel()
                        view.update(dic)
                        views.append(view)
                    }
                }
                success(code, message, views)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 获取分享
    func getShares(_ articleId: String?, dateForPaging: String?, success: @escaping NetWorkSharesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("date", value: dateForPaging, holderForNull: "0")
        dic.append("articleId", value: articleId, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/article/detail/getShareList.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var shares = [Share]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let share = Share()
                        share.update(dic)
                        shares.append(share)
                    }
                }
                success(code, message, shares)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 删除评论
    func deleteComment(_ user: User, article: Article, commentId: String, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("commentId", value: commentId, holderForNull: "")
        //dic.append("userId", value: user.id, holderForNull: "")
        dic.append("type", value: article.type.rawValue, holderForNull: "")
        dic.append("articleId", value: article.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/article/delComment.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 上传图片
    func uploadImages(_ user: User, images: [UIImage], success: @escaping NetWorkPicturesSuccess, failed: @escaping NetWorkFailed) {
        NetWork.shareInstance.uploadImages(.cvSource, "mobile/image/upload.do", user: user, images: images, success: { (code, message, data) in
            if code == 0 {
                var pics = [Picture]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let pic = Picture()
                        pic.update(dic)
                        pics.append(pic)
                    }
                }
                success(code, message, pics)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 评论
    func comment(_ user: User, comment: Comment?, article: Article, content: String, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("id", value: article.id)
        dic.checkOrAppend("articleAuthorId", value: article.user.id)
        dic.checkOrAppend("content", value: content)
        dic.checkOrAppend("fromUser", value: user.toDicOld())
        dic.checkOrAppend("type", value: article.type.rawValue)
        
        dic.checkOrAppend("articleAuthorId", value: article.user.id)
        dic.checkOrAppend("targetCommentId", value: comment?.id)
        if let comment = comment {
            if let id = comment.originalCommentId { // 第三条以后
                dic.checkOrAppend("originalCommentId", value: id)
            } else { // 第二条
                dic.checkOrAppend("originalCommentId", value: comment.id)
            }
        } else { // 第一条
        }
        
        if let replyUser = comment?.user {
            dic.checkOrAppend("targetUser", value: replyUser.toDicOld())
        }
        
        NetWork.shareInstance.post(.cvSource, "mobile/article/commitComment.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 点赞
    func agree(_ user: User, article: Article, agree: Bool, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("articleId", value: article.id)
        dic.checkOrAppend("isLike", value: agree)
        dic.checkOrAppend("user", value: user.toDicOld())
        dic.checkOrAppend("type", value: article.type.rawValue)
        NetWork.shareInstance.post(.cvSource, "mobile/article/commitLike.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    /// 分享
    func share(_ user: User, article: Article, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("articleId", value: article.id)
        dic.checkOrAppend("user", value: user.toDicOld())
        NetWork.shareInstance.post(.cvSource, "mobile/article/commitShare.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 查看
    func view(_ user: User, article: Article, model: ProjectViewCommitDataModel?, applyType: ArticleViewType, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("id", value: model?.id, holderForNull: "")
        dic.append("projectId", value: article.id, holderForNull: "")
        dic.append("applyStatus", value: applyType.rawValue, holderForNull: 0)
        dic.append("createTime", value: model?.createTime, holderForNull: "")
        if let model = model {
            dic.append("projectUserId", value: model.projectUserId, holderForNull: "")
            dic.append("applyUserId", value: model.applyUserId, holderForNull: "")
        } else {
            dic.append("projectUserId", value: article.user.id, holderForNull: "")
            dic.append("applyUserId", value: user.id, holderForNull: "")
        }
        NetWork.shareInstance.post(.cvSource, "/mobile/project/view/commit.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 删除文字
    func delete(_ user: User, article: Article, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("articleId", value: article.id, holderForNull: "")
        dic.append("type", value: article.type.rawValue, holderForNull: "")
        //dic.append("userId", value: user.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/article/delArticle.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 举报文章
    func report(_ user: User, articleId: String, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("articleId", value: articleId)
        dic.checkOrAppend("userId", value: user.id)
        dic.checkOrAppend("userName", value: user.realName)
        //dic.checkOrAppend("deviceId", value: "xxxxxxxxxxxxx")
        NetWork.shareInstance.post(.cvSource, "mobile/tipOff/article.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                success(code, message, true)
            } else {
                success(code, message, false)
            }
        }, failed: failed)
    }
    
    /// 与我相关
    func getAssociatedToMes(start: Int, rows: Int, user: User, success: @escaping NetWorkAssociatedToMesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("start", notNullValue: start)
        dic.append("rows", notNullValue: rows)
        NetWork.shareInstance.get(.cvSource, "mobile/article/aboutMe4Comment.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var associatedToMes = [AssociatedToMe]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let associatedToMe = AssociatedToMe()
                        associatedToMe.update(dic)
                        associatedToMes.append(associatedToMe)
                    }
                }
                success(code, message, associatedToMes)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 获取行业成员
    func getIndustryMembers(user: User, industry: Industry, dateForPaging: String?, success: @escaping NetWorkIndustryMembersSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("industryId", value: industry.id, holderForNull: "")
        dic.append("date0", value: dateForPaging, holderForNull: "0")
        dic.append("mumberType", notNullValue: 2)
        NetWork.shareInstance.get(.cvSource, "mobile/industry/getMumbers.do", params: dic, success: { (code, msg, data) in
            if code == 0 {
                var members = [IndustryMember]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let member = IndustryMember()
                        member.update(dic)
                        members.append(member)
                    }
                }
                success(code, msg, members)
            } else {
                success(code, msg, nil)
            }
        }, failed: failed)
    }
    
    
    /// 关注列表
    func getAttentionArticles(_ user: User, dateForPaging: String?, success: @escaping NetWorkArticlesSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("date", value: dateForPaging, holderForNull: "0")
        dic.append("rows", notNullValue: 20)
        dic.append("userId", value: user.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/project/fav.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var articles = [Article]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let article = Article()
                        article.updateProjectAttention(dic)
                        articles.append(article)
                    }
                }
                success(code, message, articles)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    
}
