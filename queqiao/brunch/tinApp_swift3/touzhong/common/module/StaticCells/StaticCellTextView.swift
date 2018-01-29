//
//  StaticCellTextView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/23.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellTextViewItem: StaticCellBaseItem {
    
    var holderText: String?
    var text: String?
    var title: String?
    
    var maxCharCount: Int? = 300 // nil 表示没限制,默认300字
    
    override init() {
        super.init()
        cellHeight = 100
    }
    
}

class StaticCellTextViewCell: StaticCellBaseCell, UITextViewDelegate {

    override func update() {
        super.update()
        if let item = item as? StaticCellTextViewItem {
            holderLabel.text = item.holderText
            textView.text = item.text
            if textView.text.characters.count > 0 {
                holderLabel.isHidden = true
            } else {
                holderLabel.isHidden = false
            }
        }
    }
    
    lazy var textView: UITextView = {
        let one = UITextView()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrDarkGray
        one.tintColor = kClrBlack
        one.delegate = self
        return one
    }()
    lazy var holderLabel: Label = {
        let one = Label()
        one.textColor = kClrGray
        one.font = UIFont.systemFont(ofSize: 14)
        one.text = "输入内容"
        one.numberOfLines = 0
        one.vertAligment = .top
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        contentView.addSubview(holderLabel)
        textView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP(12).BOTTOM(12).MAKE()
        holderLabel.IN(contentView).LEFT(17).TOP(20).RIGHT(15).BOTTOM(20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textViewDidChange(_ textView: UITextView) {
        if let l = (item as? StaticCellTextViewItem)?.maxCharCount {
            if let t = textView.text {
                if t.characters.count > l {
                    let idx = t.characters.index(t.startIndex, offsetBy: l)
                    textView.text = t.substring(to: idx)
                }
            }
//            textView.qxLimitToLength(l)
        }
        if textView.text.characters.count > 0 {
            holderLabel.isHidden = true
        } else {
            holderLabel.isHidden = false
        }
        (item as? StaticCellTextViewItem)?.text = textView.text
        self.vc.editChanged = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.tableView.scrollToRow(at: self.indexPath as IndexPath, at: .top, animated: true)
        }
    }
}
