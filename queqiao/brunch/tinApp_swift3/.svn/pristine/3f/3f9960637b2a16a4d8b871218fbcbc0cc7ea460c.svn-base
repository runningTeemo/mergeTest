//
//  EnterpriseBaseInfoCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class EnterpriseBaseInfoCell: CommonCell {
    
    
    var respondUrl: ((_ url: String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var viewModel:EnterpriseViewModel = EnterpriseViewModel(){
        didSet{
            fillData()
            addModuleAndChangeFrame()
        }
    }
    var titileArr:[String] = [String]()
    var valueArr:[String] = [String]()
    
    func fillData(){
        titileArr.removeAll()
        valueArr.removeAll()
        let stock = viewModel.model.stocks?[0]
        if !Tools.isEmptyString(str: viewModel.model.shortCnName) {
            titileArr.append("企业简称:")
            valueArr.append(SafeUnwarp(viewModel.model.shortCnName, holderForNull: ""))
        }
        if !Tools.isEmptyString(str: viewModel.model.setUpTime) {
            titileArr.append("成立时间:")
            valueArr.append(SafeUnwarp(viewModel.model.setUpTime, holderForNull: ""))
        }
        if !Tools.isEmptyString(str: viewModel.model.growth) {
            titileArr.append("成长阶段:")
            valueArr.append(SafeUnwarp(viewModel.model.growth, holderForNull: ""))
        }
        if !Tools.isEmptyString(str: viewModel.model.legalRep) {
            titileArr.append("管理者:")
            valueArr.append(SafeUnwarp(viewModel.model.legalRep, holderForNull: ""))
        }
        //因为数据不全暂且隐藏
        //        if !Tools.isEmptyString(str: viewModel.model.employCount) {
        //            titileArr.append("规模:")
        //            valueArr.append(SafeUnwarp(viewModel.model.employCount, holderForNull: ""))
        //        }
        if !Tools.isEmptyString(str: viewModel.model.website) {
            titileArr.append("网址:")
            valueArr.append(SafeUnwarp(viewModel.model.website, holderForNull: ""))
        }
        if !Tools.isEmptyString(str: viewModel.model.industry?[0].name) {
            titileArr.append("所属行业:")
            valueArr.append(SafeUnwarp(viewModel.model.industry?[0].name, holderForNull: ""))
        }
        if stock != nil {
            titileArr.append("股票代码:")
            titileArr.append("上市信息:")
            valueArr.append(SafeUnwarp(stock?.stockCode, holderForNull: ""))
            valueArr.append(SafeUnwarp(stock?.stockMess, holderForNull: ""))
        }
        
    }
    
    override func addModuleAndChangeFrame(){
        if cellWidth==0 {
            return
        }
        createLabel()
        cellLine.frame = CGRect(x: 0, y: viewModel.baseInforCellHeight!, width: cellWidth, height: 0.5)
    }
    
    func createLabel(){
        for view in subviews {
            if view.classForCoder == UILabel.classForCoder(){
                view.removeFromSuperview()
            }
        }
        var startY:CGFloat = 20
        var lastLabel: UILabel?
        for i in 0..<titileArr.count {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = titileArr[i]
            label.sizeToFit()
            label.textColor = MyColor.colorWithHexString("#666666")
            label.frame = CGRect(x: leftStartX, y: startY, width: 70, height: label.frame.height)
            label.allowsDefaultTighteningForTruncation = true
            startY += label.frame.height+10
            
            var valueLabel = UILabel()
            if label.text == "所属行业:" {
                valueLabel = industryLabel()
                valueLabel.center = CGPoint(x: valueLabel.center.x, y: label.center.y)
            }else{
                valueLabel = createValueLabel()
                if label.text == "网址:" {
                    lastLabel = valueLabel
                    valueLabel.textColor = mainBlueColor
                }
                if label.text == "股票代码:" {
                    valueLabel.textColor = UIColor.red
                }
            }
            valueLabel.text = valueArr[i]
            valueLabel.sizeToFit()
            valueLabel.frame = CGRect(x: label.frame.maxX+10, y: label.frame.origin.y, width: valueLabel.frame.width, height: valueLabel.frame.height)
            if label.text == "所属行业:" {
                valueLabel.frame = CGRect(x: label.frame.maxX+10, y: label.frame.origin.y, width: valueLabel.frame.width+4, height: valueLabel.frame.height+2)
            }
            viewModel.baseInforCellHeight = startY
            if valueLabel.frame.width>cellWidth-leftStartX-label.frame.maxX-10 {
                valueLabel.frame = CGRect(x: valueLabel.frame.origin.x, y: valueLabel.frame.origin.y, width: cellWidth-leftStartX-label.frame.maxX-10, height: valueLabel.frame.height)
            }
            self.contentView.addSubview(label)
            self.contentView.addSubview(valueLabel)
            if i == 0 {
                Tools.setHighLightAttibuteColor(label:label, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: label.font)
            }
        }
        if let label = lastLabel {
            let btn = UIButton()
            weak var ws = self
            btn.signal_event_touchUpInside.head({ _ in
                if let str = self.viewModel.model.website{
                    if str != "N/A"{
                        ws?.respondUrl?(str)
                    }
                }
            })
            btn.frame = CGRect(x: label.frame.minX, y: label.frame.minY - 10, width: label.frame.width, height: label.frame.height + 20)
            self.contentView.addSubview(btn)
            
            if let str = self.viewModel.model.website{
                if str != "N/A"{
                   lastLabel?.textColor = mainBlueColor
                }else{
                    lastLabel?.textColor = MyColor.colorWithHexString("#666666")
                }
            }
        }
    }
    
    func createValueLabel()->UILabel{
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.sizeToFit()
        valueLabel.textColor = MyColor.colorWithHexString("#333333")
        return valueLabel
    }
    func industryLabel()->UILabel{
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#fda271")
        label.layer.borderWidth = 0.5
        label.layer.borderColor = MyColor.colorWithHexString("#fda271").cgColor
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 10)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
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

class BelongIndustryCell: CommonCell {
    
    var industry:IndustryDataModel?{
        didSet{
            industryLabel.text = industry?.name
            industryLabel.sizeToFit()
            if industryLabel.text==nil || industryLabel.text?.characters.count == 0 {
                industryLabel.isHidden = true
            }else{
                industryLabel.isHidden = false
            }
            
            addModuleAndChangeFrame()
        }
    }
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.text = "所属行业: "
        label.sizeToFit()
        return label
    }()
    
    var industryLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#fda271")
        label.layer.borderWidth = 0.5
        label.layer.borderColor = MyColor.colorWithHexString("#fda271").cgColor
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 10)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        if cellWidth==0 {
            return
        }
        titleLabel.frame = CGRect(x: 20, y: (44-titleLabel.frame.height)/2, width: titleLabel.frame.width, height: titleLabel.frame.height)
        industryLabel.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: industryLabel.frame.width+8, height: industryLabel.frame.height+2)
        industryLabel.center = CGPoint(x: industryLabel.center.x, y: titleLabel.center.y)
        cellLine.frame = CGRect(x: 0, y: 43.5, width: cellWidth, height: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(industryLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class ProductCell: CommonCell {
    
    var product:String?{
        didSet{
            titleLabel.text = "\(SafeUnwarp(product, holderForNull: ""))"
            Tools.setAttibuteColor(titleLabel, divisionStr: " ", attributeColor: MyColor.colorWithHexString("#333333"), attributeFont: UIFont.systemFont(ofSize: 14))
            addModuleAndChangeFrame()
        }
    }
    var viewModel:EnterpriseViewModel = EnterpriseViewModel(){
        didSet{
            titleLabel.text = "\(SafeUnwarp(viewModel.model.products, holderForNull: ""))"
            addModuleAndChangeFrame()
        }
    }
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.text = "相关产品: "
        return label
    }()
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        if cellWidth == 0 {
            return
        }
        titleLabel.frame = CGRect(x: leftStartX, y: 10, width: cellWidth - leftStartX*2, height: 44)
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: leftStartX, y: 10, width: titleLabel.frame.width, height: titleLabel.frame.height)
        viewModel.productCellHeight = titleLabel.frame.maxY + 20
        cellLine.frame = CGRect(x: 0, y:  viewModel.productCellHeight!-0.5, width: cellWidth, height: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class  StockCell: CommonCell {
    
    var stock:StockDataModel?{
        didSet{
            stockCodeLabel.text = "股票代码: \(SafeUnwarp(stock?.stockCode, holderForNull: ""))"
            stockMessLabel.text = "上市信息: \(SafeUnwarp(stock?.stockMess, holderForNull: ""))"
            Tools.setAttibuteColor(stockMessLabel, divisionStr: " ", attributeColor: MyColor.colorWithHexString("#333333"), attributeFont: UIFont.systemFont(ofSize: 14))
            Tools.setAttibuteColor(stockCodeLabel, divisionStr: " ", attributeColor: mainOrangeColor, attributeFont: UIFont.systemFont(ofSize: 14))
            stockMessLabel.sizeToFit()
            stockCodeLabel.sizeToFit()
            addModuleAndChangeFrame()
        }
    }
    var stockCodeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.text = "股票代码: "
        label.sizeToFit()
        return label
    }()
    
    var stockMessLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.text = "股票代码: "
        label.sizeToFit()
        return label
    }()
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        stockCodeLabel.frame = CGRect(x: 20, y: 20, width: stockCodeLabel.frame.width, height: stockCodeLabel.frame.height)
        stockMessLabel.frame = CGRect(x: 20, y: stockCodeLabel.frame.maxY+10, width: stockMessLabel.frame.width, height: stockMessLabel.frame.height)
        cellLine.frame = CGRect(x: 0, y: 83.5, width: cellWidth, height: 0.5)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(stockCodeLabel)
        self.contentView.addSubview(stockMessLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


