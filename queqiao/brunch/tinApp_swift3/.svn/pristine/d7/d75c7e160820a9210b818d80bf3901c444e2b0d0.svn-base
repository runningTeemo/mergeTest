//
//  StaticCellTextInput.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/30.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class StaticCellTextInputItem: StaticCellBaseItem {
    
    var title: String?
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var titleColor: UIColor = HEX("#666666")
    /// 采用富文本覆盖上面的内容
    var attributeTitle: NSAttributedString?
    
    var text: String?
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    var textColor: UIColor = HEX("#333333")
    
    var placeHolder: String?
    var placeHolderAttributes: [String: Any]?
    
    var maxCharCount: Int? = 300 // nil 表示没限制
    var keyboardTyle: UIKeyboardType = .default
    var customKeyboard: UIView?
    var security: Bool = false
    
    var canEdit: Bool = true
    
    var textFormatter: ((_ text: String?) -> String?)?
    var units: String?
    
    var disableAutoCorect: Bool = false
    
}

class StaticCellTextInputCell: StaticCellBaseCell, UITextFieldDelegate {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellTextInputItem {
            
            if let attr = item.attributeTitle {
                titleLabel.attributedText = attr
            } else {
                titleLabel.font = item.titleFont
                titleLabel.textColor = item.titleColor
                titleLabel.text = item.title
            }
            
            textField.text = item.text
            textField.textColor = item.textColor
            textField.font = item.textFont
            
            if let s = item.placeHolder {
                if let attri = item.placeHolderAttributes {
                    textField.attributedPlaceholder = NSAttributedString(string: s, attributes: attri)
                } else {
                    textField.attributedPlaceholder = NSAttributedString(string: s, attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                        NSForegroundColorAttributeName: kClrGray
                        ])
                }
            }
            textField.keyboardType = item.keyboardTyle
            textField.inputView = item.customKeyboard
            textField.isSecureTextEntry = item.security
            
            textField.isEnabled = item.canEdit
            
            item.updateCell = { [unowned self] in
                self.update()
                self.vc.editChanged = true
            }
            unitsLabel.text = item.units
            
            if item.disableAutoCorect {
                textField.autocapitalizationType = .none
                textField.autocorrectionType = .no
                textField.spellCheckingType = .no
            } else {
                textField.autocapitalizationType = .none
                textField.autocorrectionType = .default
                textField.spellCheckingType = .default
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    lazy var textField: UITextField = {
        let one = UITextField()
        one.textAlignment = .right
        one.delegate = self
        return one
    }()
    
    lazy var unitsLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrDeepGray
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        contentView.addSubview(unitsLabel)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.WIDTH(100).MAKE()
        textField.IN(contentView).LEFT(120).TOP.BOTTOM.MAKE()
        textField.RIGHT.EQUAL(unitsLabel).LEFT.OFFSET(-5).MAKE()
        unitsLabel.IN(contentView).RIGHT(15).TOP.BOTTOM.MAKE()
        textField.addTarget(self, action: #selector(StaticCellTextInputCell.editingChanged), for: .editingChanged)
        
        unitsLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        unitsLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        textField.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var charLimit: Int?
    func editingChanged() {
        if let l = (item as? StaticCellTextInputItem)?.maxCharCount {
            //textField.qxLimitToLength(l)
            if let t = textField.text {
                if t.characters.count > l {
                    let idx = t.index(t.startIndex, offsetBy: l)
                    textField.text = t.substring(to: idx)
                }
            }
        }
        if let textFormatter = (item as? StaticCellTextInputItem)?.textFormatter {
            textField.text = textFormatter(textField.text)
            unitsLabel.text = (item as! StaticCellTextInputItem).units
        }
        (item as? StaticCellTextInputItem)?.text = textField.text
        self.vc.editChanged = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.tableView.scrollToRow(at: self.indexPath as IndexPath, at: .top, animated: true)
        }
    }
}
