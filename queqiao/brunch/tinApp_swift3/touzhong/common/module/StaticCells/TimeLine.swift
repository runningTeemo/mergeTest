//
//  TimeLine.swift
//  touzhong
//
//  Created by zerlinda on 16/8/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TimeLine: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var timeTextColor:UIColor! = UIColor.white
    var timeBgColor:UIColor! = UIColor.red
    /// 线的颜色
    var lineColor:UIColor! = UIColor.lightGray
    /// 显示的时间
    var timeStr:String? = ""{
        didSet{
            timeLabel.text = timeStr
        }
    }

    /// 时间轴
    lazy var timeLabel:UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = self.timeTextColor
        timeLabel.backgroundColor = self.timeBgColor
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textAlignment = NSTextAlignment.center
        return timeLabel
    }()
    /// 时间上面的线
    lazy var topLine:UIView = {
        let topLine = UIView()
        topLine.backgroundColor = self.lineColor
        return topLine
    }()
    /// 时间下面的线
    lazy var bottomLine:UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.lineColor
        return bottomLine
    }()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
      }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(timeLabel)
        self.addSubview(topLine)
        self.addSubview(bottomLine)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.frame = CGRect(x: 20, y: 10, width: self.frame.height - 20, height: self.frame.height)
        timeLabel.layer.cornerRadius = (self.bounds.size.height-20)/2
        timeLabel.layer.masksToBounds = true
        topLine.frame = CGRect(x: timeLabel.center.x-0.5, y: 0, width: 1, height: self.frame.height)
        bottomLine.frame = CGRect(x: 20, y: timeLabel.frame.maxY, width: 1, height: self.frame.height - timeLabel.frame.maxY)

    }

}
