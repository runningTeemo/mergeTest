//
//  LineLabel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LineLabel: RootView {
    
    var mainColor:UIColor?{
        didSet{
            lineView.backgroundColor = mainColor
        }
    }
    var widthGap:CGFloat = 15
    
    var maxWidth:CGFloat = 999{
        didSet{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: label.frame.maxX, height: label.frame.size.height)
            if self.frame.maxX>maxWidth {
                self.label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: maxWidth-label.frame.origin.x, height: label.frame.height)
            }
        }
    }
    
    var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = MyColor.colorWithHexString("#999999")
        return view
    }()
    
    var label:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    var lineHidden:Bool = false{
        didSet{
            if lineHidden {
                lineView.isHidden = true
                label.frame = CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height)
            }else{
                lineView.isHidden = false
                label.frame = CGRect(x: widthGap, y: 0, width: label.frame.width, height: label.frame.height)
            }
            
        }
    }
    
    var text:String?{
        didSet{
            if text==nil || text?.characters.count==0 {
                lineHidden = true
            }else{
                lineHidden = false
            }
            label.text = text
            label.sizeToFit()
            lineView.frame = CGRect(x: 0, y: 3, width: 1, height: label.frame.size.height-6)

            if lineHidden {
                lineView.isHidden = true
                label.frame = CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height)
            }else{
                label.frame = CGRect(x: widthGap, y: 0, width: label.frame.size.width, height: label.frame.size.height)
            }
            if label.text==nil||label.text?.characters.count==0 {
                lineView.isHidden = true
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 0, height: label.frame.size.height)
            }else{
               lineView.isHidden = lineHidden
               self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: label.frame.maxX, height: label.frame.size.height)
            }
            if self.frame.maxX>maxWidth {
                self.label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: maxWidth-label.frame.origin.x, height: label.frame.height)
            }
        }
    }
    
    func update(){
        if !lineHidden {
            lineView.frame = CGRect(x: 0, y: 0, width: 1, height: label.frame.size.height-6)
        }
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width, height: self.frame.height)
        if !lineHidden {
            lineView.center = CGPoint(x: lineView.center.x, y: label.center.y)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineView.frame = CGRect(x: 0, y: 2, width: 1, height: label.frame.size.height-4)
        label.frame = CGRect(x: widthGap, y: 0, width: label.frame.size.width, height: label.frame.size.height)
        self.addSubview(lineView)
        self.addSubview(label)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
