//
//  EnterpriseMergerCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class EnterpriseMergerCell: CommonCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var enterPriseId:String? //企业ID或者是机构ID
    var viewModel:MergerViewModel = MergerViewModel(){
        didSet{
            fillData()
            timeLabel.text = SafeUnwarp(viewModel.model.happenDate, holderForNull: "")
            if viewModel.model.aimedEnterprise?.id == enterPriseId{
                moneyLabel.text = "受资\(SafeUnwarp(viewModel.model.amount, holderForNull: ""))"
            }else{
                moneyLabel.text = "出资\(SafeUnwarp(viewModel.model.amount, holderForNull: ""))"
            }
            moneyLabel.sizeToFit()
            /// 默认去简称 简称没有取全称
            let cnName = SafeUnwarp(viewModel.model.aimedEnterprise?.cnName, holderForNull: "")
            targetCompanyLabel.text = SafeUnwarp(viewModel.model.aimedEnterprise?.shortCnName, holderForNull: cnName)
            targetCompanyLabel.sizeToFit()
            var arr:[String]? = [String]()
            if let enterList = viewModel.model.buyEnterpriseList {
                for enterprise in enterList {
                    if let name = enterprise.shortCnName {
                        //arr?.append(name)
                         arr?.append("\(name) \(SafeUnwarp(enterprise.amount, holderForNull: ""))")
                    }
                }
            }
            titiArr = arr
            finacingView.textArr = titiArr!
            addModuleAndChangeFrame()
        }
    }
    
    func fillData(){
        
    }
    
    var titiArr:[String]? = [String]()
    
    var  timeLabel:DotLabel = {
        let label = DotLabel()
        label.mainColor = UIColor.red
        return label
    }()
    
    var  moneyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var finacingView:LeftAndRightLabel = LeftAndRightLabel()
    
    var targetBorderLabel:BorderLabel = {
        let label = BorderLabel()
        label.referenceWidth = 0
        label.referenceHeight = 0
        label.textStr = "标"
        label.mainColor = mainBlueColor
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.layer.borderColor = mainBlueColor.cgColor
        label.layer.borderWidth = 0.4
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    /// 标的企业
    var targetCompanyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var buyBorderLabel:BorderLabel = {
        let label = BorderLabel()
        label.referenceWidth = 0
        label.referenceHeight = 0
        label.textStr = "投"
        label.mainColor = mainBlueColor
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.layer.borderColor = mainBlueColor.cgColor
        label.layer.borderWidth = 0.4
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    
    override func addModuleAndChangeFrame(){
        if cellWidth==0 {
            return
        }
        timeLabel.frame = CGRect(x: leftStartX, y: 15, width: timeLabel.frame.size.width, height: timeLabel.frame.size.height)
        moneyLabel.frame = CGRect(x: cellWidth/2, y: 15, width: cellWidth/2, height: moneyLabel.frame.size.height)
        targetBorderLabel.frame = CGRect(x: leftStartX, y: timeLabel.frame.maxY + 10, width: targetBorderLabel.frame.width+6, height: targetBorderLabel.frame.height+6)
        targetCompanyLabel.frame = CGRect(x: targetBorderLabel.frame.maxX + 10, y: timeLabel.frame.maxY + 10, width: targetCompanyLabel.frame.width, height: targetCompanyLabel.frame.height)
        buyBorderLabel.frame = CGRect(x: leftStartX, y: targetBorderLabel.frame.maxY + 12, width: buyBorderLabel.frame.width+6, height: buyBorderLabel.frame.height+6)
        viewModel.cellHeight = buyBorderLabel.frame.maxY+15
        let startY:CGFloat = targetBorderLabel.frame.maxY+12
        finacingView.frame = CGRect(x: buyBorderLabel.frame.maxX+10, y: startY, width: cellWidth - leftStartX*2-15, height: 30)
        finacingView.update()
        if titiArr?.count != 0 {
            viewModel.cellHeight = finacingView.frame.maxY+15
        }
        cellLine.frame = CGRect(x: leftStartX, y: viewModel.cellHeight!-0.5, width: cellWidth-40, height: 0.5)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(moneyLabel)
        self.contentView.addSubview(targetBorderLabel)
        self.contentView.addSubview(targetCompanyLabel)
        self.contentView.addSubview(buyBorderLabel)
        self.contentView.addSubview(finacingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
