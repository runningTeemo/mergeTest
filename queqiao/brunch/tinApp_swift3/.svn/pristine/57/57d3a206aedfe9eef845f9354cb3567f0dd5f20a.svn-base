//
//  DropDownBox.swift
//  touzhong
//
//  Created by zerlinda on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class DropDownBox: RootView,UITableViewDelegate,UITableViewDataSource {
    
    var dataArr:[String] = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    var tableView:UITableView!
    var label : UILabel = {
        let label = UILabel()
        label.text = " 不限"
        label.textColor = UIColor.darkGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.cornerRadius = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.red
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = false
        self.addSubview(label)
        self.addSubview(tableView)
        addGes()
        
    }
    /**
     给label添加手势
     
     - author: zerlinda
     - date: 16-09-01 20:09:57
     */
    func addGes(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(DropDownBox.tapAction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGes)
    }
    func tapAction(){
        // tableView.hidden = !tableView.hidden
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = self.frame
//        constrain(tableView){view in
//            view.edges == view.superview!.edges
//        }
    }
    //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellID"
        let cell = DragBoxCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textStr = self.dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        label.text = dataArr[indexPath.row]
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DragBoxCell: CommonCell {
    
    var textStr:String = ""{
        didSet{
            self.textLabel?.text = textStr
            self.textLabel?.textColor = UIColor.black
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        cellLine.frame = CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5)
//        constrain(self.cellLine){view in
//            view.bottom == view.superview!.bottom
//            view.left == view.superview!.left
//            view.width == view.superview!.width
//            view.height == 0.5
//            
//            
//        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
