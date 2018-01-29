//
//  FinancingCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FinancingCell: DataCell {
    
     var viewModel:FinacingViewModel = FinacingViewModel(){
        didSet{
            targetCompanyL.text = viewModel.model.eventTitle
            Tools.setHighLightAttibuteColor(label: targetCompanyL, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 16))
            targetCompanyL.sizeToFit()
//            self.categoryLabel.text = viewModel.model.aimedEnterprise?.industry?.name
//            categoryLabel.sizeToFit()
            self.moneyLabel.text = viewModel.model.amount
            moneyLabel.sizeToFit()
            self.typeLabel.text = "投"
            self.typeLabel.sizeToFit()
            getInstitutionArr()
            self.phaseLabel.text = SafeUnwarp(viewModel.model.round, holderForNull: "")
            self.phaseLabel.sizeToFit()
            self.timeLabel.text = viewModel.model.happenDate
            self.timeLabel.sizeToFit()
            self.addModuleAndChangeFrame()
            viewModel.cellHeight = cellLine.frame.maxY
        }
    }
    override func  addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        if cellWidth == 0 {
            return
        }
//        if categoryLabel.text == nil || categoryLabel.text?.characters.count==0 {
//            categoryLabel.isHidden = true
//        }else{
//            categoryLabel.isHidden = false
//        }
        if phaseLabel.text == nil || phaseLabel.text?.characters.count==0 {
            phaseLabel.isHidden = true
        }else{
            phaseLabel.isHidden = false
        }
//        categoryLabel.frame = CGRect(x: categoryLabel.frame.origin.x, y: categoryLabel.frame.origin.y, width: categoryLabel.frame.size.width, height: categoryLabel.frame.size.height)
        if paticipateCompany.frame.height == 0 {
            typeLabel.isHidden = true
            cellLine.frame = CGRect(x: 0, y: moneyLabel.frame.maxY + 14, width: cellWidth, height: 0.5)
        }else{
            typeLabel.isHidden = false
            cellLine.frame = CGRect(x: 0, y: paticipateCompany.frame.maxY + 14, width: cellWidth, height: 0.5)
        }
    }
    
    func getInstitutionArr(){
        
        var titileArr:[String?] = [String?]()
        if viewModel.model.investInstitutionList != nil {
            for i in 0..<viewModel.model.investInstitutionList!.count{
                if let str = viewModel.model.investInstitutionList![i].shortCnName{
                    if str.characters.count>0 {
                        titileArr.append(str)
                    }
                }
            }
        }
        self.paticipateCompany.textArr = titileArr
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
        self.mainColor = MyColor.colorWithHexString("#3aaaf1")
    }
}
