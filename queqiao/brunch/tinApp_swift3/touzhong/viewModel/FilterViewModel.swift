//
//  FilterViewModel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FilterViewModel: CommonViewModel {
    var isUnfold:Bool = false
    var categoryName:String?//显示的类别
    var showDic:[String:String] = [String:String]()
    var valueDic:[String:String] = [String:String]()
    var showArray:[String] = [String]()
    var minFound:String?
    var maxFound:String?
    var startIndex:Int? = 0
    var endIndex:Int? = 0
    var moneyDic:[String:[String]]? = [String:[String]]()
    var selectArr:NSMutableArray = NSMutableArray()//存放key
    var isStartTime:Bool = true
    var singleSelect:Bool = false//是否是单选
    override init() {
        super.init()
        self.cellHeight = 150
    }
}
