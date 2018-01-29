//
//  EnterpriseCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class EnterpriseCell: CommonCell {
    
    var viewModel:EnterpriseViewModel = EnterpriseViewModel(){
        didSet{
            let companyName = SafeUnwarp(viewModel.model.cnName, holderForNull: "")
            if viewModel.model.shortCnName == "" {
                targetCompanyL.text = companyName
            }else{
                targetCompanyL.text = SafeUnwarp(viewModel.model.shortCnName, holderForNull: companyName)
            }
            
            Tools.setHighLightAttibuteColor(label: targetCompanyL, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 16))
            targetCompanyL.sizeToFit()
            assignPaticipateCompany()
            newBorderLabel.textStr = "NEW"
            newBorderLabel.sizeToFit()
            timeLabel.text = SafeUnwarp(viewModel.model.happenDate, holderForNull: "")
            timeLabel.sizeToFit()
            categoryLabel.textStr = SafeUnwarp(viewModel.model.industry?[0].name, holderForNull: "")
            self.phaseLabel.text = SafeUnwarp(viewModel.model.investRound, holderForNull: "")
            self.phaseLabel.sizeToFit()
            if viewModel.model.financingCount != nil{
                self.finacingNum.text = "融资 \(viewModel.model.financingCount!) 次"
                Tools.setRangeAttibuteColor(finacingNum, divisionStr: "\(viewModel.model.financingCount!)", attributeColor: mainOrangeColor, attributeFont: UIFont.systemFont(ofSize: 17))
            }
            finacingNum.sizeToFit()
            addModuleAndChangeFrame()
        }
    }
    /**
     投资轮次赋值
     
     - author: zerlinda
     - date: 16-09-10 15:09:26
     */
    func assignRound(){
        phaseLabel.text = SafeUnwarp(viewModel.model.investRound, holderForNull: "")
        phaseLabel.sizeToFit()
    }
    /**
     
     赋值 成立时间、是否上市、地区
     - author: zerlinda
     - date: 16-09-10 16:09:12
     */
    func assignPaticipateCompany(){
        var titleA:[String?] = [String?]()
        titleA.append(viewModel.model.setUpTime)
        if viewModel.model.list=="0" {
            titleA.append("未上市")
            
        }else{
            titleA.append("已上市")
        }
        titleA.append(viewModel.model.regLocation)
        paticipateCompany.textArr = titleA
    }
    
    /// 标的企业
    var targetCompanyL:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    /// 参与公司
    var paticipateCompany:ParticipationView = {
        let view = ParticipationView()
        view.mainColor = MyColor.colorWithHexString("#3aaaf1")
        view.textFont = 14
        return view
    }()
    
    
    var newBorderLabel:BorderLabel = {
        let label = BorderLabel()
        label.mainColor = MyColor.colorWithHexString("#4cbd6c")
        label.referenceWidth = 2
        label.font = UIFont(name: "Helvetica-Oblique", size: 9)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    
    var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#666666")
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
    
    ///公司行业
    var categoryLabel:BorderLabel = {
        let label = BorderLabel()
        label.mainColor = MyColor.colorWithHexString("#fda271")
        label.referenceWidth = 8
        label.font = UIFont.systemFont(ofSize: 10)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    
    var finacingNum:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#666666")
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(targetCompanyL)
        self.contentView.addSubview(paticipateCompany)
        self.contentView.addSubview(newBorderLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(phaseLabel)
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(finacingNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func addModuleAndChangeFrame() {
        
        if cellWidth == 0 {
            return
        }
        targetCompanyL.sizeToFit()
        targetCompanyL.frame = CGRect(x: leftStartX, y: 20, width: cellWidth - categoryLabel.frame.size.width, height: targetCompanyL.frame.height)
        paticipateCompany.frame = CGRect(x: leftStartX, y: targetCompanyL.frame.maxY + 10, width: cellWidth, height: 20)
        paticipateCompany.update()
        newBorderLabel.frame = CGRect(x: leftStartX, y: paticipateCompany.frame.maxY + 15, width: newBorderLabel.frame.width+5, height: newBorderLabel.frame.height+4)
        timeLabel.frame = CGRect(x: newBorderLabel.frame.maxX + 10, y: paticipateCompany.frame.maxY + 15, width: timeLabel.frame.width, height: timeLabel.frame.height)
        timeLabel.center = CGPoint(x: timeLabel.center.x, y: newBorderLabel.center.y)
        phaseLabel.frame = CGRect(x: timeLabel.frame.maxX + 10, y: paticipateCompany.frame.maxY + 17, width: phaseLabel.frame.width+5, height: phaseLabel.frame.height+6)
        phaseLabel.center = CGPoint(x: phaseLabel.center.x, y: newBorderLabel.center.y)
        categoryLabel.frame = CGRect(x: cellWidth - categoryLabel.frame.width - 20, y: 20, width: categoryLabel.frame.width+4, height: categoryLabel.frame.height+4)
        finacingNum.frame = CGRect(x: cellWidth - 20 - finacingNum.frame.width, y: paticipateCompany.frame.maxY + 15, width: finacingNum.frame.width, height: finacingNum.frame.height)
        finacingNum.center = CGPoint(x: finacingNum.center.x, y: newBorderLabel.center.y)
        cellLine.frame = CGRect(x: 12.5, y: finacingNum.frame.maxY + 20, width: cellWidth-25, height: 0.5)
        viewModel.cellHeight = cellLine.frame.maxY
    }
    
}
