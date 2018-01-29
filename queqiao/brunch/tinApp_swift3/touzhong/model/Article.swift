//
//  Article.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

enum ArticleViewType: String {
    case notApply = "0"
    case applying = "1"
    case success = "2"
}

enum ArticleType: String {
    case normal = "201" // 文章
    case manpower = "202" // 人才
    case activity = "203" // 活动
    case project = "204" // 项目
    case all = "200"
}

class ArticleManpowerAttachments {
    var id:String?//文章id  因为article模型没有toDic 分享到好友和项目申请查看的时候需要用 临时建的 by钱
    var companyType: Int?
    var companyName: String?
    var companyId: Int?
    
    var round: Int?
    var duty: String?
    var address: String?
    var requiredAge: Int?
    var requiredDegree: Int?
    var salary: Int?
    var descri: String?

    var broadcast: Bool?

    func update(_ dic: [String: Any]) {
        companyType = dic.nullableInt("companyType")
        companyName = dic.nullableString("company")
        companyId = dic.nullableInt("companyId")
        round = dic.nullableInt("rounds")
        duty = dic.nullableString("duties")
        address = dic.nullableString("dutiesAdd")
        requiredAge = dic.nullableInt("reqAge")
        requiredDegree = dic.nullableInt("reqDegree")
        salary = dic.nullableInt("salary")
        descri = dic.nullableString("discription")
    }
    func toDic() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("companyType", value: companyType)
        dic.checkOrAppend("company", value: companyName)
        dic.checkOrAppend("companyId", value: companyId)
        dic.checkOrAppend("rounds", value: round)
        dic.checkOrAppend("duties", value: duty)
        dic.checkOrAppend("dutiesAdd", value: address)
        dic.checkOrAppend("reqAge", value: requiredAge)
        dic.checkOrAppend("reqDegree", value: requiredDegree)
        dic.checkOrAppend("salary", value: salary)
        dic.checkOrAppend("discription", value: descri)
        dic.checkOrAppend("broadcast", value: broadcast)
        dic.checkOrAppend("discription", value: descri)
        return dic
    }
}
class ArticleActivityAttachments {
    var id:String?//文章id  因为article模型没有toDic 分享到好友和项目申请查看的时候需要用 临时建的 by钱
    var name: String?
    var peopleCount: Int?
    var startTime: Date?
    var endTime: Date?
    var venue: String?
    var city: String?
    var address: String?
    var registrationLink: String?
    var descri: String?
    var broadcast: Bool?

    func update(_ dic: [String: Any]) {
        name = dic.nullableString("name")
        peopleCount = dic.nullableInt("personCount")
        startTime = dic.nullableDate("startTime")
        endTime = dic.nullableDate("endTime")
        venue = dic.nullableString("venue")
        city = dic.nullableString("city")
        address = dic.nullableString("address")
        registrationLink = dic.nullableString("registrationLink")
        descri = dic.nullableString("description")
    }
    func toDic() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("name", value: name)
        dic.checkOrAppend("personCount", value: peopleCount)
        dic.checkOrAppend("startTime", value: startTime?.appToString())
        dic.checkOrAppend("endTime", value: endTime?.appToString())
        dic.checkOrAppend("venue", value: venue)
        dic.checkOrAppend("city", value: city)
        dic.checkOrAppend("address", value: address)
        dic.checkOrAppend("registrationLink", value: registrationLink)
        dic.checkOrAppend("broadcast", value: broadcast)
        dic.checkOrAppend("description", value: descri)
        return dic
    }
}
class ArticleProjectAttachments : NSObject{
    
    var id:String?//文章id  因为article模型没有toDic 分享到好友和项目申请查看的时候需要用 临时建的 by钱
    var articleModelType:String?//因为oc中引用article 引用不到type，因此建一个string类型的type by钱
    var userType: Int?
    var name: String?
    
    var companyType: Int?
    var companyName: String?
    var companyId: Int?

    var projectRelation: String?
    var signedIssue: String? //kFAProjectSignedIssueKeys,kCompanySignedIssueKeys
    
    var dealType: Int? //kProjectDealTypeKeys
    var currentRound: Int? //kProjectInvestTypeKeys,kProjectMergeTypeKeys
    var lastRound: Int? //kProjectInvestTypeKeys,kProjectMergeTypeKeys
    
    var location: String?
    var commission: Double? // 佣金比例
    
    var industries: [Industry] = [Industry]()
    
    var preferCurrency: [Int] = [Int]() //kCurrencyTypeKeys
    var currency: Int? //kCurrencyTypeKeys 当前金额单位
    var currencyAmount: Double?//金额
    
    var investStockRatio: Double? // 投后股权比例
    
    var detailPublic: Bool?
    
    var broadcast: Bool?
    
    var spot: String?
    var brief: String?
    var pain: String?
    var members: String?
    var bussiness: String?
    var data: String?
    var marketing: String?
    var exit: String?

    func toDic() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("userType", value: userType)
        dic.checkOrAppend("name", value: name)
        dic.checkOrAppend("subjectId", value: companyId)
        dic.checkOrAppend("subjectName", value: companyName)
        dic.checkOrAppend("projectRelation", value: projectRelation)
        dic.checkOrAppend("signedIssue", value: signedIssue)
        dic.checkOrAppend("dealType", value: dealType)
        dic.checkOrAppend("location", value: location)
        dic.checkOrAppend("commission", value: commission)
        dic.checkOrAppend("currentRound", value: currentRound)
        dic.checkOrAppend("lastRound", value: lastRound)
        dic.checkOrAppend("preferCurrency", value: preferCurrency)
        dic.checkOrAppend("id", value: id)

        dic.checkOrAppend("currency", value: currency)
        dic.checkOrAppend("amount", value: currencyAmount)
        dic.checkOrAppend("investStockRatio", value: investStockRatio)
        dic.checkOrAppend("detailPublic", value: detailPublic)
        dic.checkOrAppend("broadcast", value: broadcast)
        
        dic.checkOrAppend("description", value: spot)
        dic.checkOrAppend("productIntroduction", value: brief)
        dic.checkOrAppend("bottleneck", value: pain)
        dic.checkOrAppend("founder", value: members)
        dic.checkOrAppend("businessModel", value: bussiness)
        dic.checkOrAppend("operationData", value: data)
        dic.checkOrAppend("marketSituation", value: marketing)
        dic.checkOrAppend("exitPlan", value: exit)
        
        do {
            var iDic = [[String: Any]]()
            for i in industries {
                iDic.append(i.toDicOld())
            }
            dic.append("industryList", notNullValue: iDic)
        }
        return dic
    }
    
    func update(_ dic: [String: Any]) {
        id = dic.nullableString("id")
        userType = dic.nullableInt("userType")
        name = dic.nullableString("name")
        companyId = dic.nullableInt("subjectId")
        companyName = dic.nullableString("subjectName")
        projectRelation = dic.nullableString("projectRelation")
        signedIssue = dic.nullableString("signedIssue")
        dealType = dic.nullableInt("dealType")
        location = dic.nullableString("location")
        commission = dic.nullableDouble("commission")
        currentRound = dic.nullableInt("currentRound")
        lastRound = dic.nullableInt("lastRound")
        if let arr = dic["preferCurrency"] as? [Int] {
            preferCurrency = arr
        }
        do {
            var industries = [Industry]()
            if let arr = dic["industryList"] as? [[String: Any]] {
                for dic in arr {
                    let i = Industry()
                    i.update(dic)
                    industries.append(i)
                }
            }
            self.industries = industries
        }
        currency = dic.nullableInt("currency")
        currencyAmount = dic.nullableDouble("amount")
        investStockRatio = dic.nullableDouble("investStockRatio")
        detailPublic = dic.nullableBool("detailPublic")
        broadcast = dic.nullableBool("broadcast")
        
        spot = dic.nullableString("description")
        brief = dic.nullableString("productIntroduction")
        pain = dic.nullableString("bottleneck")
        members = dic.nullableString("founder")
        bussiness = dic.nullableString("businessModel")
        data = dic.nullableString("operationData")
        marketing = dic.nullableString("marketSituation")
        exit = dic.nullableString("exitPlan")

    }
}


class Article: NSObject {
    
    var origenDic: [String: Any]? //因为article模型没有toDic，因此临时加的字段 by钱
    var articleModelType:String?//因为oc中引用Article模型引用不到type，因此建一个string类型的type by钱
    var applyStatus: String? { //2成功， 1申请中或失败
        didSet {
            origenDic?["applyStatus"] = applyStatus
        }
    }
    var id: String?
    var type: ArticleType = .normal{
        didSet{
            self.articleModelType = type.rawValue
        }
    }
    var user: User = User()
    var industry: Industry = Industry()
    
    var createDate: Date?
    var dateForPaging: String?

    var content: String?
    
    /// 仅用于个人发布页面
    var pictureCount: Int?
    /// 仅用于个人发布页面
    var pictures: [Picture] = [Picture]()
    var picture: Picture?

    var commentCount: Int?
    var comments: [Comment] = [Comment]()
    
    var isAgree: Bool?
    var agreeCount: Int?
    var agrees: [Agree] = [Agree]()
        
    var shareCount: Int?
    var shares: [Share] = [Share]()
    var shareInfo: [String: Any]? // 用于分享的字串
    
    /// 新增参数，表示某个用户对文章评论的数量
    var userCommentCount: Int?
    
    var attachments: AnyObject?
    
    var applyViewCount: Int?
    var acceptViewCount: Int?
    var viewType: ArticleViewType = .notApply

    var broadcast: Bool?

    /// 投资圈模型
    func update(_ dic: [String: Any]) {
        origenDic = dic
        applyStatus = dic.nullableString("applyStatus")
        
        broadcast = dic.nullableBool("broadcast")
        id = dic.nullableString("id")
        if let s = dic.nullableString("articleType") {
            if let t = ArticleType(rawValue: s) {
                type = t
            }
        }
        switch type {
        case .normal:
            break
        case .manpower:
            let attachments = ArticleManpowerAttachments()
            attachments.update(dic)
            attachments.id = id
            self.attachments = attachments
        case .activity:
            let attachments = ArticleActivityAttachments()
            attachments.update(dic)
            attachments.id = id
            self.attachments = attachments
        case .project:
            let attachments = ArticleProjectAttachments()
            attachments.update(dic)
            attachments.id = id
            self.attachments = attachments
            applyViewCount = dic.nullableInt("applyViewerCount")
            acceptViewCount = dic.nullableInt("acceptViewerCount")
            viewType = .notApply
            if let t = dic.nullableString("applyStatus") {
                if let type = ArticleViewType(rawValue: t) {
                    viewType = type
                }
            }
        default:
            break
        }
        
        if let dic = dic["author"] as? [String: Any] {
            user.updateInCircle(dic)
        }
        if let dic = dic["industry"] as? [String: Any] {
            industry.update(dic)
        }
        createDate = dic.nullableDate("date")
        dateForPaging = dic.nullableString("date")
        content = dic.nullableString("content")
        
        if let arr = dic["imgList"] as? [[String: Any]] {
            var pics = [Picture]()
            for dic1 in arr {
                let pic = Picture()
                pic.update(dic1)
                pics.append(pic)
            }
            self.pictures = pics
        }
        self.pictureCount = self.pictures.count
        
        self.commentCount = dic.nullableInt("commentCount")
        if let arr = dic["commentList"] as? [[String: Any]] {
            var cmts = [Comment]()
            for dic1 in arr {
                let cmt = Comment()
                cmt.update(dic1)
                cmts.append(cmt)
            }
            self.comments = cmts
        }
        
        self.isAgree = dic.nullableBool("likeArticle")
        self.agreeCount = dic.nullableInt("likeCount")
        if let arr = dic["likeList"] as? [[String: Any]] {
            var agrs = [Agree]()
            for dic1 in arr {
                let agr = Agree()
                agr.update(dic1)
                agrs.append(agr)
            }
            self.agrees = agrs
        }
        
        if let dic = dic["shareInfo"] as? [String: Any] {
            self.shareInfo = dic
        }
        self.shareCount = dic.nullableInt("shareCount")
        if let arr = dic["shareList"] as? [[String: Any]] {
            var shrs = [Share]()
            for dic1 in arr {
                let shr = Share()
                shr.update(dic1)
                shrs.append(shr)
            }
            self.shares = shrs
        }
        
//        type = .project
//        attachments = ArticleProjectAttachments()
        
        userCommentCount = dic.nullableInt("authorCommentCount")
    }
    
    /// 发布主题模型转换
    func updateWrite(_ dic: [String: Any]) {
        id = dic.nullableString("id")
        
        if let s = dic.nullableString("articleType") {
            if let t = ArticleType(rawValue: s) {
                type = t
            }
        }
        
        switch type {
        case .normal:
            break
        case .manpower:
            let attachments = ArticleManpowerAttachments()
            attachments.update(dic)
            self.attachments = attachments
        case .activity:
            let attachments = ArticleActivityAttachments()
            attachments.update(dic)
            self.attachments = attachments
        case .project:
            let attachments = ArticleProjectAttachments()
            attachments.update(dic)
            self.attachments = attachments
        default:
            break
        }
        
        if let dic = dic["user"] as? [String: Any] {
            user.updateInCircle(dic)
        }
        if let dic = dic["industry"] as? [String: Any] {
            industry.update(dic)
        }
        createDate = dic.nullableDate("date")
        dateForPaging = dic.nullableString("date")
        content = dic.nullableString("content")
        if let arr = dic["images"] as? [[String: Any]] {
            var pics = [Picture]()
            for dic1 in arr {
                let pic = Picture()
                pic.update(dic1)
                pics.append(pic)
            }
            self.pictures = pics
        }
    }
    
    /// 个人发布页面的缩略字典
    func updateBrief(_ dic: [String: Any]) {
        
        id = dic.nullableString("articleId")
        
        if let s = dic.nullableString("articleType") {
            if let t = ArticleType(rawValue: s) {
                type = t
            }
        }
        
        switch type {
        case .normal:
            break
        case .manpower:
            let attachments = ArticleManpowerAttachments()
            attachments.update(dic)
            self.attachments = attachments
        case .activity:
            let attachments = ArticleActivityAttachments()
            attachments.update(dic)
            self.attachments = attachments
        case .project:
            let attachments = ArticleProjectAttachments()
            attachments.update(dic)
            self.attachments = attachments
        default:
            break
        }
        
        content = dic.nullableString("articleContent")
        
        industry.id = dic.nullableString("articleIndustryId")
        industry.name = dic.nullableString("articleIndustryName")
        
        user.id = dic.nullableString("userId")
        user.cnName = dic.nullableString("cnName")
        user.company = dic.nullableString("company")
        user.duty = dic.nullableString("duty")
        user.avatar = dic.nullableString("headImg")
        
        createDate = dic.nullableDate("createTime")
        dateForPaging = dic.nullableString("createTime")

        pictureCount = dic.nullableInt("imgCount")
        
        let ourl = dic.nullableString("imgOUrl")
        let surl = dic.nullableString("imgSUrl")
        if NotNull(ourl) || NotNull(surl) {
            let pic = Picture()
            pic.url = ourl
            pic.thumbUrl = surl
            picture = pic
        }
        
        /// 临时
        if let pic = picture {
            if SafeUnwarp(pictureCount, holderForNull: 0) > 0 {
                self.pictures = [pic]
            }
        }
        
    }
    
    func updateProjectAttention(_ dic: [String: Any]) {
        
        type = .project
        id = dic.nullableString("id")
        
        let att = ArticleProjectAttachments()
        att.name = dic.nullableString("name")
        att.spot = dic.nullableString("description")
        att.companyId = dic.nullableInt("subjectId")
        att.companyName = dic.nullableString("subjectName")
        att.location = dic.nullableString("location")
        att.commission = dic.nullableDouble("commission")
        att.currency = dic.nullableInt("currency")
        att.currencyAmount = dic.nullableDouble("amount")
        att.dealType = dic.nullableInt("dealType")
        att.detailPublic = dic.nullableBool("isDetailPublic")
        att.investStockRatio = dic.nullableDouble("investStockRatio")
        att.currentRound = dic.nullableInt("currentRound")
        
        user.id = dic.nullableString("authorId")
        
        viewType = .notApply
        if let t = dic.nullableString("applyStatus") {
            if let type = ArticleViewType(rawValue: t) {
                viewType = type
            }
        }
        attachments = att
        createDate = dic.nullableDate("updateTime")
        dateForPaging = dic.nullableString("updateTime")
    }
    
}

