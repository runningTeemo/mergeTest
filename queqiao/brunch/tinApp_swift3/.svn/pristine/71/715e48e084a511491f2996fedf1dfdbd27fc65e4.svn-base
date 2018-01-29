//
//  InstitutionCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class InstitutionCueCell: CommonCell {
    
    var viewModel:InstitutionCueViewModel = InstitutionCueViewModel(){
        didSet{
            let name = SafeUnwarp(viewModel.model?.cnName, holderForNull: "")
            nameLabel.text = SafeUnwarp(viewModel.model?.shortCnName, holderForNull: name)
            nameLabel.sizeToFit()
            Tools.setHighLightAttibuteColor(label: nameLabel, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 16))
            timeLabel.text = SafeUnwarp(viewModel.model?.setUpTime, holderForNull: "")
            timeLabel.sizeToFit()
            insTypeLabel.text = SafeUnwarp(viewModel.model?.insType, holderForNull: "")
            userNameLabel.text = viewModel.model?.capitalFrom
            imageV.fullPath = viewModel.model?.logoUrl
            addModuleAndChangeFrame()
        }
    }
    
    fileprivate var selfH:CGFloat = 0
    var indexPath : IndexPath?
    
    var imageV:RectLogoView = {
        let imageV = RectLogoView()
        imageV.defalutLogoImage = UIImage(named: "imgJG")
        return imageV
    }()
    
    var nameLabel:CommonLabel = {
        let label = CommonLabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var insTypeLabel:LineLabel = {
        let label = LineLabel()
        label.mainColor = MyColor.colorWithHexString("#999999")
        label.label.textColor = MyColor.colorWithHexString("#999999")
        label.label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var userNameLabel:LineLabel = {
        let label = LineLabel()
        label.mainColor = MyColor.colorWithHexString("#999999")
        label.label.textColor = MyColor.colorWithHexString("#999999")
        label.label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    var reloadCell : ReloadCellClosure?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.imageV)
        self.addSubview(timeLabel)
        self.addSubview(insTypeLabel)
        self.addSubview(userNameLabel)
        self.contentView.addSubview(nameLabel)
    }
    
    override func addModuleAndChangeFrame() {
        if cellWidth==0 {
            return
        }
        imageV.frame = CGRect(x: 12.5, y: 20, width: 45, height: 40)
        imageV.layer.borderColor = MyColor.colorWithHexString("#dcdcdc").cgColor
        imageV.layer.borderWidth = 1
        nameLabel.frame = CGRect(x: imageV.frame.maxX + 10, y: 20, width: nameLabel.frame.width, height: nameLabel.frame.height)
        timeLabel.frame = CGRect(x: imageV.frame.maxX + 10, y: nameLabel.frame.maxY + 6, width: timeLabel.frame.width, height: timeLabel.frame.height)
        insTypeLabel.frame = CGRect(x: timeLabel.frame.maxX + 15,  y: nameLabel.frame.maxY + 15, width: insTypeLabel.frame.width, height: insTypeLabel.frame.height)
        insTypeLabel.center = CGPoint(x: insTypeLabel.center.x, y: timeLabel.center.y)
        userNameLabel.frame = CGRect(x: insTypeLabel.frame.maxX + 15,  y: nameLabel.frame.maxY + 15, width: userNameLabel.frame.width, height: userNameLabel.frame.height)
        userNameLabel.center = CGPoint(x: userNameLabel.center.x, y: timeLabel.center.y)
         cellLine.frame = CGRect(x: 0, y: imageV.frame.maxY + 15, width: cellWidth, height: 0.5)
        viewModel.cellHeight = cellLine.frame.maxY + 1
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
