//
//  ViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/8/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.setTitle(NSLocalizedString("你好", comment:"你"), for: UIControlState());
        self.view.addSubview(btn)
        print(NSLocalizedString("你好", comment:"发"))
        btn.backgroundColor = UIColor.red
        
//        Alamofire.request(.GET, "https://api.500px.com/v1/photos").responseJSON() {
//            (_, _, data, _) in
//            println(data)
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

