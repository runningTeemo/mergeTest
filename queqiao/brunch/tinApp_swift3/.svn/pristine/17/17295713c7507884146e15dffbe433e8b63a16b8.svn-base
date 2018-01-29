//
//  ShowFontView.swift
//  touzhong
//
//  Created by zerlinda on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ShowFontView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var timer:Timer?
    
   fileprivate var showStrArr:[String] = ["小号字体","中号字体","大号字体"]
    
    var showFont:Int = 1{
        didSet{
            label.text = showStrArr[showFont]
        }
    }
    /// 展示字号
    var label:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
        self.addSubview(label)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: self.frame.width - label.frame.width, y: self.frame.height-50, width: label.frame.width, height: 50)
//        constrain(label){view in
//            view.left == view.superview!.left
//            view.bottom == view.superview!.bottom
//            view.right == view.superview!.right
//            view.height == 50
//        }
    }
    /**
     显示
     
     - author: zerlinda
     - date: 16-08-31 15:08:36
     */
    func showView(){

        self.alpha = 1
        UIView.animateKeyframes(withDuration: 0.5, delay: 1, options:[], animations: {
             self.hiddenView()
            }) { (com) in
                if !com{
                    self.hiddenView()
                }
        }
    }
    
    /**
     隐藏
     
     - author: zerlinda
     - date: 16-08-31 15:08:51
     */
    func hiddenView(){
        self.alpha = 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
