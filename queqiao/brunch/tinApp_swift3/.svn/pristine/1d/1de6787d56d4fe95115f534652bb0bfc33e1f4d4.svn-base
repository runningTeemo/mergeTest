//
//  PersonageBaseInfoCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionBaseInfoCell: CommonCell {

    var respondUrl: ((_ url: String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var viewModel:InstitutionViewModel = InstitutionViewModel(){
        didSet{
            fillData()
            addModuleAndChangeFrame()
        }
    }
    var titileArr:[String] = [String]()
    var valueArr:[String] = [String]()
    func fillData(){
        
         titileArr.append("机构简称: ")
         titileArr.append("机构类型: ")
         titileArr.append("成立时间: ")
         titileArr.append("资本来源: ")
         titileArr.append("管理资金: ")
         titileArr.append("开放投资: ")
         titileArr.append("网址: ")
        
        valueArr.append(SafeUnwarp(viewModel.model.shortCnName, holderForNull: " "))
        valueArr.append(SafeUnwarp(viewModel.model.insType, holderForNull: " "))
        valueArr.append(SafeUnwarp(viewModel.model.setUpTime, holderForNull: " "))
        valueArr.append(SafeUnwarp(viewModel.model.capitalFrom, holderForNull: " "))
        valueArr.append(SafeUnwarp(viewModel.model.capitalAmount, holderForNull: " "))
        if  viewModel.model.openInvest=="1" {
            valueArr.append("开放")
        }else{
            valueArr.append("未开放")
        }
        valueArr.append(SafeUnwarp(viewModel.model.webSite, holderForNull: " "))
        
    }
    
    override func addModuleAndChangeFrame(){
        if cellWidth==0 {
            return
        }
        for view in subviews {
            if view.classForCoder == UILabel.classForCoder(){
                view.removeFromSuperview()
            }
        }
        var startY:CGFloat = 20
        var lastLabel: UILabel?
        for i in 0..<titileArr.count{
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.text = titileArr[i]
            titleLabel.sizeToFit()
            titleLabel.textColor = MyColor.colorWithHexString("#666666")
            let valueLabel = UILabel()//值
            valueLabel.font = UIFont.systemFont(ofSize: 14)
            valueLabel.text = valueArr[i]
            valueLabel.sizeToFit()
            valueLabel.textColor = MyColor.colorWithHexString("#333333")
            if i%2==0 {
                titleLabel.frame = CGRect(x: leftStartX, y: startY, width: titleLabel.frame.width, height: titleLabel.frame.size.height)
                valueLabel.frame = CGRect(x: titleLabel.frame.maxX, y: startY, width: cellWidth*3/5-leftStartX-titleLabel.frame.maxX, height: valueLabel.frame.height)
                viewModel.baseInforCellHeight = startY + titleLabel.frame.size.height + 20
            }else{
                titleLabel.frame = CGRect(x: cellWidth*3/5, y: startY, width:titleLabel.frame.width, height: titleLabel.frame.size.height)
                valueLabel.frame = CGRect(x: titleLabel.frame.maxX, y: startY, width: cellWidth-leftStartX-titleLabel.frame.maxX, height: valueLabel.frame.height)
                startY += titleLabel.frame.size.height + 10
            }
            if i == titileArr.count - 1 {
                valueLabel.frame = CGRect(x: valueLabel.frame.origin.x,y: valueLabel.frame.origin.y,width: cellWidth-valueLabel.frame.origin.x,height: valueLabel.frame.height)
            }
            if i < titileArr.count - 1 {
                Tools.setHighLightAttibuteColor(label:titleLabel, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: titleLabel.font)
            }
    
            self.contentView.addSubview(titleLabel)
            self.contentView.addSubview(valueLabel)
            lastLabel = valueLabel
        }
        if let label = lastLabel {
            let btn = UIButton()
            btn.signal_event_touchUpInside.head({ [unowned self] (s) in
                if let str = self.viewModel.model.webSite {
                    if str != "N/A"{
                        self.respondUrl?(str)
                    }
                }
            })
            btn.frame = CGRect(x: label.frame.minX, y: label.frame.minY - 10, width: label.frame.width, height: label.frame.height + 20)
            label.textColor = mainBlueColor
            self.contentView.addSubview(btn)
            if let str = self.viewModel.model.webSite{
                if str != "N/A"{
                    lastLabel?.textColor = mainBlueColor
                }else{
                    lastLabel?.textColor = MyColor.colorWithHexString("#666666")
                }
            }
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
    
}
