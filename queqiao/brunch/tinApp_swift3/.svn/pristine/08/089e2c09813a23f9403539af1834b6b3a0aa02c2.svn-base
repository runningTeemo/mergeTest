//
//  StaticCellCountTextView.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/9.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellCountTextViewItem: StaticCellTextViewItem {
    override init() {
        super.init()
        cellHeight = 100 + 40
    }
}

class StaticCellCountTextViewCell: StaticCellTextViewCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellCountTextViewItem {
            holderLabel.text = item.holderText
            textView.text = item.text
            
            if NotNull(item.maxCharCount) {
                let c: Int
                if let t = textView.text {
                    c = t.characters.count
                } else {
                    c = 0
                }
                let max = item.maxCharCount!
                counterLabel.text = "\(c)/\(max)"
                if c == max {
                    counterLabel.textColor = kClrOrange
                } else {
                    counterLabel.textColor = kClrGray
                }
            }
        }
    }
    
    lazy var counterLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrGray
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.REMOVE_CONSES()
        holderLabel.REMOVE_CONSES()
        textView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP(12).BOTTOM(40).MAKE()
        holderLabel.IN(contentView).LEFT(17).TOP(20).RIGHT(15).BOTTOM(40).MAKE()
        contentView.addSubview(counterLabel)
        counterLabel.IN(contentView).RIGHT(12.5).BOTTOM.HEIGHT(40).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        if NotNull((item as? StaticCellCountTextViewItem)?.maxCharCount) {
            let c: Int
            if let t = textView.text {
                c = t.characters.count
            } else {
                c = 0
            }
            let max = (item as! StaticCellCountTextViewItem).maxCharCount!
            counterLabel.text = "\(c)/\(max)"
            if c == max {
                counterLabel.textColor = kClrOrange
            } else {
                counterLabel.textColor = kClrGray
            }
        } else {
            counterLabel.text = nil
        }
    }
}
