//
//  CommonDataDetailViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CommonDataDetailViewController: QXYRootTableViewController {

    override func viewDidLoad() {
     super.viewDidLoad()
        
        
    }
    func codesignError(){
        Account.sharedOne.logout()
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    
}
