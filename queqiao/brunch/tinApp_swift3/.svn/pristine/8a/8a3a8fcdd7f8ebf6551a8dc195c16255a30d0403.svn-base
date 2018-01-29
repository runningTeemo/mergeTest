//
//  HornCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class HornCell: CommonCell {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var hornViewModel:HornViewModel = HornViewModel(){
        didSet{

            nameLabel.text = "广播喇叭"
            nameLabel.sizeToFit()
            infoLabel.text = "发布信息科使用，广播给所有人"
            infoLabel.sizeToFit()
            timeLabel.text = "有效期至："
            if let s1 = hornViewModel.model.expiryTime {
                let s = s1 as NSString
                let date = Date(timeIntervalSince1970: s.doubleValue / 1000)
                if let d = DateTool.getDateString(date) {
                    timeLabel.text = "有效期至：" + d
                }
            }
            
            timeLabel.sizeToFit()
            addModuleAndChangeFrame()
        }
    }
    
    var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
       return view
    }()
    
    var imageV:UIImageView = {
        let imageV = UIImageView()
        //imageV.layer.cornerRadius = 33
        imageV.layer.masksToBounds = true
        imageV.image = UIImage(named: "hornBig")
        return imageV
    }()
    
    var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#333333")
        return label
    }()
    
    var infoLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    
    var selectStateImageV:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 9
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "radioBox")
        return imageView
    }()
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        contentView.backgroundColor = mainBgGray
        hornViewModel.cellHeight = 97 + 10
        bgView.frame = CGRect(x: leftStartX, y: 10, width: cellWidth-leftStartX*2, height: 97)
        imageV.frame = CGRect(x: leftStartX, y: 15.5, width: 58, height: 38)
        nameLabel.frame = CGRect(x: imageV.frame.maxX+20, y: 15.5, width: nameLabel.frame.width, height: nameLabel.frame.height)
        infoLabel.frame = CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.maxY+13, width: infoLabel.frame.width, height: infoLabel.frame.height)
        timeLabel.frame = CGRect(x: nameLabel.frame.origin.x, y: infoLabel.frame.maxY+6, width: timeLabel.frame.width, height: timeLabel.frame.height)
        selectStateImageV.frame = CGRect(x: bgView.frame.width-leftStartX-18, y: (97-18)/2, width: 18, height: 18)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(imageV)
        bgView.addSubview(nameLabel)
        bgView.addSubview(infoLabel)
        bgView.addSubview(timeLabel)
        bgView.addSubview(selectStateImageV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if !selected {
            selectStateImageV.image = UIImage(named: "radioBox")
        }else{
            selectStateImageV.image = UIImage(named: "radioBoxSelect")
        }
    }

    
}
