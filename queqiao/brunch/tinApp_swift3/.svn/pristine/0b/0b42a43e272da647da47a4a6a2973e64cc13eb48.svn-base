//
//  LabelTextField.swift
//  touzhong
//
//  Created by zerlinda on 16/8/24.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LabelTextField: UIView {

//    var label:UILabel!
    
   override init(frame: CGRect) {
    super.init(frame: frame)
    
    }
    var labelText:String = ""{
        didSet{
            
        }
    }
    var textStr:String{
        get{
            return textField.text!
        }
    }
    
    var label:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    var textField:UITextField = {
       let textField = UITextField()
        textField.textColor = UIColor.black
        return textField
    }()
    
    override func layoutSubviews() {
       label.frame = CGRect(x: 0, y: 0, width: 80, height: self.frame.height)
        textField.frame = CGRect(x: label.frame.maxX, y: 0, width: self.frame.width-label.frame.maxX, height: self.frame.height)
//        constrain(self.label){view in
//            view.top == view.superview!.top
//            view.left == view.superview!.left
//            view.height == view.superview!.height
//            view.width == 80
//        }
//        constrain(self.textField,self.label){ view,labelView in
//            view.top == view.superview!.top
//            view.left == labelView.right
//            view.height == view.superview!.height
//            view.right == view.superview!.right
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
