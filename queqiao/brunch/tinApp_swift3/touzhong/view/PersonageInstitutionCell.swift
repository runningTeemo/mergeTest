//
//  PersonageInstitutionCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PersonageInstitutionCell: CommonCell {

    var viewModel:FinacingViewModel = FinacingViewModel(){
        didSet{
            timeLabel.text = SafeUnwarp(viewModel.model.happenDate, holderForNull: "")
            timeLabel.sizeToFit()
            companyLabel.text = SafeUnwarp(viewModel.model.aimedEnterprise?.shortCnName, holderForNull: "")
            companyLabel.sizeToFit()
            phaseLabel.text = SafeUnwarp(viewModel.model.round, holderForNull: "")
            phaseLabel.sizeToFit()
            moneyLabel.text = SafeUnwarp(viewModel.model.amount, holderForNull: "")
            moneyLabel.sizeToFit()
            addModuleAndChangeFrame()
        }
    }
    var indexPath:IndexPath?{
        didSet{
            //            if indexPath?.row == 0 {
            //                topLine.hidden = true
            //            }
        }
    }
    var topLine:UIView = {
        let view = UIView()
        view.backgroundColor = MyColor.colorWithHexString("#b2b2b2")
        return view
    }()
    var bottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = MyColor.colorWithHexString("#b2b2b2")
        return view
    }()
    var circleView:UIView = {
        let label = UIView()
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.layer.borderColor = mainBlueGreenColor.cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = UIColor.white
        let view = UIView()
        view.frame = CGRect(x: 4, y: 4, width: 6, height: 6)
        view.backgroundColor = mainBlueGreenColor
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        label.addSubview(view)
        return label
    }()
    /// 显示时间
    var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    /// 公司
    var companyLabel:CommonLabel = {
        let label = CommonLabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = MyColor.colorWithHexString("#333333")
        return label
    }()
    /// 阶段
    var phaseLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = mainBlueColor
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 10)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    var moneyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override func addModuleAndChangeFrame(){
        if cellWidth == 0 {
            return
        }
        timeLabel.frame = CGRect(x: 60, y: 15, width: timeLabel.frame.width, height: timeLabel.frame.height)
        companyLabel.frame = CGRect(x: 60, y: timeLabel.frame.maxY+10, width: companyLabel.frame.width, height: companyLabel.frame.height)
        companyLabel.maxWith = cellWidth - 20 - moneyLabel.frame.width - 20 - phaseLabel.frame.width - 20 - 60
        phaseLabel.frame = CGRect(x: companyLabel.frame.maxX+20, y: companyLabel.frame.origin.y, width: phaseLabel.frame.width+4, height: phaseLabel.frame.height+4)
        phaseLabel.center = CGPoint(x: phaseLabel.center.x, y: companyLabel.center.y)
        moneyLabel.frame = CGRect(x:phaseLabel.frame.maxX + 20, y: 0, width: moneyLabel.frame.width, height: moneyLabel.frame.height)
        moneyLabel.center = CGPoint(x: moneyLabel.center.x, y: companyLabel.center.y)
        viewModel.cellHeight = timeLabel.frame.maxY+10+companyLabel.frame.size.height+15
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(circleView)
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(companyLabel)
        self.contentView.addSubview(phaseLabel)
        self.contentView.addSubview(moneyLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.frame = CGRect(x: 20, y: 0, width: 0.5, height: 20)
        circleView.frame = CGRect(x: topLine.center.x-7, y: 20, width: 14, height: 14)
        bottomLine.frame = CGRect(x: 20, y: circleView.frame.maxY, width: 0.5, height: self.frame.height - circleView.frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
