//
//  QXYTitleLabel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class QXYTitleLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var labaleZoomMultiple: CGFloat = 0.3
    var startColor:(R: CGFloat, G: CGFloat, B: CGFloat)?{
        didSet{
            textColor = UIColor(red: startColor!.R, green: startColor!.G, blue: startColor!.B, alpha: 1)
        }
    }
    var endColor: (R: CGFloat, G: CGFloat, B: CGFloat)?{
        didSet{
           // self.bottomLine.backgroundColor = UIColor(red: endColor!.R, green: endColor!.G, blue: endColor!.B, alpha: 1)
        }
    }
    var scale: CGFloat = 0 {
        didSet {
            textColor = UIColor(red: startColor!.R + (endColor!.R - startColor!.R) * scale, green: startColor!.G + (endColor!.G - startColor!.G) * scale, blue: startColor!.B + (endColor!.B - startColor!.B) * scale, alpha: 1.0)
            bottomLine.alpha = scale
        }
    }
    var labelLineColor:UIColor?{
        didSet{
            self.bottomLine.backgroundColor = labelLineColor
        }
    }
    /// 标签字体的大小
    var labelFontSize:CGFloat = 14{
        didSet{
            self.font = UIFont.systemFont(ofSize: labelFontSize)
        }
    }
    
    var bottomLine:UIView = {
       let lineView = UIView()
        lineView.alpha = 0
        return lineView
    }()
    
    var defaultBottomLine:UIView = {
        let lineView = UIView()
        lineView.alpha = 1
        lineView.backgroundColor = labelBottomLineGrayColor
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = NSTextAlignment.center
        self.isUserInteractionEnabled = true
        self.addSubview(defaultBottomLine)
        self.addSubview(bottomLine)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        defaultBottomLine.frame = CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 1)
        bottomLine.frame = CGRect(x: (self.frame.width-getLineWidth())/2, y: self.frame.height-2, width: getLineWidth(), height: 2)
 
    }
    
    /**
     底部的横线要和字体一样宽
     
     - author: zerlinda
     - date: 16-09-04 15:09:05
     */
    func getLineWidth()->CGFloat{
        let label = UILabel()
        label.text = self.text
        label.sizeToFit()
        return label.frame.size.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
