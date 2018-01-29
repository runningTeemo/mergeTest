//
//  LabelValueCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/15.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LabelValueCell: CommonCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var showRelevance:Bool = false{
        didSet{
            
           relevance.isHidden = !showRelevance
        }
    }
    
    var titleStr:String?{
        didSet{
            titleLabel.text = titleStr
            titleLabel.sizeToFit()
        }
    }
    
    var valueStr:String?{
        didSet{
            valueLabel.text = valueStr
            valueLabel.sizeToFit()
            
        }
    }
    
    var titleLabel:UILabel = {
       let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#666666")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.natural
        return label
    }()
    
    var valueLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.justified
        return label
    }()
    
    var relevance:UIImageView = {
       let imageV = UIImageView()
        imageV.image = UIImage(named: "relevanceBlue")
        imageV.isHidden = true
        return imageV
    }()
    
    override func addModuleAndChangeFrame() {
        titleLabel.frame = CGRect(x: leftStartX, y: 0, width: titleLabel.frame.width, height: self.frame.height-0.5)
        valueLabel.frame = CGRect(x: 120, y: 0, width: valueLabel.frame.width, height: self.frame.height - 0.5)
        if showRelevance && valueLabel.frame.maxY > cellWidth - leftStartX - 10 - 5 {
            valueLabel.frame = CGRect(x: 120, y: 0, width: cellWidth - leftStartX - 10 - 5 - 120, height: self.frame.height - 0.5)
        }
        relevance.frame = CGRect(x: valueLabel.frame.maxX + 5, y: 0, width: 10, height: 10)
         relevance.center = CGPoint(x: relevance.center.x, y: valueLabel.center.y)
        cellLine.frame = CGRect(x: 0, y: self.contentView.frame.size.height-0.5, width: cellWidth, height: 0.5)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addModuleAndChangeFrame()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        self.contentView.addSubview(relevance)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
