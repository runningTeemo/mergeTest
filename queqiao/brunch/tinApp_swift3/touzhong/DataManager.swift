//
//  DataManager.swift
//  SwiftNet
//
//  Created by Zerlinda on 16/5/25.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit

//MARK: 线上环境
// bundleId com.Chinaventure.investChina
/// 环信id
let kEMAppKey = "investchina#cvapp"
/// 环信推送证书发布
let kEMAppSerRelease = "cvapp_push_release"
/// 环信推送证书开发
let kEMAppSerDev = "cvapp_push_dev"
// 服务器地址
var SSOPREFIXURL = "https://usercenter.chinaventure.com.cn/"
var PREFIXURL = "https://cvapp.chinaventure.com.cn/cv_api/"

//// 服务器地址
//var SSOPREFIXURL = "https://testusercenter.chinaventure.com.cn/"
//var PREFIXURL = "https://testtin.cvsource.com.cn/cv_api/"

/// 登陆验签失败的code
let SIGNERRORCODE: Int = 1013



let mainColor = MyColor.colorWithHexString("#2692d8")
let customGrayColor = MyColor.colorWithHexString("#9099A3")
let mostGrayColor = customGrayColor
let middleGraColor = MyColor.colorWithHexString("#9fa8b2")
let lessGrayColor = MyColor.colorWithHexString("d6e1e7")

let mainBgGray = MyColor.colorWithHexString("#f5f5fa")
let mainOrangeColor = MyColor.colorWithHexString("#d61f26")
let mainBlueColor = MyColor.colorWithHexString("#3aaaf1")
let mainGreenColor = MyColor.colorWithHexString("#44ae62")
let mainBlueGreenColor = MyColor.colorWithHexString("#44c4c3")
let verticalLineColor = MyColor.colorWithHexString("#f2f2f2")

let cellLineColor = MyColor.colorWithHexString("#e7e7e7")
let labelBottomLineGrayColor = MyColor.colorWithHexString("#eaeeef")

let tabbarH:CGFloat = 49
let NaviHeight:CGFloat = 64
let leftStartX:CGFloat = 12.5

let InstitutionType = ["1":"VC","2":"PE","3":"VC&PE","0":"默认"]
let InvestRound:[String] = ["Angel", "Series A", "Series B", "Series C", "Series D", "", "Series E", "PIPE", "Growth", "Buyout"]
let Growth:[String] = ["", "早期", "发展期", "扩张期", "获利期"]
let KHEIGHT = UIScreen.main.bounds.size.height
let KWIDTH = UIScreen.main.bounds.size.width

let kCvSourceSalt =     "7141c657-8d6e-4076-9e60-310e9d696f29"
let kUserCenterSalt =   "c2755e8d-12db-4f06-ad8e-e1f3a153e645"

/// 首页头部的默认图
var topBannerDefaultBanner: Banner?
var topBannerDefaultImage: UIImage?
let kTopBannerDefaultImageName: String = "kTopBannerDefaultImage"

class DataManager: NSObject {

    static let shareInstance = DataManager()
    var nightModel:Bool = false
    //var deviceId:String = ""
    var timeStemp:String = ""
    var userId:Double = 0
    var dataVC:DataViewController = DataViewController()    
    var deviceIdUpdated: Bool = false
    
    private var _deviceId: String?
    private var deviceIdRequests = [(String) -> ()]()
    func getDeviceId(done: @escaping ((_ deviceId: String) -> ())) {
        #if arch(i386) || arch(x86_64)
            done("simulator_device_id")
        #else
            if let _deviceId = _deviceId {
                done(_deviceId)
                deviceIdRequests.removeAll()
                return
            }
            deviceIdRequests.append(done)
        #endif
    }
    func deviceIdGetted(id: String) {
        _deviceId = id
        for done in deviceIdRequests {
            done(id)
        }
        deviceIdRequests.removeAll()
    }
    
}
