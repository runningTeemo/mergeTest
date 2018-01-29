//
//  InstitutionCueViewModel.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/3.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionCueViewModel: CommonViewModel {
     var model:InstitutionCueDataModel? = InstitutionCueDataModel()
   override init() {
        super.init()
        cellHeight = 0.001
    }
}
