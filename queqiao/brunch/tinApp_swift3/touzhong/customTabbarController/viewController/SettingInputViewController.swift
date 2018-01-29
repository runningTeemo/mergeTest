//
//  SettingInputViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/3.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

typealias SettingInputHandler = ((_ msg: String?) -> ())

class SettingInputViewController: StaticCellBaseViewController {
    
    var text: String? {
        didSet {
            inputCell.textField.text = text
        }
    }
    var maxCharCount: Int? = 300 // nil 表示没限制
    var keyboardStyle: UIKeyboardType = .default
    var customKeyboard: UIView?
    var security: Bool = false

    var tip: String?
    
    var respondSave: ((_ text: String, _ success: SettingInputHandler?, _ fail: SettingInputHandler?) -> ())?
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.color = kClrBackGray
        one.height = 10
        return one
    }()

    lazy var inputHolderItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.color = UIColor.clear
        one.height = 50
        return one
    }()
    lazy var inputCell: SettingInputFixCell = {
        let one = SettingInputFixCell()
        return one
    }()
    
    lazy var tipItem: StaticCellTextItem = {
        let one = StaticCellTextItem()
        one.textFont = kFontTip
        one.textColor = kClrTip
        one.topMargin = 10
        one.bottomMargin = 40
        one.backColor = kClrBackGray
        one.update()
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "保存", responder: { [unowned self] in
            self.handleSave()
        })
        return one
    }()
    lazy var loadingNavItem: BarButtonItem = {
        let one = BarButtonItem(indicatorStyle: .gray)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBackBlackButton(nil)
        staticItems = [spaceItem, inputHolderItem, tipItem]
        setupRightNavItems(items: saveNavItem)
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        update()
        inputCell.textField.becomeFirstResponder()
    }
    
    func update() {
        inputCell.textField.text = text
        inputCell.textField.keyboardType = keyboardStyle
        inputCell.textField.inputView = customKeyboard
        inputCell.textField.isSecureTextEntry = security
        inputCell.charLimit = maxCharCount
        
        tipItem.text = tip
        tipItem.update()
        tableView.reloadData()
    }
    
    func handleSave() {
        view.endEditing(true)
        setupRightNavItems(items: loadingNavItem)

        let text = SafeUnwarp(inputCell.textField.text, holderForNull: "")
        respondSave?(text, { [weak self] msg in
            if let msg = msg {
                self?.setupRightNavItems(items: self?.saveNavItem)
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    self?.inputCell.textField.becomeFirstResponder()
                }
            } else {
                self?.setupRightNavItems(items: self?.saveNavItem)
                QXTiper.showSuccess("保存成功!", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                }
            }
            }, { [weak self] msg in
                self?.setupRightNavItems(items: self?.saveNavItem)
                QXTiper.showFailed(msg, inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    self?.inputCell.textField.becomeFirstResponder()
                }
        })
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            return inputCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
}

class SettingInputFixCell: UITableViewCell {
    
    var charLimit: Int?
    
    lazy var textField: UITextField = {
        let one = UITextField()
        one.textColor = HEX("#666666")
        one.font = UIFont.systemFont(ofSize: 14)
        one.signal_event_editingChanged.head({ [unowned self] (signal) in
            if let l = self.charLimit {
                if let t = self.textField.text {
                    if t.characters.count > l {
                        let idx = t.characters.index(t.startIndex, offsetBy: l)
                        self.textField.text = t.substring(to: idx)
                    }
                }
            }
        })
        return one
    }()
    lazy var deleteBtn: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 17, height: 17)
        one.iconView.image = UIImage(named: "iconInputCancle")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.textField.text = nil
        })
        return one
    }()
    
    init() {
        super.init(style: .default, reuseIdentifier: "SettingInputFixCell")
        contentView.addSubview(textField)
        contentView.addSubview(deleteBtn)
        textField.IN(contentView).LEFT(15).TOP.BOTTOM.RIGHT(40).MAKE()
        deleteBtn.IN(contentView).RIGHT.TOP.BOTTOM.WIDTH(40).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

