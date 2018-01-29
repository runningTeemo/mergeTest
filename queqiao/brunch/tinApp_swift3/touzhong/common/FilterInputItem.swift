//
//  FilterInputItem.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FilterInputItem: RootFilterItem {
    
    var text: String?
    
    var placeHolder: String?
    var maxCharCount: Int? = 300 // nil 表示没限制
    var keyboardTyle: UIKeyboardType = .default
    var customKeyboard: UIView?
    var security: Bool = false
    
    var canEdit: Bool = true
    
    var respondChange: ((_ text: String?) -> ())?
    
    override init() {
        super.init()
        cellHeight = 40
    }
}

class FilterInputCell: RootFilterCell, UITextFieldDelegate {
    
    override func update() {
        super.update()
        if let item = item as? FilterInputItem {
            
            textField.text = item.text
            
            if let s = item.placeHolder {
                textField.attributedPlaceholder = NSAttributedString(string: s, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14 * kSizeRatio),
                    NSForegroundColorAttributeName: HEX("#9fa8b2")
                    ])
            }
            charLimit = item.maxCharCount
            textField.keyboardType = item.keyboardTyle
            textField.inputView = item.customKeyboard
            textField.isSecureTextEntry = item.security
            
            textField.isEnabled = item.canEdit
        }
    }
    
    lazy var bordView: UIView = {
        let one = UIView()
        one.layer.cornerRadius = 2
        one.layer.borderColor = kClrBreak.cgColor
        one.layer.borderWidth = 0.5
        one.clipsToBounds = true
        return one
    }()
    
    lazy var textField: UITextField = {
        let one = UITextField()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.clearButtonMode = .whileEditing
        one.delegate = self
        one.returnKeyType = .done
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bordView)
        contentView.addSubview(textField)
        bordView.IN(contentView).LEFT(12.5).TOP(1).RIGHT(12.5).BOTTOM(1).MAKE()
        textField.IN(contentView).LEFT(12.5 + 5).TOP.BOTTOM.RIGHT(12.5 + 5).MAKE()
        textField.addTarget(self, action: #selector(FilterInputCell.editingChanged), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var charLimit: Int?
    func editingChanged() {
        if let l = (item as? FilterInputItem)?.maxCharCount {
            if let t = textField.text {
                if t.characters.count > l {
                    let idx = t.characters.index(t.startIndex, offsetBy: l)
                    textField.text = t.substring(to: idx)
                }
            }
        }
        (item as? FilterInputItem)?.text = textField.text
        (item as? FilterInputItem)?.respondChange?(textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.tableView.scrollToRow(at: self.indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.endEditing(true)
        return true
    }
    
}
