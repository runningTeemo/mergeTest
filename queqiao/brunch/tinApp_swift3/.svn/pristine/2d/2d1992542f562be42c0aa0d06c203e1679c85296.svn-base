//
//  CustomTabbarController.swift
//  touzhong
//
//  Created by zerlinda on 16/8/15.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CustomTabBarController: CommonTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appendChildViewController(IndexViewController(), title: "测试1", imageName:"tagHome",selectImage:"tagHome", tag: 1)
        let vc = DataViewController()
        DataManager.shareInstance.dataVC = vc
        self.appendChildViewController(DataManager.shareInstance.dataVC, title: "数据", imageName:"tabBarImg.png",selectImage:"tabBarImg.png", tag: 2)
        self.appendChildViewController(ArticleMainViewControler(), title: "测试3", imageName:"tabBarImg.png",selectImage:"tabBarImg.png", tag: 3)
        self.appendChildViewController(MeMainViewController(), title: "测试4", imageName:"tabBarImg.png",selectImage:"tabBarImg.png", tag: 4)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
