//
//  MyselfManager.swift
//  touzhong
//
//  Created by zerlinda on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

typealias NetWorkUserSuccess = (_ code: Int, _ msg: String, _ user: User?) -> ()
typealias NetWorkCareersSuccess = (_ code: Int, _ msg: String, _ careers: [Career]?) -> ()
typealias NetWorkPictureSuccess = (_ code: Int, _ msg: String, _ picture: Picture?) -> ()
typealias NetWorkCollectionsSuccess = (_ code: Int, _ msg: String, _ collections: [MyCollection]?) -> ()

class MyselfManager: NSObject {
    
    static let shareInstance = MyselfManager()
    
    /// 上传头像
    func uploadAvatar(_ user: User, image: UIImage, success: @escaping NetWorkPictureSuccess, failed: @escaping NetWorkFailed) {
        NetWork.shareInstance.uploadImages(.userCenter, "user/updateheadimg", user: user, images: [image], success: { (code, message, data) in
            if code == 0 {
                let pic = Picture()
                if let dic = data as? [String: Any] {
                    pic.update(dic)
                }
                success(code, message, pic)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 上传名片
    func uploadCard(_ user: User, image: UIImage, success: @escaping NetWorkPictureSuccess, failed: @escaping NetWorkFailed) {
        NetWork.shareInstance.uploadImages(.userCenter, "user/uploadcard", user: nil, images: [image], success: { (code, message, data) in
            if code == 0 {
                let pic = Picture()
                if let arr = data as? [[String: Any]] {
                    if let dic = arr.first {
                        pic.update(dic)
                    }
                }
                success(code, message, pic)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    func author(_ user: User, career: Career, pic: Picture, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        dic.append("careerId", value: career.id, holderForNull: "")
        dic.append("cardImg", value: pic.url, holderForNull: "")
        dic.append("tCardImg", value: pic.thumbUrl, holderForNull: "")
        NetWork.shareInstance.get(.userCenter, "authentication", params: dic, success: { (code, msg, data) in
            if code == 0 {
                success(code, msg, true)
            } else {
                success(code, msg, false)
            }
        }, failed: failed)
        
    }
    
    func saveInfo(_ key: String, value: String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        if Account.sharedOne.isLogin {
            dic.checkOrAppend("userid", value: Account.sharedOne.user.id)
        }
        dic.checkOrAppend(key, value: value)
        NetWork.shareInstance.post(.userCenter, "profile/basic/save", params: dic, success: success, failed: failed)
    }
    
    func getInfo(user: User, success: @escaping NetWorkUserSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        if Account.sharedOne.isLogin {
            dic.append("userid", value: Account.sharedOne.user.id, holderForNull: "")
        }
        NetWork.shareInstance.get(.cvSource, "mobile/uc/user/p/full.do", params: dic, success: { (code, msg, data) in
            if code == 0 {
                let user = User()
                if let dic = data as? [String: Any] {
                    user.update(dic)
                }
                success(code, msg, user)
            } else {
                success(code, msg, nil)
            }
        }, failed: failed)
    }
    
    /**
     保存个人信息
     */
    func saveInfo(realName: String, organization: Organization, roleType: Int, gender:String, position:String, exmail:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed){
        var dic = [String: Any]()
        if Account.sharedOne.isLogin {
            dic.checkOrAppend("userid", value: Account.sharedOne.user.id)
        }
        //dic.checkOrAppend("nickname", value: accountName)
        dic.checkOrAppend("realname", value: realName)
        dic.checkOrAppend("roletype", value: roleType)
        dic.checkOrAppend("gender", value: gender)
        dic.checkOrAppend("position", value: position)
        dic.checkOrAppend("exmail", value: exmail)
        
        dic.checkOrAppend("company", value: organization.name)
        dic.checkOrAppend("companyId", value: organization.id)
        dic.checkOrAppend("companyType", value: organization.type?.rawValue)
        NetWork.shareInstance.post(.userCenter, "profile/basic/save", params: dic, success: success, failed: failed)
    }
    
    func saveCareer(_ career: Career, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed){
        var dic = career.toDic()
        if career.userId == nil {
            if Account.sharedOne.isLogin {
                dic.checkOrAppend("userId", value: Account.sharedOne.user.id)
            }
        }
        NetWork.shareInstance.post(.userCenter, "user/career/save", params: dic, success: { (code, msg, data) in
            if code == 0 {
                success(code, msg, true)
            } else {
                success(code, msg, false)
            }
        }, failed: failed)
    }
    
    func deleteCareer(_ careerId:String, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.checkOrAppend("id", value: careerId)
        NetWork.shareInstance.post(.userCenter, "user/career/delete", params: dic, success: { (code, msg, data) in
            if code == 0 {
                success(code, msg, true)
            } else {
                success(code, msg, false)
            }
        }, failed: failed)
    }
    
    func getCareers(user: User, success: @escaping NetWorkCareersSuccess, failed: @escaping NetWorkFailed){
        var dic = [String: Any]()
        dic.checkOrAppend("userId", value: user.id)
        NetWork.shareInstance.post(.userCenter, "user/career/list", params: dic, success: { (code, msg, data) in
            if code == 0 {
                var careers = [Career]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let career = Career()
                        career.update(dic)
                        careers.append(career)
                    }
                }
                success(code, msg, careers)
            } else {
                success(code, msg, nil)
            }
        }, failed: failed)
    }
    
    func modifyPassword(_ oldPassword:String, newPassword:String, success: @escaping NetWorkSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        if Account.sharedOne.isLogin {
            dic.checkOrAppend("userid", value: Account.sharedOne.user.id)
        }
        dic.checkOrAppend("oldPwd", value: oldPassword)
        dic.checkOrAppend("newPwd", value: newPassword)
        NetWork.shareInstance.post(.userCenter, "profile/sec/pwd", params: dic, success: success, failed: failed)
    }
    
    /// 收藏
    func collect(user: User, collect: Bool, collection: MyCollection, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        
        //assert(collection.type != nil)
        let type = collection.type!
        
        switch type {
        case .news, .report, .conference:
            
            var dic = [String: Any]()
            dic.checkOrAppend("userid", value: user.id)
            dic.checkOrAppend("favtype", value: collection.type?.rawValue)
            dic.checkOrAppend("targetid", value: collection.targetId)
            dic.checkOrAppend("targeturl", value: collection.targetUrl)
            dic.checkOrAppend("targetcontent", value: collection.targetContent)
            dic.checkOrAppend("targetdesc", value: collection.targetDescri)
            dic.checkOrAppend("targetimg", value: collection.targetImage)
            if collect == false {
                dic.checkOrAppend("cancelfav", value: "cancel")
            }
            NetWork.shareInstance.post(.userCenter, "user/fav/save", params: dic, success: { (code , msg, data) in
                if code == 0 {
                    success(code, msg, true)
                } else {
                    success(code, msg, false)
                }
            }, failed: failed)
            
        case .institution, .enterprise, .figure:
            
            var dic = [String: Any]()
            dic.checkOrAppend("userid", value: user.id)
            dic.checkOrAppend("intersttype", value: collection.type?.rawValue)
            dic.checkOrAppend("targetid", value: collection.targetId)
            dic.checkOrAppend("targeturl", value: collection.targetUrl)
            dic.checkOrAppend("targetcontent", value: collection.targetContent)
            dic.checkOrAppend("targetdesc", value: collection.targetDescri)
            dic.checkOrAppend("targetimg", value: collection.targetImage)
            dic.checkOrAppend("interest", value: collect)
            
            NetWork.shareInstance.post(.userCenter, "user/interest/save", params: dic, success: { (code , msg, data) in
                if code == 0 {
                    success(code, msg, true)
                } else {
                    success(code, msg, false)
                }
            }, failed: failed)
        }
        
        
    }
    
    /// 删除收藏
    func deleteCollect(user: User, collection: MyCollection, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        
        let type = SafeUnwarp(collection.type, holderForNull: .news)
        
        switch type {
        case .news, .report, .conference:
            
            var dic = [String: Any]()
            dic.checkOrAppend("id", value: collection.id)
            NetWork.shareInstance.post(.userCenter, "user/fav/delete", params: dic, success: { (code , msg, data) in
                if code == 0 {
                    success(code, msg, true)
                } else {
                    success(code, msg, false)
                }
            }, failed: failed)
        case .institution, .enterprise, .figure:
            
            var dic = [String: Any]()
            dic.append("id", value: collection.id, holderForNull: "")
            NetWork.shareInstance.get(.userCenter, "user/interest/delete", params: dic, success: { (code , msg, data) in
                if code == 0 {
                    success(code, msg, true)
                } else {
                    success(code, msg, false)
                }
            }, failed: failed)
        }
        
    }
    
    
    /// 是否收藏
    func checkCollect(user: User, id: String, type: MyCollectionType, success: @escaping NetWorkBoolSuccess, failed: @escaping NetWorkFailed) {
        
        switch type {
        case .news, .report, .conference:
            
            var dic = [String: Any]()
            dic.checkOrAppend("userid", value: user.id)
            dic.checkOrAppend("favtype", value: type.rawValue)
            dic.checkOrAppend("targetid", value: id)
            NetWork.shareInstance.post(.userCenter, "user/fav/iscollect", params: dic, success: { (code , msg, data) in
                if code == 0 {
                    if let b = data as? Bool {
                        success(code, msg, b)
                    } else {
                        success(code, msg, false)
                    }
                } else {
                    success(code, msg, false)
                }
            }, failed: failed)
            
        case .institution, .enterprise, .figure:
            var dic = [String: Any]()
            dic.append("userid", value: user.id, holderForNull: "")
            dic.append("intersttype", value: type.rawValue, holderForNull: "")
            dic.append("targetid", value: id, holderForNull: "")
            NetWork.shareInstance.get(.userCenter, "user/isinterest", params: dic, success: { (code , msg, data) in
                if code == 0 {
                    if let b = data as? Bool {
                        success(code, msg, b)
                    } else {
                        success(code, msg, false)
                    }
                } else {
                    success(code, msg, false)
                }
            }, failed: failed)
            
        }
        
    }
    
    /// 收藏列表(page 从1开始)
    func getCollects(user: User, type: MyCollectionType, page: Int, success: @escaping NetWorkCollectionsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userid", value: user.id, holderForNull: "")
        dic.append("page", notNullValue: page)
        dic.append("size", notNullValue: 20)
        //dic.checkOrAppend("orderby", value: "targetid")
        //dic.checkOrAppend("favtype", value: type.rawValue)
        NetWork.shareInstance.get(.userCenter, "user/myfav/page", params: dic, success: { (code , msg, data) in
            if code == 0 {
                var collections = [MyCollection]()
                if let arr = data as? [[String: Any]] {
                    for dic in arr {
                        let collection = MyCollection()
                        collection.update(dic)
                        collections.append(collection)
                    }
                }
                success(code, msg, collections)
            } else {
                success(code, msg, nil)
            }
        }, failed: failed)
    }
    
    class func getHorn(start:Int,date:String,row:Int,success:@escaping ((_ code : Int,_ message : String,_ data : [HornViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        
        var dic = [String:Any]()
        if Account.sharedOne.isLogin {
            dic.checkOrAppend("userId", value: Account.sharedOne.user.id)
        }
        dic.append("date", notNullValue: date)
        dic.append("rows", notNullValue: row)
        
        //        let dic:[String:Any]? = [
        //            "date":date,
        //            "rows":row,//起始页
        //        ]
        NetWork.shareInstance.request("mobile/speaker/list.do", type: .get, param: dic, prefix: .URL, success: {(code,message,data) in
            
            if code == 0{
                if let arr:[[String:AnyObject]] = data as? [[String:AnyObject]] {
                    let modelArr = MyselfManager.shareInstance.getHornModelList(arr)
                    if modelArr.count == row{
                        success(code, message, modelArr, start+row+1)
                    }else{
                        success(code, message, modelArr, start+modelArr.count)
                    }
                }
            }else{
                success(code, message, nil, 0)
            }
        }, failed:failed)
        
    }
    func getHornModelList(_ data:[Dictionary<String,AnyObject>]?)->[HornViewModel]{
        var modelArr:[HornViewModel] = [HornViewModel]()
        if let arr = data{
            for i in 0..<arr.count{
                let dic = arr[i]
                let model = HornDataModel.objectWithKeyValues(dic as NSDictionary) as! HornDataModel
                let viewModel = HornViewModel()
                viewModel.model = model
                modelArr.append(viewModel)
            }
        }
        return modelArr
    }
    
    /// 获取喇叭数量
    func getHornCount(_ user: User, success: @escaping NetWorkIntSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("userId", value: user.id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/speaker/getCount.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                if let n = data as? Int {
                    success(code, message, n)
                } else if let n = data as? NSString {
                    success(code, message, n.integerValue)
                } else {
                    success(code, message, 0)
                }
            } else {
                success(code, message, 0)
            }
        }, failed: failed)
    }
    
    
    
}
