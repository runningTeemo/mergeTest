//
//  ChooseTimeCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ChooseTimeCell: CommonCell,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var model = FilterViewModel(){
        didSet{
            categoryLabel.text = model.categoryName
        }
    }
    var titleArr:[String] = [String](){
        didSet{
            startTime.label.text = titleArr[model.startIndex!]
            endTime.label.text = titleArr[model.endIndex!]
        }
    }
    var dataPicker:UIPickerView = UIPickerView()
    var reloadCell:((_ indexPath:IndexPath,_ isStartTime:Bool)->())?
    var indexPath:IndexPath?
    /// 类别
    lazy var categoryLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#666666")
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()
        return label
    }()
    
    var toLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "至"
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.cornerRadius = 0.5
       // label.layer.backgroundColor = MyColor.colorWithHexString("#999999").CGColor
        return label
    }()
    
    var startTime:BorderImageLabel = {
        let label = BorderImageLabel()
        label.tag = 100
        return label
    }()
    var endTime:BorderImageLabel = {
        let label = BorderImageLabel()
        label.tag = 101
        return label
    }()

    
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        self.addSubview(categoryLabel)
        self.addSubview(startTime)
        self.addSubview(endTime)
        self.addSubview(toLabel)
        self.changeFrame()
        let ges = UITapGestureRecognizer(target: self, action: #selector(ChooseTimeCell.chooseTimeAction))
        startTime.addGestureRecognizer(ges)
        let ges1 = UITapGestureRecognizer(target: self, action: #selector(ChooseTimeCell.chooseTimeAction))
        endTime.addGestureRecognizer(ges1)
    }
    
    func changeFrame(){
        let timeWidth :CGFloat = (self.cellWidth-37-20*2)/2
        categoryLabel.frame = CGRect(x: 20, y: 20, width: 0, height: 0)
        categoryLabel.sizeToFit()
        startTime.frame = CGRect(x: 20, y: categoryLabel.frame.maxY + 10, width: timeWidth, height: 37)
        endTime.frame = CGRect(x: self.cellWidth-20-timeWidth, y: categoryLabel.frame.maxY + 10,width: timeWidth, height: 37)
        toLabel.frame = CGRect(x: startTime.frame.maxX, y: categoryLabel.frame.maxY + 10, width: 37, height: 37)
        dataPicker.frame = CGRect(x: 20, y: endTime.frame.maxY, width: cellWidth-40, height: 100)
        dataPicker.isHidden = !model.isUnfold
        if model.isUnfold {
             model.cellHeight = endTime.frame.maxY + 10 + 100
        }else{
             model.cellHeight = endTime.frame.maxY + 10
        }
        cellLine.frame = CGRect(x: 0, y: model.cellHeight!-0.5, width: self.cellWidth,height: 0.5)
    }
    
    
    func chooseTimeAction(_ ges:UITapGestureRecognizer){
        model.isUnfold = true
        model.cellHeight = endTime.frame.maxY + 10 + 100
        if  ges.view?.tag == 100{
            model.isStartTime = true
            reloadCell!(self.indexPath!,true)
            
        }else{
            model.isStartTime = false
            reloadCell!(self.indexPath!,false)
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(dataPicker)
        dataPicker.delegate = self
        dataPicker.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if model.isStartTime {
          dataPicker.selectRow(model.startIndex!, inComponent: 0, animated: true)
        }else{
            dataPicker.selectRow(model.endIndex!, inComponent: 0, animated: true)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:UIPickViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titleArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleArr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if model.isStartTime {
            startTime.label.text = titleArr[row]
            model.startIndex = row
        }else{
            endTime.label.text = titleArr[row]
            model.endIndex = row
        }
    
    }
    
    
}
