//
//  hornViewModel.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class HornViewModel: CommonViewModel {
    var model:HornDataModel = HornDataModel()
    var isSelect:Bool = false
    override  init() {
        super.init()
        cellHeight = 0.001
    }
}
