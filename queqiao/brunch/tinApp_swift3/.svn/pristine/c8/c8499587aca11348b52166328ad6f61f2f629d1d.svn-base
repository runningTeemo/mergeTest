//
//  IconTextInput.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/14.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class IconTextInput: UIView {
    
    var editingChanged: ((_ textField: UITextField) -> ())?
    var rightIconCLick: ((_ icon: ImageButton) -> ())?
    
    lazy var leftIconView: ImageView = {
        let one = ImageView(type: .image)
        one.image = nil
        return one
    }()
    
    lazy var rightIconView: ImageFixButton = {
        let one = ImageFixButton()
        one.iconView.image = nil
        one.iconSize = CGSize(width: 24, height: 24)
        one.addTarget(self, action: #selector(IconTextInput.rightIconClick(_:)), for: .touchUpInside)
        return one
    }()
    func rightIconClick(_ icon: ImageButton) {
        rightIconCLick?(icon)
    }
    
    lazy var textField: UITextField = {
        let one = UITextField()
        one.font = UIFont.systemFont(ofSize: 16)
        one.addTarget(self, action: #selector(IconTextInput.textFieldEditingChanged), for: .editingChanged)
        return one
    }()
    func textFieldEditingChanged() {
        editingChanged?(self.textField)
    }
    
    func setNormalStyle() {
        layer.cornerRadius = 5
        layer.borderColor = HEX("#cecece").cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
        backgroundColor = kClrWhite
    }
    
    func setAlertStyle() {
        layer.cornerRadius = 5
        layer.borderColor = MyColor.colorWithHexString("#f06848").cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
        backgroundColor = kClrWhite
    }
    
    required init(showRightIcon: Bool) {
        super.init(frame: CGRect.zero)
        setNormalStyle()
        if showRightIcon {
            addSubview(leftIconView)
            addSubview(textField)
            addSubview(rightIconView)
            leftIconView.IN(self).LEFT(10).CENTER.SIZE(20, 20).MAKE()
            textField.IN(self).LEFT(40).RIGHT(45).TOP.BOTTOM.CENTER.MAKE()
            rightIconView.IN(self).RIGHT.CENTER.SIZE(35, 35).MAKE()
        } else {
            addSubview(leftIconView)
            addSubview(textField)
            leftIconView.IN(self).LEFT(10).CENTER.SIZE(20, 20).MAKE()
            textField.IN(self).LEFT(40).RIGHT(10).TOP.BOTTOM.CENTER.MAKE()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
