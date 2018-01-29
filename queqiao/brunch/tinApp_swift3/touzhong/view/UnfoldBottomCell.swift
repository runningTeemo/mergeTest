//
//  UnfoldBottomCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/16.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class UnfoldBottomCell: CommonCell { //用于事件详情页面

    var numOfLines:Int = 10 //默认显示的行数
    var model:DetailViewModel = DetailViewModel(){
        didSet{
            if model.unfold{
                label.numberOfLines = 0
            }else{
                label.numberOfLines = numOfLines
            }
            foldButton.unfold = model.unfold
            isHidenFoldBtn()
            fillFirstFooter()
        }
    }
    var indexPath:IndexPath?
    var cellHeight:CGFloat = 0
    var reloadCell:((_ index:IndexPath)->())?
    
    lazy var label:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = self.numOfLines
        return label
    }()
    var foldButton:FoldButton = {
        let foldBtn = FoldButton()
        foldBtn.isUserInteractionEnabled = true
        return foldBtn
    }()

    func isHidenFoldBtn(){
        let testLabel = UILabel()
        testLabel.font = label.font
        testLabel.frame = CGRect(x: 0, y: 0, width: cellWidth-25, height: 20)
        testLabel.numberOfLines = 0
        testLabel.text = model.showStr
        let testSize = testLabel.sizeThatFits(CGSize(width: cellWidth-40, height: CGFloat(MAXFLOAT)))
        if testSize.height <= 200 {
            model.hidenUnfoldBtn = true
        }else{
            model.hidenUnfoldBtn = false
        }
    }
    
    func fillFirstFooter(){
        
        label.text = model.showStr
        label.frame  = CGRect(x: leftStartX, y: 15, width: cellWidth-25, height: CGFloat(MAXFLOAT))
        Tools.setHighLightAttibuteColor(label: label, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 14))
        Tools.setHtmlAttibuteColor(label, htmlStr: label.text)
        label.sizeToFit()
        addModuleAndChangeFrame()
    }
    
    func foldAction(){
        reloadCell?(self.indexPath!)
    }
    
    override func addModuleAndChangeFrame(){
        label.frame = CGRect(x: leftStartX, y: 15, width: label.frame.size.width, height: label.frame.size.height)
        foldButton.frame = CGRect(x: (cellWidth-107)/2, y: label.frame.maxY+10, width: 107, height: 30)
        let tapGes = UITapGestureRecognizer( target: self, action: #selector(UnfoldBottomCell.foldAction))
        foldButton.addGestureRecognizer(tapGes)
        if model.hidenUnfoldBtn {
           foldButton.isHidden = true
            model.cellHeight = label.frame.maxY+20
        }else{
           foldButton.isHidden = false
            model.cellHeight = foldButton.frame.maxY+20
        }
        if Tools.isEmptyString(str: label.text) {
            model.cellHeight = 0
        }
    
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        self.contentView.addSubview(foldButton)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
