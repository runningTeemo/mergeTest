//
//  TimePickCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StringPickCell: CommonCell{

    var model:FilterViewModel = FilterViewModel(){
        didSet{
           
        }
    }
    
     var dataPicker:UIPickerView = UIPickerView()
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        if model.isUnfold {
           model.cellHeight = 180
            dataPicker.isHidden = false
        }else{
            model.cellHeight = 0
            dataPicker.isHidden = true
        }
        cellLine.frame = CGRect(x: 0, y: model.cellHeight!-0.5, width: self.cellWidth, height: 0.5)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.addSubview(dataPicker)
    }

    override func layoutSubviews() {
         dataPicker.frame = self.contentView.frame
        
      //  dataPicker.backgroundColor = UIColor.redColor()
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
