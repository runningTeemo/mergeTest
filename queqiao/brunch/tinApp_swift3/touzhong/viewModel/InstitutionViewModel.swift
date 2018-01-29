//
//  InstitutionViewModel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionViewModel: CommonViewModel {
    var model:InstitutionDataModel = InstitutionDataModel()
    var isShowFieldView:Bool = false
    var teamMembersCellHeght:CGFloat = 0
    var baseInforCellHeight:CGFloat = 0
    var belongCategoryHeight:CGFloat = 0
    override init() {
        super.init()
        cellHeight = 110
    }
}
