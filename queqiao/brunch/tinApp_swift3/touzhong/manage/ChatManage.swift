//
//  ChatManage.swift
//  touzhong
//
//  Created by zerlinda on 2016/10/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum projectApplyViewStatus:Int {
    case notExist = 4000
    case pass = 4003
    case applying = 4002
    case notApply = 4001
}

class ChatManage: NSObject {
    
    static let shareInstance = ChatManage()
        
    ///登录
    func loginHuanxin(){
        let error  = EMClient.shared().login(withUsername:Account.sharedOne.user.huanXinId, password:"123456")
        print(error ?? "")
        
        if error == nil{
            print("环信登录成功")
            EMClient.shared().options.isAutoLogin = true
            ChatManage.shareInstance.getAllUnReadMessage()
        }else{
            print("登录环信失败")
            print("\(error?.code)"+(error?.errorDescription)!)
        }
        
    }
    ///退出登录
    func outLogin(){
        let error = EMClient.shared().logout(true)
        if error != nil{
            print("退出登录成功")
        }
    }
    //获取所有未读消息
    func getAllUnReadMessage(){
        let conversationArr = EMClient.shared().chatManager.getAllConversations()
        var unReadMessage:Int32 = 0
        if conversationArr != nil {
            for conversation in conversationArr! {
                let cv = conversation as? EMConversation
                unReadMessage += (cv?.unreadMessagesCount)!
            }
        }
        Account.sharedOne.messagesBadge = Int(unReadMessage)
    }
    func getLastMessage()->EaseConversationModel?{
        let conversationArr = EMClient.shared().chatManager.getAllConversations()
        var lastMessage:EMMessage?
        var lastConversation:EMConversation?
        if conversationArr != nil {
            for conversation in conversationArr! {
                let cv = conversation as? EMConversation
                let message = cv?.latestMessage
                let messageTimestemp = SafeUnwarp(message?.timestamp, holderForNull: 0)
                let lastMessageTimestemp = SafeUnwarp(lastMessage?.timestamp, holderForNull: 0)
                if messageTimestemp > lastMessageTimestemp {
                    lastMessage = message
                    lastConversation = cv
                }
            }
        }
        let model = EaseConversationModel(conversation: lastConversation)
        return  model
    }
    //发送申请查看页面
    func sendApplyCheck(articleModel:Article, user:User, model:ProjectViewCommitDataModel) {
        let message = EaseSDKHelper.sendTextMessage("[申请查看项目]", to: user.huanXinId, messageType: EMChatTypeChat, messageExt: nil)
        var extM = message?.ext
        if (extM == nil) {
            extM = [String:AnyObject]()
        }
        if (user.userName == nil) {
            user.userName = "";
        }
        extM?.append(postMessageName, notNullValue:SafeUnwarp(Account.sharedOne.user.realName, holderForNull: ""))
        extM?.append(postMessageImg, notNullValue: SafeUnwarp(Account.sharedOne.user.avatar, holderForNull: ""))
        extM?.append(postMessageId, notNullValue: SafeUnwarp(Account.sharedOne.user.huanXinId, holderForNull: ""))
        extM?.append(reciveMessageName, notNullValue: SafeUnwarp(user.realName, holderForNull: ""))
        extM?.append(reciveMessageImg, notNullValue: SafeUnwarp(user.avatar, holderForNull: ""))
        extM?.append(applyCheckMessage, notNullValue: "1")
        
        
      //  let dic = model.keyValues
        let dic = articleModel.origenDic
        if dic != nil {
            extM?.append(articleShareDic, notNullValue: dic!)
        }
        
        let modelDic = model.keyValues
        if modelDic != nil{
            extM?.append(commitProjectModel, notNullValue: modelDic)
        }
        
//        print(articleModel)
//        print(dic)
//        print(modelDic)
        message?.ext = extM
        EMClient.shared().chatManager.send(message, progress: nil, completion:{message,error in
            print(error ?? "")
            print(error?.errorDescription)
        })
    
        
    }
    
    /// 把文章分享给自己的好友
    ///（因为八卦没有数据模型，所以传输就直接用文章模型传输了）
    /// - Parameters:
    ///   - articleModel: 文章模型
    ///   - user: 分享的目标
    func shareAticleToFriends(articleModel:Article,user:User){
        var messageText = ""
        switch articleModel.type {
        case .normal:
            messageText = "[八卦]"
        case .manpower:
            messageText = "[人才]"
        case .activity:
            messageText = "[活动]"
        case .project:
            messageText = "[项目]"
        default: break
        }
        let message = EaseSDKHelper.sendTextMessage(messageText, to: user.huanXinId, messageType: EMChatTypeChat, messageExt: nil)
        var extM = message?.ext
        if (extM == nil) {
            extM = [String:AnyObject]()
        }
        if (user.userName == nil) {
            user.userName = "";
        }
        extM?.append(postMessageName, notNullValue:SafeUnwarp(Account.sharedOne.user.realName, holderForNull: ""))
        extM?.append(postMessageImg, notNullValue: SafeUnwarp(Account.sharedOne.user.avatar, holderForNull: ""))
        extM?.append(postMessageId, notNullValue: SafeUnwarp(Account.sharedOne.user.huanXinId, holderForNull: ""))
        extM?.append(reciveMessageName, notNullValue: SafeUnwarp(user.realName, holderForNull: ""))
        extM?.append(reciveMessageImg, notNullValue: SafeUnwarp(user.avatar, holderForNull: ""))
        extM?.append(articleShareDic, notNullValue: SafeUnwarp(articleModel.origenDic, holderForNull: [String:Any]()))
        extM?.append(applyCheckMessage, notNullValue: "2")
        message?.ext = extM
    
        EMClient.shared().chatManager.send(message, progress: nil, completion:{message,error in
            print(error ?? "")
        })
    }
    
    /// 发现中得项目申请查看
    ///
    /// - Parameters:
    ///   - articleModel: 文章模型
    ///   - model: 申请查看模型
    ///   - success: 成功
    ///   - failed: 失败
    func applyCheckCommit(articleModel:Article,model:ProjectViewCommitDataModel, success:@escaping ((_ code : Int,_ message : String,_ data :ProjectViewCommitDataModel?)->Void),failed:@escaping (_ error:NSError)->Void){
        let dic:[String:Any] = [
            "id":SafeUnwarp(model.id, holderForNull: ""),
            "projectId": SafeUnwarp(model.projectId, holderForNull: ""),
            "projectUserId": SafeUnwarp(model.projectUserId, holderForNull:""),
            "applyUserId": SafeUnwarp(model.applyUserId?.replacingOccurrences(of: "_", with: "-"), holderForNull: ""),
            "applyStatus": SafeUnwarp(model.applyStatus, holderForNull: ""),
            //"createTime": SafeUnwarp(model.createTime, holderForNull: "")
        ]
        print(model)
        print(dic)
        NetWork.shareInstance.request("mobile/project/view/commit.do", type: .post, param: dic, prefix: .URL, success: {(successTuple)in
            print(successTuple.code)
            print(successTuple.data)
            print(successTuple.message)
            if successTuple.code == 0{
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let model = ProjectViewCommitDataModel.objectWithKeyValues(dataDic as NSDictionary) as! ProjectViewCommitDataModel
                    success(0,successTuple.message,model)
                }
                success(0,successTuple.message,nil)
            }else{
                success(successTuple.code, successTuple.message, nil)
            }
            
        }, failed:failed)
    }
    
    func applyValidate(projectId:String?,applyUserId:String?,success:@escaping ((_ code : Int,_ message : String,_ data :Bool?)->Void),failed:@escaping (_ error:NSError)->Void){
        let dic:[String:Any] = [
            "userId":SafeUnwarp(applyUserId?.replacingOccurrences(of: "_", with: "-"), holderForNull: ""),
            "projectId":SafeUnwarp(projectId, holderForNull: "")
        ]
        NetWork.shareInstance.request("mobile/project/view/validate.do", type: .get, param: dic, prefix: .URL, success: {(successTuple)in
            print(successTuple.code)
            print(successTuple.message)
//            print(dataB)
            let dataB = successTuple.data as? Bool
            success(successTuple.code,successTuple.message,dataB)
        }, failed:failed)
        
    }
    
}
