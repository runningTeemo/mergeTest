//
//  QXTestVC.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class QXTestVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        let v = SegmentControl(titles: "登陆", "注册", "什么")
        
        view.addSubview(v)
        
        
        v.IN(view).LEFT.RIGHT.TOP(100).HEIGHT(60).MAKE()
        
        v.respondSelect = { idx in
            
            print(idx)
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
