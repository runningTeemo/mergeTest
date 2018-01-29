//
//  EnterpriseFinancingCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class EnterpriseFinancingCell: CommonCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var enterPriseId:String? //企业ID或者是机构ID
    var viewModel:FinacingViewModel = FinacingViewModel(){
        didSet{
            timeLabel.text = SafeUnwarp(viewModel.model.happenDate, holderForNull: "")
            phaseLabel.text = SafeUnwarp(viewModel.model.round, holderForNull: "")
            if phaseLabel.text?.characters.count == 0 {
                phaseLabel.isHidden = true
            }else{
                phaseLabel.isHidden = false
            }
            phaseLabel.sizeToFit()
            moneyLabel.text = SafeUnwarp(viewModel.model.amount, holderForNull: "")
            moneyLabel.sizeToFit()
            /// 默认去简称 简称没有取全称
            let cnName = SafeUnwarp(viewModel.model.aimedEnterprise?.cnName, holderForNull: "")
            targetCompanyLabel.text = SafeUnwarp(viewModel.model.aimedEnterprise?.shortCnName, holderForNull: cnName)
            targetCompanyLabel.sizeToFit()
            if viewModel.model.investInstitutionList != nil{
                for intitutionModel in (viewModel.model.investInstitutionList)! {
                    if intitutionModel.shortCnName != nil {
                        titiArr?.append("\(SafeUnwarp(intitutionModel.shortCnName, holderForNull: "")) \(SafeUnwarp(intitutionModel.amount, holderForNull: ""))")
                    }
                }
            }
            if titiArr != nil {
                finacingView.textArr = titiArr!
            }
            addModuleAndChangeFrame()
        }
    }
    var titiArr:[String]? = [String]()
    
    var  timeLabel:DotLabel = {
       let label = DotLabel()
        label.mainColor = UIColor.red
        return label
    }()
    
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
        timeLabel.frame = CGRect(x:leftStartX, y: 15, width: timeLabel.frame.size.width, height: timeLabel.frame.size.height)
        phaseLabel.frame = CGRect(x: timeLabel.frame.maxX + 20, y: 15, width: phaseLabel.frame.size.width + 5, height: phaseLabel.frame.size.height + 2)
        moneyLabel.frame = CGRect(x: phaseLabel.frame.maxX+15, y: 15, width: cellWidth/2, height: moneyLabel.frame.size.height)
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
        self.contentView.addSubview(phaseLabel)
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
