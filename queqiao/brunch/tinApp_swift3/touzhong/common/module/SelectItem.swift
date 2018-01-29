//
//  SelectItem.swift
//  touzhong
//
//  Created by zerlinda on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SelectItem: UILabel {
    
    /// 是否选中
    var isSelected:Bool = false{
        didSet{
            if isSelected {
                self.textColor = MyColor.colorWithHexString("#d61f26")
                self.backgroundColor = MyColor.colorWithHexString("#f9e8dc")
                self.hookImage.isHidden = false
                self.addSelectItem(self.title)
            }else{
                self.backgroundColor = MyColor.colorWithHexString("#f2f2f2")
                self.textColor = MyColor.colorWithHexString("#333333")
                self.hookImage.isHidden = true
                self.removeSelectItem(self.title)
            }
            
        }
    }
    var selectFirst:(()->())?
    var showArr:[String] = [String]()
    
    var selectDic:NSMutableDictionary = NSMutableDictionary()
    var selectArray:NSMutableArray = NSMutableArray(){
        didSet{
            isSelectLabel(self.title)
        }
    }
    /// 显示的字体
    var title = ""{
        didSet{
            self.text = title
            self.font = UIFont.systemFont(ofSize: 14)
            self.adjustsFontSizeToFitWidth = true
            self.textAlignment = NSTextAlignment.center
            // self.isSelectLabel(self.text)
        }
    }
    ///选中时显示的对勾
    var hookImage:UIImageView = {
        let imagV = UIImageView()
        imagV.image = UIImage(named:"label_select")
        imagV.isHidden = true
        return imagV
    }()
    
    func addSelectItem(_ str:String){
        var hasItrem = false
         print(selectArray)
        for selectStr in selectArray {
            if selectStr as! String == str {
                hasItrem = true
            }
        }
        if !hasItrem {
            selectArray.add(str)
        }
   
    }
    func removeSelectItem(_ str:String){
        print(selectArray)
        if  selectArray.contains(str){
            let index = selectArray.index(of: str)
            selectArray.removeObject(at: index)
        }
    }
    
    func isSelectLabel(_ labelStr:String?){
        for str in selectArray {
            if str as? String == labelStr {
                self.isSelected = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.backgroundColor = MyColor.colorWithHexString("#f2f2f2")
        self.textColor = MyColor.colorWithHexString("#333333")
        self.layer.masksToBounds = true
        self.addSubview(hookImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hookImage.frame = CGRect(x: self.frame.width - 15, y: self.frame.height - 15, width: 15, height: 15)
        self.layer.cornerRadius = 2
        self.layer.masksToBounds  = true
    }
    /**
     加上点击手势
     
     - author: zerlinda
     - date: 16-09-01 19:09:31
     */
    
    func addTapGes(){
        let tapGes = UITapGestureRecognizer(target: self, action:#selector(SelectItem.tapAction))
        self.addGestureRecognizer(tapGes)
    }
    func tapAction(_ ges:UITapGestureRecognizer){
        if ges.state == UIGestureRecognizerState.ended {
            self.isSelected = !self.isSelected
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
