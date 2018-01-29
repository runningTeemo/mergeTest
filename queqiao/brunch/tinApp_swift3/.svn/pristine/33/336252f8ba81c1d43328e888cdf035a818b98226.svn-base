//
//  InstitutionManageFundCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionManageFundCell: CommonCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var viewModel:InstitutionViewModel = InstitutionViewModel(){
        didSet{
            fillData()
            addModuleAndChangeFrame()
        }
    }
    var titleStr:String = ""{
        didSet{
            titleLabel.text = titleStr
        }
    }
    var titleArr:[String]? = [String]()
    var indexPath:IndexPath?{
        didSet{
         indexLabel.text = "\((indexPath! as NSIndexPath).row + 1)"
        }
    }
    var indexLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Oblique", size: 11)
        label.textColor = MyColor.colorWithHexString("#999999")
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    var titleLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#333333")
        return label
    }()
    
    func fillData(){

    }

    override func addModuleAndChangeFrame(){
        if cellWidth==0 {
            return
        }
        indexLabel.frame = CGRect(x: 0, y: 0, width: 30, height: self.contentView.frame.size.height)
        titleLabel.frame = CGRect(x: indexLabel.frame.maxX, y: 0, width: cellWidth-indexLabel.frame.maxX-40, height: self.contentView.frame.size.height)
        cellLine.frame = CGRect(x: 20, y: self.contentView.frame.size.height-0.5, width: cellWidth-40, height: 0.5)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(indexLabel)
        self.contentView.addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
