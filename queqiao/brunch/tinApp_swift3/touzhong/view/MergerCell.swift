//
//  MergerCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MergerCell: DataCell {

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    var viewModel:MergerViewModel = MergerViewModel(){
        didSet{
//            let companyName = SafeUnwarp(viewModel.model.aimedEnterprise?.cnName, holderForNull: "")
//            self.targetCompanyL.text = SafeUnwarp(viewModel.model.aimedEnterprise?.shortCnName, holderForNull: companyName)

            targetCompanyL.text = viewModel.model.eventTitle
            Tools.setHighLightAttibuteColor(label: targetCompanyL, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 16))
            targetCompanyL.sizeToFit()

//            self.categoryLabel.text = viewModel.model.aimedEnterprise?.industry?.name
//            categoryLabel.sizeToFit()
            self.moneyLabel.text = viewModel.model.amount
            moneyLabel.sizeToFit()
            typeLabel.text = "买"
            typeLabel.sizeToFit()
            getEnterpriseArr()
            if  viewModel.model.storkRight != nil{
                self.phaseLabel.text = "并购\(viewModel.model.storkRight!)"
            }
            self.phaseLabel.sizeToFit()
            self.timeLabel.text = viewModel.model.happenDate
            self.timeLabel.sizeToFit()
            addModuleAndChangeFrame()
            viewModel.cellHeight = cellLine.frame.maxY
        }
    }
    
    func getEnterpriseArr(){
        
        var titileArr:[String?] = [String?]()
        if viewModel.model.buyEnterpriseList==nil {
            return
        }
        for i in 0..<viewModel.model.buyEnterpriseList!.count{
            if viewModel.model.buyEnterpriseList![i].businessType=="0"{
                if let str = viewModel.model.buyEnterpriseList![i].shortCnName{
                    titileArr.append(str)
                }
            }
           
        }
        self.paticipateCompany.textArr = titileArr
    }
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
//        if categoryLabel.text == nil || categoryLabel.text?.characters.count == 0 {
//            categoryLabel.isHidden = true
//        }else{
//            categoryLabel.isHidden = false
//        }
        if paticipateCompany.frame.height == 0 {
            typeLabel.isHidden = true
            cellLine.frame = CGRect(x: 0, y: moneyLabel.frame.maxY + 14, width: cellWidth, height: 0.5)
        }else{
            typeLabel.isHidden = false
            cellLine.frame = CGRect(x: 0, y: paticipateCompany.frame.maxY + 14, width: cellWidth, height: 0.5)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
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
        self.mainColor = MyColor.colorWithHexString("#44c4c3")
    }

}
