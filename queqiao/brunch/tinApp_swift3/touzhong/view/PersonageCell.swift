//
//  PersonageCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PersonageCell: CommonCell {
    
    var viewModel:PersonageViewModel = PersonageViewModel(){
        didSet{
            
            companyNameLabel.text = SafeUnwarp(viewModel.model.companyName, holderForNull: "")
            companyNameLabel.sizeToFit()
            positionLabel.text = SafeUnwarp(viewModel.model.duties, holderForNull: "")
            positionLabel.sizeToFit()
            var urlStr = ""
            if viewModel.model.imgUrl != nil {
                urlStr = "\(viewModel.model.imgUrl!)"
            }
            headPortrait.sd_setImage(with: URL(string: urlStr))
            let image:UIImage = UIImage(named: "imgRW")!
            headPortrait.sd_setImage(with: URL(string: urlStr),placeholderImage:image)
            assignName()
            addModuleAndChangeFrame()
        }
    }
    func assignName(){
        var str = ""
        if let cnName = viewModel.model.cnName {
            str += cnName
        }
        if let enName = viewModel.model.enName{
            str += " (" + enName + ")"
        }
        nameLabel.text = str
        //设置高亮
        Tools.setHighLightAttibuteColor(label: nameLabel, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: nameLabel.font)
        nameLabel.sizeToFit()
    }
    
    var headPortrait:UIImageView = {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.red
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        return imageV
    }()
    
    /// 姓名
    var nameLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// 公司
    var companyNameLabel:UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#666666")
        return label
    }()
    
    /// 职位
    var positionLabel:UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#666666")
        return label
    }()
    
    override func addModuleAndChangeFrame() {
        if cellWidth == 0 {
            return
        }
        headPortrait.frame = CGRect(x: leftStartX, y: 20, width: 54, height: 54)
        headPortrait.layer.cornerRadius = 27
        headPortrait.layer.masksToBounds = true
        nameLabel.frame = CGRect(x: headPortrait.frame.maxX+20, y: 20, width: cellWidth - 40 - headPortrait.frame.maxX, height: nameLabel.frame.height)
        companyNameLabel.frame = CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.maxY + 10, width: companyNameLabel.frame.width, height: companyNameLabel.frame.height)
        positionLabel.frame = CGRect(x: companyNameLabel.frame.origin.x, y: companyNameLabel.frame.maxY+4, width: positionLabel.frame.width, height: positionLabel.frame.height)
        viewModel.cellHeight = 103.5
        cellLine.frame = CGRect(x: 12.5, y: viewModel.cellHeight!-0.5, width: cellWidth-25, height: 0.5)
        viewModel.cellHeight = 103.5
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(headPortrait)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(companyNameLabel)
        self.contentView.addSubview(positionLabel)
        // self.contentView.backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    /**
     改变位置
     - author: zerlinda
     - date: 16-09-05 11:09:29
     */
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
}
