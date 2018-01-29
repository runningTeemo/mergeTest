//
//  DataCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class DataCell: CommonCell {
    
    
    /// 标的企业
    var targetCompanyL:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    //    ///公司行业
    //    var categoryLabel:UILabel = {
    //        let label = UILabel()
    //        label.textColor = MyColor.colorWithHexString("#fda271")
    //        label.layer.borderWidth = 0.5
    //        label.layer.borderColor = MyColor.colorWithHexString("#fda271").cgColor
    //        label.textAlignment = NSTextAlignment.center
    //        label.font = UIFont.systemFont(ofSize: 10)
    //        label.layer.cornerRadius = 2
    //        label.layer.masksToBounds = true
    //        return label
    //    }()
    /// 投资金额
    var moneyLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// 阶段
    var phaseLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = MyColor.colorWithHexString("#3aaaf1")
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 10)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    /// 融资时间
    var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#666666")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var typeLabel:UILabel = {
        let label = UILabel()
        label.textColor = mainBlueColor
        label.layer.borderWidth = 0.5
        label.layer.borderColor = mainBlueColor.cgColor
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    /// 参与公司
    var paticipateCompany:ParticipationView = {
        let view = ParticipationView()
        view.mainColor = MyColor.colorWithHexString("#3aaaf1")
        view.textFont = 14
        return view
    }()
    
    var mainColor:UIColor = UIColor.black{
        didSet{
            self.phaseLabel.backgroundColor = mainColor
            self.paticipateCompany.mainColor = mainColor
            self.typeLabel.textColor = mainColor
            self.typeLabel.layer.borderColor = mainColor.cgColor
        }
    }
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        targetCompanyL.frame = CGRect(x: leftStartX, y: 20, width: targetCompanyL.frame.width, height: targetCompanyL.frame.height)
        let phaseW = phaseLabel.frame.width + leftStartX*2.0 + 10
        let maxW = cellWidth - phaseW
        if targetCompanyL.frame.width >= maxW && cellWidth>0{
            targetCompanyL.frame = CGRect(x: leftStartX, y: 20, width: maxW, height: targetCompanyL.frame.height)
        }
        phaseLabel.frame = CGRect(x: cellWidth-phaseLabel.frame.width - leftStartX - 5, y: 20, width: phaseLabel.frame.size.width+5, height: phaseLabel.frame.size.height+4)
        phaseLabel.center = CGPoint(x: phaseLabel.center.x, y: targetCompanyL.center.y)
        //按需求去掉行业
        //        categoryLabel.frame = CGRect(x: targetCompanyL.frame.maxX + 10, y: 20+3, width: categoryLabel.frame.size.width+5, height: categoryLabel.frame.size.height+4)
        
        moneyLabel.frame = CGRect(x: leftStartX, y: targetCompanyL.frame.maxY + 10, width: moneyLabel.frame.width, height: moneyLabel.frame.height)
        typeLabel.frame = CGRect(x: leftStartX, y: moneyLabel.frame.maxY + 10, width: 15, height: 15)
        paticipateCompany.frame = CGRect(x: typeLabel.frame.maxX + 10, y: moneyLabel.frame.maxY + 10, width: cellWidth - (typeLabel.frame.maxX + 10), height: 20)
        paticipateCompany.update()
        paticipateCompany.center = CGPoint(x: paticipateCompany.center.x , y: typeLabel.center.y)
        
        timeLabel.frame = CGRect(x: cellWidth-timeLabel.frame.width - leftStartX, y: phaseLabel.frame.maxY + 15, width: timeLabel.frame.width, height: timeLabel.frame.height)
        if paticipateCompany.frame.height == 0 {
            cellLine.frame = CGRect(x: 12.5, y: timeLabel.frame.maxY + 14, width: cellWidth-25, height: 0.5)
        }else{
            cellLine.frame = CGRect(x: 12.5, y: paticipateCompany.frame.maxY + 14, width: cellWidth-25, height: 0.5)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(targetCompanyL)
        // self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(moneyLabel)
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(paticipateCompany)
        self.contentView.addSubview(phaseLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
}
