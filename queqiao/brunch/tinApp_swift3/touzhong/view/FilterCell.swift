//
//  FilterCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FilterCell: CommonCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var indexPath:IndexPath?
    var reloadCell:ReloadCellClosure?
    var model:FilterViewModel = FilterViewModel(){
        didSet{
            categoryLabel.text = model.categoryName
            showView.selectArr =  model.selectArr
            showView.titleArr = model.showArray
            singleSelection = model.singleSelect
        }
    }
    var singleSelection:Bool = false{
        didSet{
            self.showView.singleSelection = singleSelection
        }
    }
    /// 类别
    lazy var categoryLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()
        return label
    }()
    
    var unfoldV:UIView = {
        let unfoldV = UIView()
        unfoldV.isUserInteractionEnabled = true
        return unfoldV
    }()
    var unfoldImageV:UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "iconCloseGray")
        return imageV
    }()
    
    var showView:SelectItemView = {
        let showView = SelectItemView(frame:CGRect.zero)
        return showView
    }()
    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        self.contentView.addSubview(self.categoryLabel)
        self.contentView.addSubview(self.showView)
        self.contentView.addSubview(unfoldV)
        unfoldV.addSubview(unfoldImageV)
        let ges = UITapGestureRecognizer(target: self, action: #selector(FilterCell.unfoldTap))
        unfoldV.addGestureRecognizer(ges)
        self.changeFrame()
    }
    
    func unfoldTap(_ tap:UITapGestureRecognizer){
        model.isUnfold = !model.isUnfold
        if model.isUnfold{
            model.cellHeight =  self.showView.frame.maxY+20
            unfoldImageV.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.showView.isHidden = false
            self.showView.frame = CGRect(x: self.showView.frame.origin.x, y: self.showView.frame.origin.y, width: self.showView.frame.size.width, height: self.showView.originalHeight)
        }else{
            model.cellHeight = self.categoryLabel.frame.maxY+20+37*2+20
            self.showView.isHidden = false
            //unfoldImageV.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.showView.frame = CGRect(x: self.showView.frame.origin.x, y: self.showView.frame.origin.y, width: self.showView.frame.size.width, height: 37*2+20)
        }
        reloadCell?(indexPath!)
    }
    
    func changeFrame(){
        categoryLabel.frame = CGRect(x: 15, y: 20, width: 0, height: 0)
        categoryLabel.sizeToFit()
        unfoldV.frame = CGRect(x: self.cellWidth-50-15, y: 0, width: 50, height: 20+30)
        unfoldImageV.frame = CGRect(x: unfoldV.frame.width-12.5, y: 20,  width: 12.5, height: 11)
        self.showView.frame = CGRect(x: 15, y: categoryLabel.frame.maxY+10, width: self.cellWidth - 30, height: 0)
        self.showView.updata()
        
        if model.isUnfold{
            model.cellHeight =  self.showView.frame.maxY+20
            self.showView.isHidden = false
            unfoldImageV.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.showView.frame = CGRect(x: self.showView.frame.origin.x, y: self.showView.frame.origin.y, width: self.showView.frame.size.width, height: self.showView.originalHeight)
        }else{
            model.cellHeight = self.categoryLabel.frame.maxY+20+37*2+20
            self.showView.isHidden = false
            self.showView.frame = CGRect(x: self.showView.frame.origin.x, y: self.showView.frame.origin.y, width: self.showView.frame.size.width,height: 37*2+10)
        }
        if self.showView.numOfLine <= 2{
            self.unfoldV.isHidden = true
            self.unfoldImageV.isHidden = true
        }
        self.contentView.clipsToBounds = true
        cellLine.frame = CGRect(x: 0, y: model.cellHeight!-0.5, width: self.cellWidth,height: 0.5)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //self.contentView.addSubview(self.testV)
        // addConstrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
