//
//  TestV.swift
//  touzhong
//
//  Created by zerlinda on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TestV: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var group:ConstraintGroup = ConstraintGroup()
    
    override func layoutSubviews() {
         super.layoutSubviews()
        constrain(self,replace: self.group){ view in
            view.width == view.superview!.width
            view.height == 500
        }
     
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
//        constrain(self,replace: self.group){ view in
//            view.height == 500
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
