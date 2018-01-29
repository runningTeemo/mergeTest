//
//  NetWork.swift
//  SwiftNet
//
//  Created by Zerlinda on 16/5/23.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit
import Alamofire

typealias NetWorkSuccess = (_ code: Int, _ message: String, _ data: Any?) -> ()
typealias NetWorkFailed = (_ error: NSError) -> ()

typealias NetWorkBoolSuccess = (_ code: Int, _ message: String, _ ret: Bool) -> ()
typealias NetWorkIntSuccess = (_ code: Int, _ message: String, _ n: Int) -> ()


func CheckOrSendTokenErrorNotification(code: Int) {
    if code == SIGNERRORCODE {
        NotificationCenter.default.post(name: kNotificationTokenErrorFailed, object: nil)
    }
}
func SendLoginNotification() {
    NotificationCenter.default.post(name: kNotificationLogin, object: nil)
}
func SendLogoutNotification() {
    NotificationCenter.default.post(name: kNotificationLogout, object: nil)
}


private var _activityIndicatorCount: Int = 0
func ShowActivityIndicator(_ show: Bool) {
    if show {
        _activityIndicatorCount += 1
        //assert(_activityIndicatorCount > 0, "这个地方不应出现，出现请告知。")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    } else {
        _activityIndicatorCount -= 1
        if _activityIndicatorCount <= 0 {
            //_activityIndicatorCount = 0
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //assert(_activityIndicatorCount >= 0, "这个地方不应出现，出现请告知。")
        }
    }
}

/// 访问的服务器网址前缀
public enum Prefix: String {
    case URL, SSOURL}
/// 访问的服务器
enum Server {
    case cvSource
    case userCenter
}

class WebPage {
    let pageIndex: Int
    let pageSize: Int
    let pageCount: Int
    let total: Int
    init(pageIndex: Int?, pageSize: Int?, pageCount: Int?, total: Int?) {
        self.pageIndex = SafeUnwarp(pageIndex, holderForNull: 0)
        self.pageSize = SafeUnwarp(pageSize, holderForNull: 0)
        self.pageCount = SafeUnwarp(pageCount, holderForNull: 0)
        self.total = SafeUnwarp(total, holderForNull: 0)
    }
    var isLastPage: Bool {
        return pageIndex == pageCount
    }
}

let kCacheMessage = "缓存加载"
let kCacheBeforeMessage = "缓存预加载"

class NetWork: NSObject {
    
    static let shareInstance = NetWork()

    func uploadImages(_ server: Server, _ subPath: String, user: User?, images: [UIImage], success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed) {
        
        var url = makeUrlString(server, subPath)
        if let user = user {
            url += "?userId=\(SafeUnwarp(user.id, holderForNull: ""))"
        }
        let method = Alamofire.HTTPMethod.post
        let headers = makeHeaders(server)
        
        log("UPLOAD", url: url, header: headers, params: nil)

        ShowActivityIndicator(true)
        Alamofire.upload(multipartFormData: { (formData) in
            for img in images {
                if let data = UIImageJPEGRepresentation(img, 1) {
                    formData.append(data, withName: "file", fileName: "", mimeType: "jpg")
                }
            }
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: method, headers: headers) { (result) in
                ShowActivityIndicator(false)
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (response) in
                        if let dic = response.result.value as? [String: AnyObject] {
                            var code: Int = 0
                            if let c = dic.nullableInt("code") {
                                code = c
                            }
                            var msg: String = "未知错误"
                            if let m = dic.nullableString("msg") {
                                msg = m
                            }
                            if let m = dic.nullableString("message") {
                                msg = m
                            }
                            CheckOrSendTokenErrorNotification(code: code)
                            success(code, msg, dic["data"])
                            print(dic as NSDictionary)

                        } else {
                            if let err = response.result.error {
                                failed(err as NSError)
                            } else {
                                debugPrint(response.result)
                                //assert(true, "未知错误")
                            }
                        }
                    })
                case .failure(let error):
                    failed(error as NSError)
                }
                
        }
        
    }
    
    
    func post(_ server: Server, _ subPath: String, params: [String: Any], success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed) {
        let url = makeUrlString(server, subPath)
        let method = Alamofire.HTTPMethod.post
        let encoding: Alamofire.ParameterEncoding = Alamofire.JSONEncoding()
        let headers = makeHeaders(server)
        print("params===\(params)")
        log("POST", url: url, header: headers, params: params)

        ShowActivityIndicator(true)
        Alamofire
            .request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { (response) in
                ShowActivityIndicator(false)
                if let dic = response.result.value as? [String: Any] {
                    
                    var code: Int = 0
                    if let c = dic.nullableInt("code") {
                        code = c
                    }
                    var msg: String = "未知错误"
                    if let m = dic.nullableString("msg") {
                        msg = m
                    }
                    if let m = dic.nullableString("message") {
                        msg = m
                    }
                    print(dic as NSDictionary)
                    
                    CheckOrSendTokenErrorNotification(code: code)
                    if let data = dic["data"] {
                        success(code, msg, data)
                    } else if let data = dic["list"] {
                        success(code, msg, data)
                    } else {
                        success(code, msg, nil)
                    }
                } else {
                    if let err = response.result.error {
                        print(err)
                        failed(err as NSError)
                    } else {
                        debugPrint(response.result)
                        //assert(true, "未知错误")
                    }
                }
        }
    }
    
    func get(_ server: Server, _ subPath: String, params: [String: Any], success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed) {
        let url = makeUrlString(server, subPath)
        let method = Alamofire.HTTPMethod.get
        let encoding: Alamofire.ParameterEncoding = Alamofire.URLEncoding()
        let headers = makeHeaders(server)
        print("params===\(params)")
        log("GET", url: url, header: headers, params: params)
        
        ShowActivityIndicator(true)
        Alamofire
            .request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { (response) in
                ShowActivityIndicator(false)
      
                if let dic = response.result.value as? [String: Any] {
                    var code: Int = 0
                    if let c = dic.nullableInt("code") {
                        code = c
                    }
                    var msg: String = "未知错误"
                    if let m = dic.nullableString("msg") {
                        msg = m
                    }
                    if let m = dic.nullableString("message") {
                        msg = m
                    }
                    CheckOrSendTokenErrorNotification(code: code)
                    print(dic as NSDictionary)
                    
                    if let data = dic["data"] {
                        success(code, msg, data)
                    } else if let data = dic["list"] {
                        success(code, msg, data)
                    } else {
                        success(code, msg, nil)
                    }
                } else {
                    if let err = response.result.error {
                        print(err)
                        failed(err as NSError)
                    } else {
                        debugPrint(response.result)
                        //assert(true, "未知错误")
                    }
                }
        }
    }
    
    
    /**
     域名和方法名进行网络请求（大多数的请求都是这种）
     
     - author: zerlinda
     - date: 16-08-25 14:08:53
     
     - parameter urlMethodName: 后端方法名
     - parameter type:          访问类型
     - parameter param:         参数字典
     - parameter success:       访问成功闭包
     - parameter failed:        访问失败闭包
     */
    
    //
    //
    func request(_ subPath: String,
                 type: Alamofire.HTTPMethod,
                 param: [String:Any]?,
                 prefix: Prefix = .SSOURL,
                 success: @escaping (_ successTuple: (code: Int, message: String, data: Any?)) -> Void,
                 failed: @escaping (_ error:NSError)->Void) {
        
        let server: Server
        if prefix == .SSOURL {
            server = .userCenter
        } else {
            server = .cvSource
        }
        
        let url = makeUrlString(server, subPath)
        let headers = makeHeaders(server)
        
        log(type.rawValue, url: url, header: headers, params: nil)
        
        NetWork.shareInstance.request(server: server,
                                      type: type,
                                      urlStr: url,
                                      param: param,
                                      headers: headers,
                                      success: success,
                                      failed: failed)
    }

    /**
     有完整的url
     
     - parameter type:    类型
     - parameter url:     完整url
     - parameter param:   url后面的参数
     - parameter success: 成功后要调取的闭包
     - parameter failed:  失败要调取的闭包
     */
    func request(server: Server,
                 type: Alamofire.HTTPMethod,
                 urlStr: String,
                 param: [String: Any]?,
                 headers: [String:String]?,
                 success: @escaping (_ successTuple: (code: Int, message: String, data: Any?)) -> Void,
                 failed: @escaping (_ error:NSError)->Void) {
        let url: URL = URL(string: urlStr)!
        var encoding:Alamofire.ParameterEncoding = Alamofire.JSONEncoding()
        if type == .get {
            encoding = Alamofire.URLEncoding()
        }
        print("params===\(param)")
        ShowActivityIndicator(true)
        
        Alamofire
            .request(url, method: type, parameters: param, encoding: encoding, headers:headers)
            .validate()
            .response { (response) in
                ShowActivityIndicator(false)

                let error = response.error
                let data = response.data
                if error != nil{
                    failed(error as! NSError)
                    return
                }
                do {
                    let result: Any = try JSONSerialization.jsonObject(with: data!, options: [])
                    if let dic:[String: AnyObject] = result as? [String: AnyObject]{
                        var successTuple : (code: Int, message: String, data: Any?)
                        successTuple.code = SafeUnwarp(dic.nullableInt("code"), holderForNull: 999)
                        CheckOrSendTokenErrorNotification(code: successTuple.code)
                        successTuple.data = dic["data"]
                        successTuple.message = "未知错误"
                        if let msg = dic.nullableString("message") {
                            successTuple.message = msg
                        }
                        if let msg = dic.nullableString("msg") {
                            successTuple.message = msg
                        }
                        success(successTuple)
                    }
                } catch {   // 如果反序列化失败，能够捕获到 json 失败的准确原因，而不会崩溃
                    debugPrint(error)
                    return
                }
        }
        
    }
    
    
    // MARK:
    /**
     返回完整的url
     - parameter urlMethodName:  后台接口的方法名
     - returns: 完整的url
     */
    func url(_ urlMethodName: String, prefixUrl: Prefix = .SSOURL) -> String {
        var completeUrlStr = ""
        if prefixUrl == Prefix.URL {
            completeUrlStr = PREFIXURL
        }else{
            completeUrlStr = SSOPREFIXURL
        }
        completeUrlStr = completeUrlStr + urlMethodName
        return completeUrlStr
    }
    
    /// 输出log
    func log(_ function: String, url: String, header: [String: String]?, params: [String: Any]?) {
        print(function + ":")
        print(url)
        print("HEADER:")
        if let header = header {
            print(header as NSDictionary)
        } else {
            print("nil")
        }
        print("PARAMS:")
        if let params = params {
            print(params as NSDictionary)
        } else {
            print("nil")
        }
    }
    
    /// 获取完整地址
    func makeUrlString(_ server: Server, _ subUrlPath: String) -> String {
        switch server {
        case .cvSource:
            return PREFIXURL + subUrlPath
        case .userCenter:
            return SSOPREFIXURL + subUrlPath
        }
    }
    
    /// 生成请求头（用于验签等作用）
    func makeHeaders(_ server: Server) -> [String: String]? {
        var headers = [String: String]()
        let timestemp = Tools.getSystemTimeStemp()
        let token: String
        do {
            if Account.sharedOne.isLogin {
                token = Account.sharedOne.token
            } else {
                token = ""
            }
        }
        let mobile: String
        do {
            if Account.sharedOne.isLogin {
                mobile = SafeUnwarp(Account.sharedOne.user.mobile, holderForNull: "")
            } else {
                mobile = ""
            }
        }
        let appkey: String
        do {
            switch server {
            case .cvSource:
                appkey = timestemp + token + kCvSourceSalt
            case .userCenter:
                appkey = mobile + timestemp + kUserCenterSalt
            }
        }
        headers["username"] = mobile
        headers["token"] = token
        headers["deviceid"] = Account.sharedOne.deviceId
        headers["timestamp"] = timestemp
        headers["appkey"] = appkey.md5
        return headers
    }
    
}

