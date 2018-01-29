//
//  TestTableViewCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var index:IndexPath?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print(self.frame.size.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print((self.index as NSIndexPath?)?.row ?? 0)
        print(self.frame.size.width)
    }

}
