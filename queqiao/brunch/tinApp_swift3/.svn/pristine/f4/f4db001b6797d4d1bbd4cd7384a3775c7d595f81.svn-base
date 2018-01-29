//
//  LabelTextFieldCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LabelTextFieldCell: CommonCell {

    var label:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#666666")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    var textField:UITextField = {
       let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize:16)
        textField.textColor = MyColor.colorWithHexString("#333333")
        textField.textAlignment = NSTextAlignment.right
        return textField
    }()
    var labelText:String = ""{
        didSet{
           label.text = labelText
            label.sizeToFit()
        }
    }
    
    override func addModuleAndChangeFrame() {
        if cellWidth==0 {
            return
        }
     //   label.frame = CGRect(x: leftStartX, y: 0, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        self.contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
