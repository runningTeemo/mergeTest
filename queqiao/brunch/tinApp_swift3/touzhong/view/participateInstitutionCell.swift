//
//  participateInstitution.swift
//  touzhong
//
//  Created by zerlinda on 16/9/16.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class participateInstitutionCell: CommonCell {
    
    var viewModel:PaticipateInstitotionViewModel = PaticipateInstitotionViewModel(){
        didSet{
            let cnName = SafeUnwarp(viewModel.model?.cnName, holderForNull: "")
            institutionName.text = SafeUnwarp(viewModel.model?.shortCnName, holderForNull: cnName)
            institutionName.font = UIFont.systemFont(ofSize: 16)
            institutionName.sizeToFit()
            moneyValueLabel.text = viewModel.model?.amount
            moneyValueLabel.sizeToFit()
            addModuleAndChangeFrame()
        }
    }
    var indexPath:IndexPath?{
        didSet{
            if (indexPath as NSIndexPath?)?.row == 0 {
                topLine.isHidden = true
            }
            circleLabel.text = "\((indexPath! as NSIndexPath).row+1)"
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
    var circleLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = MyColor.colorWithHexString("#d61f26")
        label.textColor = UIColor.white
        label.font = UIFont(name: "Helvetica-Oblique", size: 12)
        label.textAlignment = NSTextAlignment.center
        label.layer.cornerRadius = 9
        label.layer.masksToBounds = true
        return label
    }()
    
    var institutionName:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var typeLabel:BorderLabel = {
        let label = BorderLabel()
        label.referenceWidth = 5
        label.textStr = "投"
        label.mainColor = mainBlueColor
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var moneyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#666666")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "投资金额"
        label.sizeToFit()
        return label
    }()
    var moneyValueLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func addModuleAndChangeFrame(){
        if cellWidth == 0 {
            return
        }
        var institutionMaxW:CGFloat = institutionName.frame.size.width
        if institutionMaxW > cellWidth-10-50-(20+18+13) {
            institutionMaxW = cellWidth-10-50-(20+18+13)
        }
        institutionName.frame = CGRect(x: 20+18+13, y: 20, width: institutionName.frame.size.width, height: institutionName.frame.size.height)
        if institutionName.frame.maxX > cellWidth - typeLabel.frame.width - leftStartX - 10 {
            institutionName.frame = CGRect(x: 20+18+13, y: 20, width: cellWidth - typeLabel.frame.width - leftStartX - 10 - 20 - 18 - 13, height: institutionName.frame.size.height)
        }
        typeLabel.frame = CGRect(x: institutionName.frame.maxX + 10, y: 20, width: 15, height: 15)
        moneyLabel.frame = CGRect(x: 20+18+13, y: institutionName.frame.maxY+10, width: moneyLabel.frame.size.width, height: moneyLabel.frame.size.height)
        moneyValueLabel.frame = CGRect(x: moneyLabel.frame.maxX + 20, y: institutionName.frame.maxY+10, width: moneyValueLabel.frame.size.width, height: moneyValueLabel.frame.size.height)
        viewModel.cellHeight = moneyValueLabel.frame.maxY
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(circleLabel)
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(institutionName)
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(moneyLabel)
        self.contentView.addSubview(moneyValueLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLabel.frame = CGRect(x: 20, y: 20, width: 18, height: 18)
        topLine.frame = CGRect(x: circleLabel.center.x-0.5, y: 0, width: 0.5, height: 20)
        bottomLine.frame = CGRect(x: circleLabel.center.x-0.5, y: circleLabel.frame.maxY, width: 0.5, height: self.frame.height - circleLabel.frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
