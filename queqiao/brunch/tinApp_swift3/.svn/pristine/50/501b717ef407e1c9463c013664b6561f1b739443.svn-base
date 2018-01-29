//
//  BusinessTool.swift
//  touzhong
//
//  Created by zerlinda on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class BusinessTool: NSObject {
    
    class func share(info: [String: Any], done: ((_ success: Bool, _ msg: String) -> ())?) {
        
        var title: String = ""
        var desc: String = ""
        var imageUrl: String = ""
        var url: URL = URL(string: "http://")!
        
        if let t = info.nullableString("title") {
            title = t
        }
        if let t = info.nullableString("desc") {
            desc = t
        }
        if let t = info.nullableString("imgUrl") {
            imageUrl = t
        }
        if let t = info.nullableString("link") {
            if let u = URL(string: t) {
                url = u
            }
        }
        
        if let t = info.nullableString("pageUrl") {
            if let u = URL(string: t) {
                url = u
            }
        }
        
        BusinessTool.share(title: title, decs: desc, image: imageUrl, url: url, done: done)
        
    }
    

    class func share(title: String, decs: String, image: String, url: URL, done: ((_ success: Bool, _ msg: String) -> ())?) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: decs,
                                          images : image,
                                          url : url,
                                          title : title,
                                          type : SSDKContentType.webPage)
        
        ShareSDK.showShareActionSheet(UIView(), items: nil, shareParams: shareParames) { (state : SSDKResponseState, type:SSDKPlatformType, nil, entity : SSDKContentEntity?, error: Error?, bo:Bool) in
            switch state{
            case SSDKResponseState.success:
                done?(true, "分享成功")
            case SSDKResponseState.fail:
                var errmsg = "授权失败"
                if let err = error as? NSError {
                    if let errdesc = err.userInfo.nullableString("error description ") {
                        errmsg = errdesc
                    } else {
                        errmsg = "授权失败" + "\(err.code)"
                    }
                }
                done?(false, errmsg)
            case SSDKResponseState.cancel:
                //done?(false, "操作取消")
                break
            default:break
            }
        }
    }
}
