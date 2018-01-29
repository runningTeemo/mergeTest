//
//  CommonLabel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CommonLabel: UILabel {

    var maxWith:CGFloat = 0.0{
        didSet{
            if self.frame.width > maxWith {
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: maxWith, height: self.frame.height)
            }
        }
    }
    var maxWordNum:Int = 0{
        didSet{
           
        }
    }

}
