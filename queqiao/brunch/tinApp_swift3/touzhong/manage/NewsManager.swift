//
//  NewsManager.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias NetWorkBannerSuccess = (_ code: Int, _ msg: String, _ banner: Banner?) -> ()
typealias NetWorkBannersSuccess = (_ code: Int, _ msg: String, _ banners: [Banner]?) -> ()
typealias NetWorkNewsSuccess = (_ code: Int, _ msg: String, _ news: [News]?) -> ()

enum AdvertisePossition: String {
    case IndexTop = "1"
    case IndexMiddle = "2"
    case FocusTop = "3"
    case FocusMiddle = "4"
}

/// 相关新闻的category
/// by:zerlinda
/// - enterprise: 企业
/// - institution: 机构
/// - news: 新闻
enum relevantNewsCategory:Int{
    case enterprise = 0
    case institution = 1
    case news = 8
}

class NewsManager {
    static let shareInstance = NewsManager()
    
    func getIndexDefaultBanner(success: @escaping NetWorkBannerSuccess, failed: @escaping NetWorkFailed) {
        let dic = [String: Any]()
        NetWork.shareInstance.get(.cvSource, "mobile/advertise/default.do", params: dic, success: { (code, message, data) in
            if code == 0 || code == 1001 {
                if let arr = data as? [[String: Any]] {
                    if let dic = arr.first {
                        let banner = Banner()
                        banner.update(dic)
                        success(code, message, banner)
                    } else {
                        success(code, message, nil)
                    }
                } else {
                    success(code, message, nil)
                }
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    
    func getBanners(_ position: AdvertisePossition, cached: Bool = false, success: @escaping NetWorkBannersSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("advertisePosition", value: position.rawValue)
        dic.checkOrAppend("reqFromCode", value: 0)
        
        let cacheUrl = "mobile/advertise/advertisement.do"
        let identify = position.rawValue
        
        // 缓存加载
        if cached {
            if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                var banners = [Banner]()
                for dic in arr {
                    let banner = Banner()
                    banner.update(dic)
                    banners.append(banner)
                }
                success(0, kCacheBeforeMessage, banners)
            }
        }
        
        NetWork.shareInstance.post(.cvSource, "mobile/advertise/advertisement.do", params: dic, success: { (code, message, data) in
            if code == 0 || code == 1001 {
                var banners = [Banner]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let banner = Banner()
                        banner.update(dic)
                        banners.append(banner)
                    }
                }
                success(code, message, banners)
                
                /// 缓存第一页
                if cached {
                    if let arr = data as? NSArray {
                        TinFileCacher.sharedOne.cacheArr(arr: arr, url: cacheUrl, identifies: identify)
                    }
                }
                
            } else {
                
                // 缓存加载
                if cached {
                    if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                        var banners = [Banner]()
                        for dic in arr {
                            let banner = Banner()
                            banner.update(dic)
                            banners.append(banner)
                        }
                        success(0, kCacheMessage, banners)
                    } else {
                        success(code, message, nil)
                    }
                } else {
                    success(code, message, nil)
                }
            }
            
        }, failed: { error in
            
            // 缓存加载
            if cached {
                if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                    var banners = [Banner]()
                    for dic in arr {
                        let banner = Banner()
                        banner.update(dic)
                        banners.append(banner)
                    }
                    success(0, kCacheMessage, banners)
                } else {
                    failed(error)
                }
            } else {
                failed(error)
            }
            
        })
    }
    
    func getNews(_ keyWord: String?, user: User?, industry: Industry?, dateForPaging: String?, rows: Int, channel: String, cached: Bool = false, success: @escaping NetWorkNewsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("publishAt", value: dateForPaging)
        dic.checkOrAppend("keyword", value: keyWord)
        dic.checkOrAppend("rows", value: rows)
        dic.checkOrAppend("newsChannelId", value: channel)
        dic.checkOrAppend("reqFromCode", value: 0)
        dic.checkOrAppend("userId", value: user?.id)
        dic.checkOrAppend("newsIndustryId", value: industry?.id)
        
        let cacheUrl = "mobile/news/list.do"
        let identify = channel
        
        // 缓存加载
        if dateForPaging == nil && cached {
            if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                var newses = [News]()
                for dic in arr {
                    let news = News(type: .news)
                    news.update(dic)
                    newses.append(news)
                }
                success(0, kCacheBeforeMessage, newses)
            }
        }
        
        NetWork.shareInstance.post(.cvSource, "mobile/news/list.do", params: dic, success: { (code, message, data) in
            if code == 0 || code == 1001 {
                var newses = [News]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        newses.append(news)
                    }
                }
                success(code, message, newses)
                /// 缓存第一页
                if cached {
                    if dateForPaging == nil {
                        if let arr = data as? NSArray {
                            TinFileCacher.sharedOne.cacheArr(arr: arr, url: cacheUrl, identifies: identify)
                        }
                    }
                }
                
            } else {
                // 缓存加载
                if dateForPaging == nil && cached {
                    if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                        var newses = [News]()
                        for dic in arr {
                            let news = News(type: .news)
                            news.update(dic)
                            newses.append(news)
                        }
                        success(0, kCacheMessage, newses)
                    } else {
                        success(code, message, nil)
                    }
                } else {
                    success(code, message, nil)
                }
            }
            
        }, failed: { error in
            // 缓存加载
            if dateForPaging == nil && cached {
                if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                    var newses = [News]()
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        newses.append(news)
                    }
                    success(0, kCacheMessage, newses)
                } else {
                    failed(error)
                }
            } else {
                failed(error)
            }
            
        })
    }
    
    func getAdvAndNews(_ keyWord: String?, industry: Industry?, dateForPaging: String?, start: Int, rows: Int, channel: String, cached: Bool = false, success: @escaping NetWorkNewsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("keyword", value: keyWord)
        dic.checkOrAppend("rows", value: rows)
        dic.checkOrAppend("newsChannelId", value: channel)
        dic.checkOrAppend("reqFromCode", value: 0)
        //dic.checkOrAppend("advInterval", value: 5)
        dic.checkOrAppend("publishAt", value: dateForPaging)
        dic.checkOrAppend("newsIndustryId", value: industry?.id)
        dic.append("start", notNullValue: start)
        
        let cacheUrl = "mobile/news/adv/list.do"
        let identify = channel
        
        // 缓存加载
        if dateForPaging == nil && cached {
            if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                var newses = [News]()
                for dic in arr {
                    let news = News(type: .news)
                    news.update(dic)
                    newses.append(news)
                }
                success(0, kCacheBeforeMessage, newses)
            }
        }
        
        NetWork.shareInstance.post(.cvSource, "mobile/news/adv/list.do", params: dic, success: { (code, message, data) in
            if code == 0 || code == 1001 {
                var newses = [News]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        newses.append(news)
                    }
                }
                success(code, message, newses)
                
                /// 缓存第一页
                if cached {
                    if dateForPaging == nil {
                        if let arr = data as? NSArray {
                            TinFileCacher.sharedOne.cacheArr(arr: arr, url: cacheUrl, identifies: identify)
                        }
                    }
                }
                
            } else {
                
                // 缓存加载
                if dateForPaging == nil && cached {
                    if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                        var newses = [News]()
                        for dic in arr {
                            let news = News(type: .news)
                            news.update(dic)
                            newses.append(news)
                        }
                        success(0, kCacheMessage, newses)
                    } else {
                        success(code, message, nil)
                    }
                } else {
                    success(code, message, nil)
                }
            }
        }, failed: { error in
            
            // 缓存加载
            if dateForPaging == nil && cached {
                if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                    var newses = [News]()
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        newses.append(news)
                    }
                    success(0, kCacheMessage, newses)
                } else {
                    failed(error)
                }
            } else {
                failed(error)
            }
            
        })
    }
    
    func getEvents(_ keyWord: String?, dateForPaging: String?, rows: Int, cached: Bool = false, success: @escaping NetWorkNewsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("keyword", value: keyWord)
        dic.checkOrAppend("rows", value: rows)
        dic.checkOrAppend("newsChannelId", value: "-1")
        dic.checkOrAppend("reqFromCode", value: 0)
        dic.checkOrAppend("publishAt", value: dateForPaging)
        
        let cacheUrl = "mobile/news/eventList.do"
        let identify = ""
        
        // 缓存加载
        if dateForPaging == nil && cached {
            if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                var newses = [News]()
                for dic in arr {
                    let news = News(type: .news)
                    news.update(dic)
                    newses.append(news)
                }
                success(0, kCacheBeforeMessage, newses)
            }
        }
        
        NetWork.shareInstance.post(.cvSource, "mobile/news/eventList.do", params: dic, success: { (code, message, data) in
            if code == 0 || code == 1001 {
                var newses = [News]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        newses.append(news)
                    }
                }
                success(code, message, newses)
                
                /// 缓存第一页
                if cached {
                    if dateForPaging == nil {
                        if let arr = data as? NSArray {
                            TinFileCacher.sharedOne.cacheArr(arr: arr, url: cacheUrl, identifies: identify)
                        }
                    }
                }
                
            } else {
                
                // 缓存加载
                if dateForPaging == nil && cached {
                    if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                        var newses = [News]()
                        for dic in arr {
                            let news = News(type: .news)
                            news.update(dic)
                            newses.append(news)
                        }
                        success(0, kCacheMessage, newses)
                    } else {
                        success(code, message, nil)
                    }
                } else {
                    success(code, message, nil)
                }
                
            }
            
        }, failed: { error in
            
            // 缓存加载
            if dateForPaging == nil && cached {
                if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                    var newses = [News]()
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        newses.append(news)
                    }
                    success(0, kCacheMessage, newses)
                } else {
                    failed(error)
                }
            } else {
                failed(error)
            }
            
        })
    }
    
    /// year 是四位的数字字符串
    func getReports(_ dateForPaging: String?, rows: Int, cached: Bool = false, success: @escaping NetWorkNewsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("rows", value: rows)
        dic.checkOrAppend("publishAt", value: dateForPaging)
        dic.checkOrAppend("reqFromCode", value: 0)
        
        let cacheUrl = "mobile/report/list.do"
        let identify = ""
        
        // 缓存加载
        if dateForPaging == nil && cached {
            if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                var newses = [News]()
                for dic in arr {
                    let news = News(type: .news)
                    news.update(dic)
                    newses.append(news)
                }
                success(0, kCacheBeforeMessage, newses)
            }
        }
        
        NetWork.shareInstance.post(.cvSource, "mobile/report/list.do", params: dic, success: { (code, message, data) in
            if code == 0 || code == 1001 {
                var newses = [News]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let news = News(type: .report)
                        news.update(dic)
                        newses.append(news)
                    }
                }
                success(code, message, newses)
                
                /// 缓存第一页
                if cached {
                    if dateForPaging == nil {
                        if let arr = data as? NSArray {
                            TinFileCacher.sharedOne.cacheArr(arr: arr, url: cacheUrl, identifies: identify)
                        }
                    }
                }
                
            } else {
                // 缓存加载
                if dateForPaging == nil && cached {
                    if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                        var newses = [News]()
                        for dic in arr {
                            let news = News(type: .news)
                            news.update(dic)
                            newses.append(news)
                        }
                        success(0, kCacheMessage, newses)
                    } else {
                        success(code, message, nil)
                    }
                } else {
                    success(code, message, nil)
                }
                
            }
        }, failed: { error in
            
            // 缓存加载
            if dateForPaging == nil && cached {
                if let arr = TinFileCacher.sharedOne.getArr(url: cacheUrl, identifies: identify) as? [[String: Any]] {
                    var newses = [News]()
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        newses.append(news)
                    }
                    success(0, kCacheMessage, newses)
                } else {
                    failed(error)
                }
            } else {
                failed(error)
            }
        })
    }
    
    func getRelevantNews(newsKeywords:[String]? = [String](),shortCnName:String? = "",cnName:String? = "",category:relevantNewsCategory,industryIds:[String]? = [String](),rows:Int = 5,success:@escaping ((_ code : Int,_ message : String,_ data:[News]?)->Void),failed:@escaping (_ error:NSError)->Void){
        let dic:[String:Any]? = [
            "signTimestamp":"",//时间戳
            //"rows":rows,//条数（默认的可以满足当前需求，所以隐藏此参数）
            "newsKeywords":SafeUnwarp(newsKeywords, holderForNull: [String]()),//新闻的关键词
            "shortCnName":SafeUnwarp(shortCnName, holderForNull: ""),
            "cnName":SafeUnwarp(cnName, holderForNull: ""),
            "category":category.hashValue,
            "industryIds":SafeUnwarp(industryIds, holderForNull: [String]()),
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/news/relevant.do", type: .post, param: dic, prefix: .URL, success: { (code,message,data) in
            if code == 0 {
                if let arr:[[String:AnyObject]] = data as? [[String:AnyObject]] {
                    var dataArr:[News] = [News]()
                    for dic in arr {
                        let news = News(type: .news)
                        news.update(dic)
                        dataArr.append(news)
                    }
                    success(code, message, dataArr)
                }
            }else{
                success(code, message, nil)
            }
            
        }, failed: failed)
        
    }
    
}
