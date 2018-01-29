//
//  PersonageCareerCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PersonageCareerCell: CommonCell {

    var viewModel:CareersViewModel = CareersViewModel(){
        didSet{
            timeLabel.text = SafeUnwarp(viewModel.model.startDate, holderForNull: "")
            timeLabel.sizeToFit()
            toLabel.text = "至"
            toLabel.sizeToFit()
            endTimeLabel.text = SafeUnwarp(viewModel.model.endDate, holderForNull: "")
            endTimeLabel.sizeToFit()
            
            do {
                let company = SafeUnwarp(viewModel.model.instituion?.cnName, holderForNull: "N/A")
                let shortCnName = SafeUnwarp(viewModel.model.instituion?.shortCnName, holderForNull: company)
                let attriDic = [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                    NSForegroundColorAttributeName: HEX("#333333")
                ]
                let bounds = CGRect(x: 0, y: -2, width: 13, height: 13)
                let mAtt = NSMutableAttributedString()
                if viewModel.model.instituion?.id != "0" &&
                    viewModel.model.instituion?.id != nil &&
                    (viewModel.model.instituion?.bgType == "0" || viewModel.model.instituion?.bgType == "1") {
                    let img = AttributedStringTool.notNullAttributedImage(named: "relevanceBlue", bounds: bounds)
                    mAtt.append(img)
                    let attr = NSAttributedString(string: " ", attributes: attriDic)
                    mAtt.append(attr)
                    companyLabel.isUserInteractionEnabled = true
                } else {
                    companyLabel.isUserInteractionEnabled = false
                }
                let attr = NSAttributedString(string: shortCnName, attributes: attriDic)
                mAtt.append(attr)
                companyLabel.attributedText = mAtt
                companyLabel.sizeToFit()
            }
            positionLabel.text = SafeUnwarp(viewModel.model.duties, holderForNull: "")
            positionLabel.sizeToFit()
            addModuleAndChangeFrame()
        }
    }

    var indexPath:IndexPath?{
        didSet{

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
    var circleView:UIView = {
        let label = UIView()
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.layer.borderColor = mainBlueColor.cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = UIColor.white
        let view = UIView()
        view.frame = CGRect(x: 4, y: 4, width: 6, height: 6)
        view.backgroundColor = mainBlueColor
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        label.addSubview(view)
        return label
    }()
    
    var timeLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    
    var toLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    
    var endTimeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    var companyLabel:UILabel = {
       let label = UILabel()
        return label
    }()
    var positionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        return label
    }()
    
    override func addModuleAndChangeFrame(){
        topLine.frame = CGRect(x: 20, y: 0, width: 0.5, height: 20)
        circleView.frame = CGRect(x: topLine.center.x-7, y: 20, width: 14, height: 14)
        timeLabel.frame = CGRect(x: 60, y: 20, width: timeLabel.frame.size.width, height: timeLabel.frame.size.height)
        //因为数据问题先去掉
        toLabel.frame = CGRect(x: timeLabel.frame.maxX+10, y: 20, width: toLabel.frame.size.width, height: toLabel.frame.size.height)
        endTimeLabel.frame = CGRect(x: toLabel.frame.maxX+10, y: 20, width: endTimeLabel.frame.size.width, height: endTimeLabel.frame.size.height)
        companyLabel.frame = CGRect(x: 60, y: timeLabel.frame.maxY+10, width: kScreenW - 60 - 12.5, height: companyLabel.frame.size.height)
        
        positionLabel.frame = CGRect(x: 60, y: companyLabel.frame.maxY+10, width: positionLabel.frame.size.width, height: positionLabel.frame.size.height)
        viewModel.cellHeight = positionLabel.frame.maxY + 20
    
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(circleView)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(toLabel)
        self.contentView.addSubview(endTimeLabel)
        self.contentView.addSubview(companyLabel)
        self.contentView.addSubview(positionLabel)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PersonageCareerCell.companyTap))
        companyLabel.isUserInteractionEnabled = true
        companyLabel.addGestureRecognizer(tapGes)
    }
    
    func companyTap(){
        if viewModel.model.instituion?.bgType == "0" {
            let vc = EnterpriseDetailViewController()
            vc.id = SafeUnwarp(viewModel.model.instituion?.id, holderForNull: "")
            pushVC?(vc)
        }
        if viewModel.model.instituion?.bgType == "1" {
            let vc = InstitutionDetailViewController()
            vc.id = SafeUnwarp(viewModel.model.instituion?.id, holderForNull: "")
            pushVC?(vc)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.frame = CGRect(x: 20, y: 0, width: 0.5, height: 20)
        circleView.frame = CGRect(x: topLine.center.x-7, y: 20, width: 14, height: 14)
        bottomLine.frame = CGRect(x: 20, y: circleView.frame.maxY, width: 0.5, height: self.frame.height - circleView.frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
