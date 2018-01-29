//
//  DataManager.swift
//  touzhong
//
//  Created by zerlinda on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum DataSummariseType: String {
    case year = "YEAR"
    case month = "MONTH"
    case week = "WEEK"
}

typealias NetWorkDataSummariseSuccess = (_ code: Int, _ msg: String, _ summarise: TinDataSummarise?) -> ()
typealias NetWorkInstitutionChartsSuccess = (_ code: Int, _ msg: String, _ charts: [IndustryChart]?) -> ()

//enum InterstType {
//    case figure = "figure",
//     enterprise = "enterprise",
//     institution = "institution"
//}
class DataListManager: NSObject {
    
    static let shareInstance = DataListManager()
    
  
    
    /// 获取融资列表
    ///
    /// - Parameters:
    ///   - isAdv: 是否是高级搜索
    ///   - keyword: 关键字
    ///   - start: 其实位置
    ///   - rows: 一次请求的行数
    ///   - ronuds: 轮次
    ///   - locations: 位置
    ///   - industryIds: 行业
    ///   - startDate: 开始时间
    ///   - endDate: 结束时间
    ///   - minAmount: 最低金额
    ///   - maxAmount: 最高金额
    ///   - cached: 缓存
    ///   - success: 成功回调
    ///   - failed: 失败回调
    func getInvestList(_ isAdv:Bool,keyword:String="",start:Int,rows:Int,ronuds:[String]=[String](),locations:[String]=[String](),industryIds:[String]=[String](),startDate:String="",endDate:String="",minAmount:String="-1",maxAmount:String="-1", cached: Bool = false, success:@escaping ((_ code : Int,_ message : String,_ data : [FinacingViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        let dic:[String:Any] = [
            //Account.sharedOne.user.id
            "keyword":keyword,//关键字
            "isAdv":isAdv,//是否高级搜索
            "start":start,//起始页
            "rows":rows,//条数
            "ronuds":ronuds,
            "locations":locations,//地域
            "industryIds":industryIds, //行业
            "startDate":startDate,
            "endDate":endDate,
            "minAmount":minAmount,//最小金额
            "maxAmount":maxAmount,//最大金额
            "reqFromCode":0
        ]
        
        let cacheUrl = "mobile/event/investList.do"
        let identify = ""
        
        // 缓存加载
        if start <= 1 && cached {
            if let dataDic = TinFileCacher.sharedOne.getDic(url: cacheUrl, identifies: identify) as? [String: Any] {
                let countStr = "\(dataDic["totalCount"]!)"
                let totalCount = (countStr as NSString).integerValue
                if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                    let modelArr = self.parseInvenstModel(arr)
                    success(0, kCacheBeforeMessage, modelArr, totalCount)
                }
            }
        }
        
        NetWork.shareInstance.request("mobile/event/investList.do", type:.post ,param: dic,prefix:.URL, success: {(successTuple)in
            if successTuple.code == 0 {
                
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                        let modelArr = self.parseInvenstModel(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
                
                /// 缓存第一页
                if cached {
                    if start <= 1 {
                        if let dic = successTuple.data as? NSDictionary {
                            TinFileCacher.sharedOne.cacheDic(dic: dic, url: cacheUrl, identifies: identify)
                        }
                    }
                }
                
            } else {
                
                // 缓存加载
                if start <= 1 && cached {
                    if let dataDic = TinFileCacher.sharedOne.getDic(url: cacheUrl, identifies: identify) as? [String: Any] {
                        let countStr = "\(dataDic["totalCount"]!)"
                        let totalCount = (countStr as NSString).integerValue
                        if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                            let modelArr = self.parseInvenstModel(arr)
                            success(0, kCacheMessage, modelArr, totalCount)
                        }
                    } else {
                        success(successTuple.code, successTuple.message, nil, 0)
                    }
                } else {
                    success(successTuple.code, successTuple.message, nil, 0)
                }
            }
            
        }, failed: { error in
            
            // 缓存加载
            if start <= 1 && cached {
                if let dataDic = TinFileCacher.sharedOne.getDic(url: cacheUrl, identifies: identify) as? [String: Any] {
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                        let modelArr = self.parseInvenstModel(arr)
                        success(0, kCacheMessage, modelArr, totalCount)
                    }
                } else {
                    failed(error)
                }
            } else {
                failed(error)
            }
            
        })
    }
    /**
     投资事件列表
     
     - author: zerlinda
     - date: 16-09-08 11:09:32
     
     - parameter success:     <#success description#>
     - parameter failed:      <#failed description#>
     */
    
    func getInvestListById(id:String,start:Int,rows:Int,success:@escaping ((_ code : Int,_ message : String,_ data : [FinacingViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        
        let dic:[String:Any] = [
            //Account.sharedOne.user.id
            "id":id, //关键字
            "rows":rows, //条数
            "start":start, //条数
            "reqFromCode":0
        ]
        
        NetWork.shareInstance.request("mobile/institution/institution/investList.do", type:.get ,param: dic,prefix:.URL, success: {(successTuple)in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["investList"] as? [[String:AnyObject]]{
                        let modelArr = self.parseInvenstModel(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
            }else{
                success(successTuple.code, successTuple.message, nil, 0)
            }
        }, failed: failed)
    }
    
    
    func parseInvenstModel(_ data:[Dictionary<String,AnyObject>]?)->[FinacingViewModel]{
        var modelArr:[FinacingViewModel] = [FinacingViewModel]()
        if let arr = data{
            for i in 0..<arr.count{
                let dic = arr[i]
                let model = InvestEventDataModel.objectWithKeyValues(dic as NSDictionary) as! InvestEventDataModel
                let viewModel = FinacingViewModel()
                viewModel.model = model
                modelArr.append(viewModel)
            }
        }
        return modelArr
    }
    
    /**
     并购事件列表
     
     - author: zerlinda
     - date: 16-09-08 11:09:32
     
     - parameter success:     <#success description#>
     - parameter failed:      <#failed description#>
     */
    func getMergerList(_ isAdv:Bool,keyword:String="",start:Int,rows:Int,locations:[String]=[String](),industryIds:[String]=[String](),startDate:String="",endDate:String="",minAmount:String="",maxAmount:String="",success:@escaping ((_ code : Int,_ message : String,_ data : [MergerViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        let _:NSDictionary = NSDictionary()
        let dic:[String:Any] = [
            //Account.sharedOne.user.id
            "keyword":keyword,//关键字
            "isAdv":isAdv,//是否高级搜索
            "start":start,//起始页
            "rows":rows,//条数
            "locations":locations,//地域
            "industryIds":industryIds,//行业
            "startDate":startDate,
            "endDate":endDate,
            "minAmount":minAmount,
            "maxAmount":maxAmount,
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/event/mergerList.do", type:.post,param: dic,prefix:.URL,success: {(successTuple)in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                        let modelArr = self.parseMergerArr(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
            }else{
                success(successTuple.code, successTuple.message, nil, 0)
            }
        }, failed: failed)
    }
    
    func parseMergerArr(_ data:[Dictionary<String,AnyObject>]?)->[MergerViewModel]{
        
        var modelArr:[MergerViewModel] = [MergerViewModel]()
        if let arr = data{
            for i in 0..<arr.count{
                let dic = arr[i]
                let model = MergerDataModel.objectWithKeyValues(dic as NSDictionary) as! MergerDataModel
                let viewModel = MergerViewModel()
                viewModel.model = model
                modelArr.append(viewModel)
            }
        }
        return modelArr
    }
    
    /**
     退出事件列表列表
     
     - author: zerlinda
     - date: 16-09-08 11:09:32
     
     - parameter success:     <#success description#>
     - parameter failed:      <#failed description#>
     */
    
    func getExiteList(_ isAdv:Bool,keyword:String="",start:Int,rows:Int,locations:[String]=[String](),industryIds:[String]=[String](),startDate:String="",endDate:String="",minAmount:String="",maxAmount:String="",success:@escaping ((_ code : Int,_ message : String,_ data : [ExitEventViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        let _:NSDictionary = NSDictionary()
        let dic:[String:Any]? = [
            //Account.sharedOne.user.id
            "keyword":keyword,//关键字
            "isAdv":isAdv,//是否高级搜索
            "start":start,//起始页
            "rows":rows,//条数
            "locations":locations,//地域
            "industryIds":industryIds,//行业
            "startDate":startDate,
            "endDate":endDate,
            "minAmount":minAmount,
            "maxAmount":maxAmount,
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/event/exiteList.do", type:.post,param: dic,prefix:.URL,success: {(successTuple)in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                        let modelArr = self.getExitModel(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
            }else{
                success(successTuple.code, successTuple.message, nil, 0)
            }
        }, failed: failed)
    }
    
    func getExsitListById(id:String,start:Int,rows:Int,success:@escaping ((_ code : Int,_ message : String,_ data : [ExitEventViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        
        let dic:[String:Any] = [
            //Account.sharedOne.user.id
            "id":id,//关键字
            "rows":rows,//条数
            "start":start,//条数
            "reqFromCode":0
        ]
        
        NetWork.shareInstance.request("mobile/institution/institution/exitList.do", type:.get ,param: dic,prefix:.URL, success: {(successTuple)in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["exitList"] as? [[String:AnyObject]]{
                        let modelArr = self.getExitModel(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
            }else{
                success(successTuple.code, successTuple.message, nil, 0)
            }
        }, failed: failed)
    }
    
    
    
    func getExitModel(_ data:[Dictionary<String,AnyObject>]?)->[ExitEventViewModel]{
        var modelArr:[ExitEventViewModel] = [ExitEventViewModel]()
        
        if let arr = data{
            for i in 0..<arr.count{
                let dic = arr[i]
                let model = ExitEventDataModel.objectWithKeyValues(dic as NSDictionary) as! ExitEventDataModel
                let viewModel = ExitEventViewModel()
                viewModel.model = model
                modelArr.append(viewModel)
            }
        }
        return modelArr
    }
    /**
     
     获取机构列表页
     - author: zerlinda
     - date: 16-09-10 15:09:02
     
     */
    
    func getInstitutionList(_ isAdv:Bool,keyword:String="",start:Int,rows:Int,industryIds:[String]=[String](),insType:[String]=[String](),capitalFroms:[String]=[String](),isOpenInvest:[String] = [String](),success:@escaping ((_ code : Int,_ message : String,_ data : [InstitutionViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        let _:NSDictionary = NSDictionary()
        var dic:[String:Any] = [
            //Account.sharedOne.user.id
            "keyword":keyword,//关键字
            "isAdv":isAdv,//是否高级搜索
            "start":start,//起始页
            "rows":rows,//条数
            "industryIds":industryIds,//行业
            "insTypes":insType,//机构类型
            "capitalFroms":capitalFroms,//资金来源
            //    "isOpenInvest":isOpenInvest,//是否开放
            "reqFromCode":0
        ]
        var arr:[Bool] = [Bool]()
        for str in isOpenInvest {
            if str == "0" {
                arr.append(false)
            }
            if str == "1" {
                arr.append(true)
            }
        }
        dic["isOpenInvest"] = arr
        NetWork.shareInstance.request("mobile/institution/institutionList.do", type:.post,param: dic,prefix:.URL,success: {(successTuple)in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                        let modelArr = self.parseInstitution(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
            }else{
                success(successTuple.code, successTuple.message, nil, 0)
            }
        }, failed: failed)
    }
    
    func parseInstitution(_ data:[Dictionary<String,AnyObject>]?)->[InstitutionViewModel]{
        var modelArr:[InstitutionViewModel] = [InstitutionViewModel]()
        if let arr = data{
            for i in 0..<arr.count{
                let dic = arr[i]
                let model = InstitutionDataModel.objectWithKeyValues(dic as NSDictionary) as! InstitutionDataModel
                let viewModel = InstitutionViewModel()
                viewModel.model = model
                modelArr.append(viewModel)
            }
        }
        return modelArr
    }
    
    
    /**
     获取企业列表
     
     - author: zerlinda
     - date: 16-09-10 15:09:49
     
     */
    func getEnterpriseList(_ isAdv:Bool,keyword:String="",start:Int,rows:Int,locations:[String]=[String](),industryIds:[String]=[String](),rounds:[String]=[String](),success:@escaping ((_ code : Int,_ message : String,_ data:[EnterpriseViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        let _:NSDictionary = NSDictionary()
        let dic:[String:Any]? = [
            //Account.sharedOne.user.id
            "keyword":keyword,//关键字
            "isAdv":isAdv,//是否高级搜索
            "start":start,//起始页
            "rows":rows,//条数
            "locations":locations,//地域
            "industryIds":industryIds,//行业
            "rounds":rounds,
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/enterprise/enterpriseList.do", type:.post,param: dic,prefix:.URL,success: {(successTuple)in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                        let modelArr = self.parseEnterpriseArr(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
            }else{
                success(successTuple.code, successTuple.message, nil, 0)
            }
        }, failed: failed)
    }
    
    func parseEnterpriseArr(_ data:[Dictionary<String,AnyObject>]?)->[EnterpriseViewModel]{
        var modelArr:[EnterpriseViewModel] = [EnterpriseViewModel]()
        
        if let arr = data{
            for i in 0..<arr.count{
                let dic = arr[i]
                let dicNs = dic as NSDictionary
                print(dicNs)
                let model = EnterpriseDataModel.objectWithKeyValues(dic as NSDictionary) as! EnterpriseDataModel
                let viewModel = EnterpriseViewModel()
                viewModel.model = model
                modelArr.append(viewModel)
            }
        }
        return modelArr
    }
    
    
    
    /**
     获取人物列表
     
     - author: zerlinda
     - date: 16-09-23 15:09:40
     
     */
    func getPersonageList(_ isAdv:Bool,keyword:String="",start:Int,rows:Int,success:@escaping ((_ code : Int,_ message : String,_ data:[PersonageViewModel]?,_ totalCount:Int)->Void),failed:@escaping (_ error:NSError)->Void){
        let _:NSDictionary = NSDictionary()
        let dic:[String:Any]? = [
            //Account.sharedOne.user.id
            "keyword":keyword,//关键字
            "isAdv":isAdv,//是否高级搜索
            "start":start,//起始页
            "rows":rows,//条数
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/cvuser/cvuserList.do", type:.post,param: dic,prefix:.URL,success: {(successTuple)in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let countStr = "\(dataDic["totalCount"]!)"
                    let totalCount = (countStr as NSString).integerValue
                    if let arr:[[String:AnyObject]] = dataDic["items"] as? [[String:AnyObject]]{
                        let modelArr = self.parsePersonageModel(arr)
                        success(successTuple.code, successTuple.message, modelArr, totalCount)
                    }
                }
            }else{
                success(successTuple.code, successTuple.message, nil, 0)
            }
        }, failed: failed)
    }
    
    func parsePersonageModel(_ data:[Dictionary<String,AnyObject>]?)->[PersonageViewModel]{
        var modelArr:[PersonageViewModel] = [PersonageViewModel]()
        
        if let arr = data{
            for i in 0..<arr.count{
                let dic = arr[i]
                let model = PersonageDataModel.objectWithKeyValues(dic as NSDictionary) as! PersonageDataModel
                let viewModel = PersonageViewModel()
                viewModel.model = model
                modelArr.append(viewModel)
            }
        }
        return modelArr
    }
    
    
    
    /**
     获取投资事件详情
     
     - author: zerlinda
     - date: 16-09-08 11:09:47
     
     - parameter id: 投资事件id
     */
    func getInvestDetail(_ id:String,success:@escaping (_ successTuple:(code : Int,message : String,data : Any))->Void,failed:@escaping (_ error:NSError)->Void){
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/event/investDetail.do", type:.get,param: dic,prefix:.URL,success: success, failed: failed)
    }
    
    /**
     获取并购事件详情
     
     - author: zerlinda
     - date: 16-09-08 11:09:03
     
     - parameter id: 并购事件id
     */
    func getMergerDetail(_ id:String,success:@escaping (_ successTuple:(code : Int,message : String,data : Any))->Void,failed:@escaping (_ error:NSError)->Void){
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/event/mergerDetail.do", type:.get,param: dic,prefix:.URL, success: success, failed: failed)
    }
    /**
     获取退出事件详情
     
     - author: zerlinda
     - date: 16-09-08 11:09:13
     
     - parameter id: 退出事件id
     */
    func geteExiteDetail(_ id:String,success:@escaping (_ successTuple:(code : Int,message:String,data :Any))->Void,failed:@escaping (_ error:NSError)->Void){
        
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/event/exiteDetail.do", type:.get, param: dic, prefix: .URL, success: success , failed: failed)
    }
    
    /**
     获取机构详情
     
     - author: zerlinda
     - date: 16-09-08 11:09:13
     
     - parameter id: 退出事件id
     */
    func geteInstitutionDetail(_ id:String,success:@escaping ((_ code : Int,_ message:String,_ data :InstitutionViewModel?)->Void),failed:@escaping (_ error:NSError)->Void){
        
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        
        NetWork.shareInstance.request("mobile/institution/institutionDetail.do",type:.get, param: dic,prefix: .URL, success: { (successTuple) in
            if successTuple.code == 0 {
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let viewModel = InstitutionViewModel()
                    viewModel.model = InstitutionDataModel.objectWithKeyValues(dataDic as NSDictionary) as! InstitutionDataModel
                    success(successTuple.code,successTuple.message,viewModel)
                }
            }else{
                success(successTuple.code,successTuple.message,nil)
            }
        }) { (error) in
            failed(error)
        }
        // NetWork.shareInstance.request("mobile/institution/institutionDetail.do", type: .GET, param: dic, prefix: .URL, success: success, failed: failed)
    }
    
    /**
     获取企业详情
     
     - author: zerlinda
     - date: 16-09-08 11:09:13
     
     - parameter id: 企业id
     */
    func geteEnterpriseDetail(_ id:String,success:@escaping (_ successTuple:(code : Int,message:String,data :Any))->Void,failed:@escaping (_ error:NSError)->Void){
        
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/enterprise/enterpriseDetail.do", type:.get, param: dic, prefix: .URL, success:success, failed: failed)
    }
    
    /**
     获取人物详情
     
     - author: zerlinda
     - date: 16-09-22 14:09:53
     
     - parameter id:      <#id description#>
     - parameter success: <#success description#>
     - parameter failed:  <#failed description#>
     */
    func getePersonageDetail(_ id:String,success:@escaping ((_ code : Int,_ message:String,_ data :PersonageViewModel?)->Void),failed:@escaping (_ error:NSError)->Void){
        
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        
        NetWork.shareInstance.request("mobile/cvuser/cvuserDetail.do",type:.get, param: dic,prefix: .URL, success: { (successTuple) in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let viewModel = PersonageViewModel()
                    let dicNs:NSDictionary = dataDic as NSDictionary
                    print(dicNs)
                    viewModel.model = PersonageDataModel.objectWithKeyValues(dataDic as NSDictionary) as! PersonageDataModel
                    success(successTuple.code,successTuple.message,viewModel)
                }
            }else{
                success(successTuple.code,successTuple.message,nil)
            }
        }) { (error) in
            failed(error)
        }
    }
    
    func getInstitutionCue(_ id:String,success:@escaping ((_ code : Int,_ message:String,_ data :InstitutionCueViewModel?)->Void),failed:@escaping (_ error:NSError)->Void){
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        
        NetWork.shareInstance.request("mobile/institution/institution/institutionCue.do",type:.get, param: dic,prefix: .URL, success: { (successTuple) in
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let viewModel = InstitutionCueViewModel()
                    let investDic = dataDic["investEvents"] as? [Dictionary<String,AnyObject>]
                    let model = InstitutionCueDataModel.objectWithKeyValues(dataDic as NSDictionary) as! InstitutionCueDataModel
                    if investDic != nil{
                        model.parseEventsModel(investEvents:investDic!)
                    }
                    viewModel.model = model
                    success(successTuple.code,successTuple.message,viewModel)
                }
            }else{
                success(successTuple.code,successTuple.message,nil)
            }
        }) { (error) in
            failed(error)
        }
        
    }
    
    /**
     获取企业详情
     
     - author: zerlinda
     - date: 16-09-08 11:09:13
     
     - parameter id: 企业id
     */
    func geteEnterpriseCue(_ id:String,success:@escaping (_ successTuple:(code : Int,message:String,data :Any))->Void,failed:@escaping (_ error:NSError)->Void){
        
        let dic:[String:Any]? = [
            "id":id,//关键字
            "reqFromCode":0
        ]
        NetWork.shareInstance.request("mobile/enterprise/enterpriseCue.do", type:.get, param: dic, prefix: .URL, success:success, failed: failed)
    }
    
    /// 获取数据统计信息
    func getDataSummariseCharts(type: DataSummariseType, success: @escaping NetWorkDataSummariseSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("type", value: type.rawValue, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/chart/data.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                let summarise = TinDataSummarise()
                if let dic = data as? [String: Any] {
                    summarise.update(dic)
                }
                success(code, message, summarise)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
    /// 获取机构统计表单
    func getInstitutionChart(id: String?, success: @escaping NetWorkInstitutionChartsSuccess, failed: @escaping NetWorkFailed) {
        var dic = [String: Any]()
        dic.append("id", value: id, holderForNull: "")
        NetWork.shareInstance.get(.cvSource, "mobile/chart/institution.do", params: dic, success: { (code, message, data) in
            if code == 0 {
                var charts = [IndustryChart]()
                if let dic = data as? [String: [[String: Any]]] {
                    for (key, arr) in dic {
                        let chart = IndustryChart()
                        chart.update(key: key, arr: arr)
                        charts.append(chart)
                    }
                }
                
                var yearCharts = [IndustryChart]()
                var industryCharts = [IndustryChart]()
                var roundCharts = [IndustryChart]()
                var periodCharts = [IndustryChart]()
                var unknownCharts = [IndustryChart]()
                
                var orderCharts = [IndustryChart]()
                
                for chart in charts {
                    switch chart.legend {
                    case .year:
                        yearCharts.append(chart)
                    case .industry:
                        industryCharts.append(chart)
                    case .round:
                        roundCharts.append(chart)
                    case .period:
                        periodCharts.append(chart)
                    case .unknown:
                        unknownCharts.append(chart)
                    }
                }
                
                orderCharts += yearCharts
                orderCharts += industryCharts
                orderCharts += roundCharts
                orderCharts += periodCharts
                orderCharts += unknownCharts
                
                success(code, message, orderCharts)
            } else {
                success(code, message, nil)
            }
        }, failed: failed)
    }
    
}



