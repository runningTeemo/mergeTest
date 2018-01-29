//
//  QXYContentScrollView.swift
//  touzhong
//
//  Created by zerlinda on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class QXYContentScrollView: UIScrollView {
    
    var viewArr:[UIViewController]? = [UIViewController](){
        didSet{
           // addView()
        }
    }
    var viewCount:Int? = 1
    
    fileprivate func addView(){
        for viewC in viewArr!{
            self.addSubview(viewC.view)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if viewArr != nil {
            self.contentSize = CGSize(width: self.frame.size.width*CGFloat(viewArr!.count), height: 0)
        }
        
    }
    
    
}
