//
//  InstitutionBelongCategoryCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionBelongCategoryCell: CommonCell {

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
    var titleArr:[String?]? = [String?]()
    func fillData(){
        if viewModel.model.institutionFieldList != nil {
            for i in 0..<viewModel.model.institutionFieldList!.count{
                if let name = viewModel.model.institutionFieldList![i].name{
                    titleArr?.append(name)
                }
            }
        }
       fieldView.titleArr = titleArr
    }
    var fieldView:FlowLayoutLabel = {
       let view = FlowLayoutLabel()
        view.labelWidth = 54
        return view
    }()
    
    override func addModuleAndChangeFrame(){
        if cellWidth==0 {
            return
        }
        fieldView.frame = CGRect(x: leftStartX, y: 20, width: cellWidth-40, height: 0)
        if viewModel.model.institutionFieldList != nil && (viewModel.model.institutionFieldList?.count)!>0{
            viewModel.belongCategoryHeight = fieldView.getHeight() + 20 + 20
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(fieldView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class FlowLayoutLabel: UIView {
    
    /// 必须传的参数
    var labelWidth:CGFloat = 0
    var labelHeight:CGFloat = 17
    /// 必传参数
    var titleArr:[String?]? = [String?](){
        didSet{
            createLabel()
        }
    }
    /// 宽度缝隙
    var widthGap:CGFloat = 10
    /// 高度缝隙
    var heightGap:CGFloat = 10
    
    var viewHeight:CGFloat = 0
    
    var isHid = false{
        didSet{
            self.isHidden = isHid
        }
    }
    //MARK:private
    /// 每行的个数
    fileprivate var fixnum:Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        changeFrame()
    }
    
    func getHeight()->CGFloat{
        changeFrame()
        return viewHeight
    }
    
    //MARK:METHOD
    func createLabel(){
        if titleArr != nil  {
            for i in 0..<titleArr!.count{
                let label = UILabel()
                label.text = titleArr![i]
                label.font = UIFont.systemFont(ofSize: 10)
                label.tag = 100+i
                label.textColor = MyColor.colorWithHexString("#fda271")
                label.textAlignment = NSTextAlignment.center
                label.layer.borderWidth = 0.5
                label.layer.borderColor = MyColor.colorWithHexString("#fda271").cgColor
                label.backgroundColor = UIColor.white
                self.addSubview(label)
            }
        }
        
    }
    func changeFrame(){
        if self.bounds.size.width==0 {
            return
        }
        widthGap = 10
        calculateGap()
        if titleArr != nil {
            var startX:CGFloat = widthGap
            var startY:CGFloat = 0
            for i in 0..<titleArr!.count{
                let label = viewWithTag(100+i) as? UILabel
                if let l:UILabel = label {
                    if startX+0.001>=self.frame.size.width {
                        startX = widthGap
                        startY = startY + self.labelHeight + self.heightGap
                    }
                    l.frame = CGRect(x: startX, y: startY, width: self.labelWidth+4, height: self.labelHeight+2)
                    startX = startX + (self.labelWidth + self.widthGap)
                }
            }
            viewHeight = startY + labelHeight
            if titleArr?.count==0 {
                viewHeight = 0
            }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: viewHeight)
        }
        
    }
    /**
     适用横屏
     
     - author: zerlinda
     - date: 16-09-07 16:09:06
     */
    func calculateGap(){
        
        let indexF:CGFloat = (self.bounds.size.width-widthGap)/(labelWidth+widthGap)
        fixnum = Int(indexF)
        let width:CGFloat = (labelWidth+widthGap)*(indexF-CGFloat(fixnum))
        widthGap = widthGap+width/CGFloat(fixnum+1) //根据提供的label的宽度自适应宽度间隙
  
    }
}

