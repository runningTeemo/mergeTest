//
//  NewsAlertExitEventCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/23.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsAlertMergerEventCell: CommonCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var enterPriseId:String?
    
    var viewModel:MergerViewModel = MergerViewModel(){
        didSet{
            timeLabel.text = SafeUnwarp(viewModel.model.happenDate, holderForNull: "")
            timeLabel.sizeToFit()
            if viewModel.model.aimedEnterprise?.id == enterPriseId{
                moneyLabel.text = "受资\(SafeUnwarp(viewModel.model.amount, holderForNull: ""))"
            }else{
                moneyLabel.text = "出资\(SafeUnwarp(viewModel.model.amount, holderForNull: ""))"
            }
            moneyLabel.sizeToFit()
            
            let cnName = SafeUnwarp(viewModel.model.aimedEnterprise?.cnName, holderForNull: "")
            targetCompanyLabel.text = SafeUnwarp(viewModel.model.aimedEnterprise?.shortCnName, holderForNull: cnName)
            targetCompanyLabel.sizeToFit()
//            //标的企业为空 隐藏前面的框
//            if targetCompanyLabel.text == nil || targetCompanyLabel.text?.characters.count == 0 {
//                targetBorderLabel.isHidden = true
//            }else{
//                targetBorderLabel.isHidden = false
//            }
            let buyCnName = SafeUnwarp(viewModel.model.buyEnterpriseList?[0].cnName, holderForNull:"")
            buyCompanyLabel.text = SafeUnwarp(viewModel.model.buyEnterpriseList?[0].shortCnName, holderForNull: buyCnName)
            buyCompanyLabel.sizeToFit()
            buyCompanyMoneyLabel.text = SafeUnwarp(viewModel.model.buyEnterpriseList?[0].amount, holderForNull: "")
            buyCompanyMoneyLabel.sizeToFit()
            //当买方列表存在自己。买方就显示自己
            if viewModel.model.buyEnterpriseList != nil {
                for enterPrise in viewModel.model.buyEnterpriseList! {
                    if enterPrise.id == enterPriseId {
                        let cnN = SafeUnwarp(enterPrise.cnName, holderForNull: "")
                        buyCompanyLabel.text = SafeUnwarp(enterPrise.shortCnName, holderForNull: cnN)
                        buyCompanyLabel.sizeToFit()
                        buyCompanyMoneyLabel.text = SafeUnwarp(enterPrise.amount, holderForNull: "")
                        buyCompanyMoneyLabel.sizeToFit()
                    }
                }
            }
//            if buyCompanyLabel.text?.characters.count == 0 || buyCompanyLabel.text == nil {
//                buyBorderLabel.isHidden = true
//            }else{
//                buyBorderLabel.isHidden = false
//            }
            addModuleAndChangeFrame()
        }
    }
    
    var titiArr:[String]? = [String]()
    
    var borderLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = mainGreenColor
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "并购"
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    }()
   
    var  timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = MyColor.colorWithHexString("#333333")
        return label
    }()
    
    var  moneyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var targetBorderLabel:BorderLabel = {
        let label = BorderLabel()
        label.referenceWidth = 0
        label.referenceHeight = 0
        label.textStr = "标"
        label.mainColor = mainGreenColor
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.layer.borderColor = mainGreenColor.cgColor
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
        label.textStr = "买"
        label.mainColor = mainGreenColor
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.layer.borderColor = mainGreenColor.cgColor
        label.layer.borderWidth = 0.4
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    /// 买方企业（取第一个）
    var buyCompanyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    /// 买方的出资
    var buyCompanyMoneyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    /// 设置控件位置
    override func addModuleAndChangeFrame(){
        if cellWidth==0 {
            return
        }
        borderLabel.frame = CGRect(x: leftStartX, y: 15, width: 25, height: 14)
        timeLabel.frame = CGRect(x: borderLabel.frame.maxX + 10, y: 15, width: timeLabel.frame.size.width, height: timeLabel.frame.size.height)
        moneyLabel.frame = CGRect(x: cellWidth/2, y: 15, width: cellWidth/2, height: moneyLabel.frame.size.height)
        targetBorderLabel.frame = CGRect(x: leftStartX, y: timeLabel.frame.maxY + 10, width: 14, height: 14)
        targetCompanyLabel.frame = CGRect(x: targetBorderLabel.frame.maxX + 10, y: timeLabel.frame.maxY + 10, width: targetCompanyLabel.frame.width, height: targetCompanyLabel.frame.height)
        buyBorderLabel.frame = CGRect(x: leftStartX, y: targetBorderLabel.frame.maxY + 10, width: 14, height: 14)
        buyCompanyLabel.frame = CGRect(x: buyBorderLabel.frame.maxX + 10, y: targetBorderLabel.frame.maxY + 10, width: buyCompanyLabel.frame.width, height: buyCompanyLabel.frame.height)
        buyCompanyMoneyLabel.frame = CGRect(x: buyCompanyLabel.frame.maxX + 10, y: targetBorderLabel.frame.maxY + 10, width: buyCompanyMoneyLabel.frame.width, height: buyCompanyMoneyLabel.frame.height)
        viewModel.cellHeight = buyBorderLabel.frame.maxY + 15
//        if buyCompanyLabel.text?.characters.count == 0 || buyCompanyLabel.text == nil{
//            viewModel.cellHeight = targetCompanyLabel.frame.maxY + 15
//        }
        cellLine.frame = CGRect(x: leftStartX, y: viewModel.cellHeight!-0.5, width: cellWidth-40, height: 0.5)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(borderLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(moneyLabel)
        self.contentView.addSubview(targetBorderLabel)
        self.contentView.addSubview(targetCompanyLabel)
        self.contentView.addSubview(buyBorderLabel)
        self.contentView.addSubview(buyCompanyLabel)
        self.contentView.addSubview(buyCompanyMoneyLabel)
       // self.contentView.addSubview(finacingView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
