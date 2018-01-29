//
//  TimeLineCell.swift
//  touzhong
//
//  Created by zerlinda on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TimeLineCell: CommonCell {

    var timeTextColor:UIColor! = UIColor.white
    var timeBgColor:UIColor! = UIColor.blue
    var lineColor:UIColor! = UIColor.lightGray
    var timeFirstColor:UIColor! = UIColor.red
    var indexPath:IndexPath = IndexPath.init(row: 0, section: 0){
        didSet{
            if indexPath.row==0 {
                self.timeLine.isHidden = false
                self.verticalLine.isHidden = true
                if indexPath.section==0 {
                    self.timeLine.timeBgColor = self.timeFirstColor
                    self.timeLine.topLine.isHidden = true
                }else{
                    self.timeLine.timeBgColor = self.timeBgColor
                }
            }else{
                self.timeLine.isHidden = true
                self.verticalLine.isHidden = false
            }
        }
    }
    var model:TestTimeLineModel = TestTimeLineModel(){
        didSet{
            timeLine.timeStr = model.timeLineStr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /// 显示时间
    lazy var timeLine:TimeLine = {
       let timeLine = TimeLine()
        timeLine.timeTextColor = self.timeTextColor
        timeLine.isHidden = true
       return timeLine
    }()

    lazy var verticalLine:UIView = {
        let verticalLine = UIView()
        verticalLine.backgroundColor = self.lineColor
        return verticalLine
    }()
    /**
     自动布局约束
     
     - author: zerlinda
     - date: 16-08-29 11:08:42
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLine.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        cellLine.frame = CGRect(x: timeLine.frame.maxX+10, y: self.frame.maxY-0.5, width: self.frame.width-(timeLine.frame.maxX+10), height: 0.5)
        self.verticalLine.frame = CGRect(x: timeLine.center.x-0.5, y: 0, width: 1, height: self.frame.height)
        
//        constrain(self.timeLine){view in
//            view.top == view.superview!.top
//            view.left == view.superview!.left
//            view.height == view.superview!.height
//            view.width == view.height
//        }
//        constrain(self.cellLine,self.timeLine){view,timeLine in
//            
//            view.left == timeLine.right+10
//            view.height == 0.5
//            view.right == view.superview!.right
//            view.bottom == view.superview!.bottom
//        }
//        constrain(self.verticalLine,self.timeLine){view,timeLine in
//            view.top == view.superview!.top
//            view.centerX == timeLine.centerX + 10
//            view.height == view.superview!.height
//            view.width == 1
//        }
        
}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.addSubview(self.timeLine)
        self.contentView.addSubview(self.verticalLine)
        self.contentView.backgroundColor = UIColor.green
      
    }

}
