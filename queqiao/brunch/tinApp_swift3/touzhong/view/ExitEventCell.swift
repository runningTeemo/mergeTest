//
//  ExitEventCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ExitEventCell: DataCell {

    var viewModel:ExitEventViewModel = ExitEventViewModel(){
        didSet{
            targetCompanyL.text = viewModel.model.eventTitle
            Tools.setHighLightAttibuteColor(label: targetCompanyL, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 16))
            targetCompanyL.sizeToFit()
            moneyLabel.text = SafeUnwarp(viewModel.model.amount, holderForNull: "")
            moneyLabel.sizeToFit()
            typeLabel.text = "退"
            typeLabel.sizeToFit()
            if let companyArr = viewModel.model.exiteInstitution{
                let nameC = SafeUnwarp(companyArr.cnName, holderForNull: "")
                self.paticipateCompany.textArr = [SafeUnwarp(companyArr.shortCnName, holderForNull: nameC)]
            }else{
                self.paticipateCompany.textArr = [String?]()
            }
            self.phaseLabel.text = "退出\(SafeUnwarp(viewModel.model.storkRight!, holderForNull: ""))"
            self.phaseLabel.sizeToFit()
            self.timeLabel.text = viewModel.model.happenDate
            self.timeLabel.sizeToFit()
            let returnRate = Tools.decimal(2, originalStr: SafeUnwarp(viewModel.model.returnRate, holderForNull: ""))
            self.mutipleLabel.text = returnRate+"倍"
            Tools.setAttibuteColor(mutipleLabel, divisionStr: "倍", attributeColor: MyColor.colorWithHexString("#666666"), attributeFont: UIFont.systemFont(ofSize: 10))
            self.mutipleLabel.sizeToFit()
            addModuleAndChangeFrame()
            viewModel.cellHeight = cellLine.frame.maxY
        }
    }
    
    var mutipleLabel:UILabel = {
       let label = UILabel()
        return label
    }()
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        mutipleLabel.frame = CGRect(x: cellWidth-mutipleLabel.frame.width - leftStartX, y: phaseLabel.frame.maxY + 15, width: mutipleLabel.frame.width, height: mutipleLabel.frame.height)
        timeLabel.frame = CGRect(x: cellWidth-timeLabel.frame.width - leftStartX, y: typeLabel.frame.origin.y, width: timeLabel.frame.width, height: timeLabel.frame.height)
        //避免与时间label重叠
        paticipateCompany.frame = CGRect(x: paticipateCompany.frame.origin.x, y: paticipateCompany.frame.origin.y, width: timeLabel.frame.origin.x-paticipateCompany.frame.origin.x, height: paticipateCompany.frame.height)
        paticipateCompany.update()
        if paticipateCompany.frame.height == 0 {
            typeLabel.isHidden = true
            cellLine.frame = CGRect(x: 0, y: timeLabel.frame.maxY + 14, width: cellWidth, height: 0.5)
        }else{
            typeLabel.isHidden = false
            cellLine.frame = CGRect(x: 0, y: paticipateCompany.frame.maxY + 14, width: cellWidth, height: 0.5)
        }
        
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(mutipleLabel)
        
        // self.contentView.backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    /**
     添加约束
     - author: zerlinda
     - date: 16-09-05 11:09:29
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainColor = MyColor.colorWithHexString("#44ae62")
    }
    
}
