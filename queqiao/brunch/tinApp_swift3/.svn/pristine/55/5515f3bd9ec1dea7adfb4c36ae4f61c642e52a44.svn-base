//
//  ProjectViewCommitDataModel.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ProjectViewCommitDataModel: RootDataModel {
    
    var id:String?
    var projectId:String?
    var projectUserId:String?
    var applyStatus: String? //2成功， 1申请中或失败
    var applyUserId:String?
    var createTime:String?
    var updateTime:String?
    var deleted:String?
    var indexFlag:String?
    
    var user: User = User()
    
    var createDate: Date?
    
    func update(_ dic: [String: Any]) {
        
        id = dic.nullableString("id")
        projectId = dic.nullableString("projectId")
        projectUserId = dic.nullableString("projectUserId")
        applyStatus = dic.nullableString("applyStatus")
        applyUserId = dic.nullableString("applyUserId")
        createTime = dic.nullableString("createTime")
        updateTime = dic.nullableString("updateTime")
        
        createDate = dic.nullableDate("createTime")
        
        if let userDic = dic["applyUser"] as? [String: Any] {
            let user = User()
            user.updateInCircle(userDic)
            self.user = user
        }
        if let id = user.id {
           applyUserId = id
        }
        
    }
    
    var cellHeight:CGFloat = 0.001//方便消息之间的传送 只此一个数据模型加入了cellHeight，其他要写在viewModel里面
}
