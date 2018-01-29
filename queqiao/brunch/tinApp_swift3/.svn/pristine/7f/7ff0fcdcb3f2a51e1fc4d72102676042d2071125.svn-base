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


class InstitutionCell: CommonCell {
    
    var viewModel:InstitutionViewModel = InstitutionViewModel(){
        didSet{
            let name = SafeUnwarp(viewModel.model.cnName, holderForNull: "")
            nameLabel.text = SafeUnwarp(viewModel.model.shortCnName, holderForNull: name)
            nameLabel.sizeToFit()
            Tools.setHighLightAttibuteColor(label: nameLabel, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 16))
            timeLabel.text = SafeUnwarp(viewModel.model.setUpTime, holderForNull: "")
            timeLabel.sizeToFit()
            insTypeLabel.text = SafeUnwarp(viewModel.model.insType, holderForNull: "")
            
            if let user = viewModel.model.user{
                userNameLabel.text = SafeUnwarp(user.cnName, holderForNull: "")
            }
            
            assignNew()
            assignHot()
            assignField()
            
            imageV.fullPath = viewModel.model.logoUrl
            addModuleAndChangeFrame()
        }
    }
    func assignField(){
        var titleArr:[String?]? = [String?]()
        if  let arr = viewModel.model.institutionFieldList {
            for i in 0..<arr.count {
                if  arr[i].name != nil{
                    titleArr?.append(arr[i].name)
                }
            }
        }
        fieldView.titleArr = titleArr
        if fieldView.titleArr?.count == 0 {
            fieldLabel.isHidden = true
            lineV.isHidden = true
        }else{
            fieldLabel.isHidden = false
            lineV.isHidden = false
        }
    }
    
    /**
     给最热企业赋值
     
     - author: zerlinda
     - date: 16-09-10 14:09:20
     */
    func assignHot(){
        
        if let hot = viewModel.model.hotestEventLabel{
            if hot.cnName != nil{
                hotBorderLabel.textStr = "HOT"
                hotBorderLabel.sizeToFit()
                hotLabel.text = hot.cnName
                hotLabel.sizeToFit()
            }
        }
        
        if hotLabel.text?.characters.count==0{
            hotBorderLabel.alpha = 0
            hotBorderLabel.textStr = ""
            hotLabel.alpha = 0
        }
    }
    /**
     给最新企业赋值
     
     - author: zerlinda
     - date: 16-09-10 14:09:42
     */
    func assignNew(){
        
        if let new = viewModel.model.lastestEventLabel{
            if new.cnName != nil{
                newBorderLabel.textStr = "NEW"
                newBorderLabel.sizeToFit()
                newLabel.text = new.cnName
                newLabel.sizeToFit()
            }
        }
        
        if newLabel.text?.characters.count==0{
            newBorderLabel.alpha = 0
            newBorderLabel.textStr = ""
            newLabel.alpha = 0
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
        label.label.textColor = mainBlueColor
        label.mainColor = MyColor.colorWithHexString("#999999")
        label.label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var newBorderLabel:BorderLabel = {
        let label = BorderLabel()
        label.mainColor = MyColor.colorWithHexString("#4cbd6c")
        label.referenceWidth = 2
        label.font = UIFont(name: "Helvetica-Oblique", size: 9)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    /// 显示最新一家融资机构
    var newLabel:CommonLabel = {
        let label = CommonLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.textColor = MyColor.colorWithHexString("#666666")
        return label
    }()
    
    var hotBorderLabel:BorderLabel = {
        let label = BorderLabel()
        label.mainColor = MyColor.colorWithHexString("#d61f26")
        label.font = UIFont(name: "Helvetica-Oblique", size: 9)
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        label.referenceWidth = 2
        
        return label
    }()
    /// 显示最热一家融资机构
    var hotLabel:CommonLabel = {
        let label = CommonLabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        return label
    }()
    
    var lineV : UIView = {
        let line = UIView()
        line.backgroundColor = verticalLineColor
        return line
    }()
    var fieldLabel:RotateArrowsView = {
        let label = RotateArrowsView()
        label.text = "领域"
        label.label.font = UIFont.systemFont(ofSize: 14)
        label.label.textColor = MyColor.colorWithHexString("#333333")
        label.isUserInteractionEnabled = true
        return label
    }()
    //    var fieldLabel:UILabel = {
    //        let label = UILabel()
    //        label.text = "领域"
    //        label.font = UIFont.systemFont(ofSize: 14)
    //        label.sizeToFit()
    //        label.textColor = MyColor.colorWithHexString("#333333")
    //        label.isUserInteractionEnabled = true
    //        return label
    //    }()
    var fieldView:FieldView = {
        let fieldV = FieldView()
        fieldV.labelWidth = 51
        fieldV.backgroundColor = verticalLineColor
        return fieldV
    }()
    var nameTapAction:((_ id:String)->())?
    
    var reloadCell : ReloadCellClosure?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.imageV)
        self.addSubview(timeLabel)
        self.addSubview(insTypeLabel)
        self.addSubview(userNameLabel)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(newBorderLabel)
        self.contentView.addSubview(newLabel)
        self.contentView.addSubview(hotBorderLabel)
        self.contentView.addSubview(hotLabel)
        self.contentView.addSubview(lineV)
        self.contentView.addSubview(fieldLabel)
        self.contentView.addSubview(fieldView)
        let ges  = UITapGestureRecognizer(target: self, action: #selector(InstitutionCell.fieldAction))
        self.fieldLabel.addGestureRecognizer(ges)
    }
    
    override func addModuleAndChangeFrame() {
        if cellWidth==0 {
            return
        }
        imageV.frame = CGRect(x: leftStartX, y: 20, width: 84, height: 70)
        imageV.layer.borderColor = MyColor.colorWithHexString("#dcdcdc").cgColor
        imageV.layer.borderWidth = 0.5
        nameLabel.frame = CGRect(x: imageV.frame.maxX + 10, y: 20, width: nameLabel.frame.width, height: nameLabel.frame.height)
        timeLabel.frame = CGRect(x: imageV.frame.maxX + 10, y: nameLabel.frame.maxY + 8, width: timeLabel.frame.width, height: timeLabel.frame.height)
        insTypeLabel.frame = CGRect(x: timeLabel.frame.maxX + 15,  y: nameLabel.frame.maxY + 6, width: insTypeLabel.frame.width, height: insTypeLabel.frame.height)
        insTypeLabel.center = CGPoint(x: insTypeLabel.center.x, y: timeLabel.center.y)
        insTypeLabel.update()
        userNameLabel.frame = CGRect(x: insTypeLabel.frame.maxX + 15,  y: nameLabel.frame.maxY + 8, width: userNameLabel.frame.width, height: 20)
        userNameLabel.center = CGPoint(x: userNameLabel.center.x, y: timeLabel.center.y)
        userNameLabel.update()
        fieldLabel.frame = CGRect(x: cellWidth-50-5, y: timeLabel.frame.maxY + 6, width: 50, height: 21)
        lineV.frame = CGRect(x: fieldLabel.frame.origin.x-10, y: timeLabel.frame.maxY + 6, width: 1, height: 12)
        lineV.center = CGPoint(x: lineV.center.x, y: fieldLabel.center.y)
        newBorderLabel.frame = CGRect(x: imageV.frame.maxX + 10, y: timeLabel.frame.maxY + 8, width: 21+7, height: 10.5 + 4)
        /// 计算最新和最热企业的最大宽度
        var labelWidth:CGFloat  = 0
        if !fieldLabel.isHidden {
            labelWidth = (lineV.frame.origin.x - newBorderLabel.frame.origin.x - newBorderLabel.frame.width*2 - 10)/2
        }else{
            labelWidth = (cellWidth - 20 - newBorderLabel.frame.origin.x - newBorderLabel.frame.width*2)/2
        }
        newLabel.frame = CGRect(x: newBorderLabel.frame.maxX + 5, y: timeLabel.frame.maxY + 6, width: newLabel.frame.width, height: newLabel.frame.height)
        newLabel.maxWith = labelWidth
        hotBorderLabel.frame = CGRect(x: newLabel.frame.maxX + 10, y: timeLabel.frame.maxY + 8, width: 19+7, height: 10.5+4)
        hotLabel.frame = CGRect(x: hotBorderLabel.frame.maxX+5, y: timeLabel.frame.maxY + 6, width: hotLabel.frame.width, height: hotLabel.frame.height)
        hotLabel.maxWith = labelWidth
        
        fieldView.frame = CGRect(x: leftStartX, y: imageV.frame.maxY + 6, width: cellWidth-leftStartX*2, height: 56)
        fieldView.changeFrame()
        cellLine.frame = CGRect(x: 0, y: fieldView.frame.maxY + 15, width: cellWidth, height: 0.5)
        if viewModel.isShowFieldView {
            cellLine.frame = CGRect(x: 12.5, y: fieldView.frame.maxY + 15, width: cellWidth-25, height: 0.5)
        }else{
            cellLine.frame = CGRect(x: 12.5, y: fieldLabel.frame.maxY + 15, width: cellWidth-25, height: 0.5)
        }
        viewModel.cellHeight = cellLine.frame.maxY + 1
        changeShowView()
        addGes()
    }
    
    //MARK:Action
    //添加手势
    func addGes(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(InstitutionCell.nameTap))
        userNameLabel.addGestureRecognizer(tapGes)
        userNameLabel.isUserInteractionEnabled = true
        
        let newTap = UITapGestureRecognizer(target: self, action: #selector(InstitutionCell.newTap))
        newLabel.addGestureRecognizer(newTap)
        newLabel.isUserInteractionEnabled = true
        
        let newBorderTap = UITapGestureRecognizer(target: self, action: #selector(InstitutionCell.newTap))
        newBorderLabel.addGestureRecognizer(newBorderTap)
        newBorderLabel.isUserInteractionEnabled = true
        
        let hotTap = UITapGestureRecognizer(target: self, action: #selector(InstitutionCell.lastTap))
        hotLabel.addGestureRecognizer(hotTap)
        hotLabel.isUserInteractionEnabled = true
        
        let hotBorderTap = UITapGestureRecognizer(target: self, action: #selector(InstitutionCell.lastTap))
        hotBorderLabel.addGestureRecognizer(hotBorderTap)
        hotBorderLabel.isUserInteractionEnabled = true
    }
    
    //姓名点击
    func nameTap(){
        //  let vc = PersonageDetailViewController()
        if  viewModel.model.user?.userId != nil{
            nameTapAction?((viewModel.model.user?.userId!)!)
            //                vc.id = SafeUnwarp(viewModel.model.user?.userId, holderForNull: "")
            //                pushVC?(vc)
        }
    }
    func newTap(){
        let vc = EnterpriseDetailViewController()
        vc.id = SafeUnwarp(viewModel.model.lastestEventLabel?.id, holderForNull: "")
        vc.hidesBottomBarWhenPushed = true
        pushVC?(vc)
    }
    
    func lastTap(){
        let vc = EnterpriseDetailViewController()
        vc.id = SafeUnwarp(viewModel.model.hotestEventLabel?.id, holderForNull: "")
        pushVC?(vc)
    }
    
    func fieldAction(_ ges:UITapGestureRecognizer){
        viewModel.isShowFieldView = !viewModel.isShowFieldView
        viewModel.cellHeight = cellLine.frame.maxY
        reloadCell?(indexPath!)
    }
    
    func changeShowView(){
        fieldLabel.foldState = !self.viewModel.isShowFieldView
        fieldLabel.update()
        fieldView.isHidden = !self.viewModel.isShowFieldView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
