//
//  SearchView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SearchView: UIView {
        
    var transAlpha: CGFloat = 0 {
        didSet {
            layer.borderColor = UIColor(white: 0, alpha: 0.18 * transAlpha).cgColor
        }
    }
    
    lazy var textField: UITextField = {
        let one = UITextField()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.black
        one.placeholder = "搜索内容"
        one.tintColor = kClrGray
        one.returnKeyType = .search
        return one
    }()
    
    lazy var iconView: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 15, height: 15)
        one.iconView.image = UIImage(named: "iconSearchSmall")
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = RGBA(100, 100, 100, 255).cgColor
        clipsToBounds = true
        addSubview(textField)
        addSubview(iconView)
        layer.borderWidth = 0.5
        textField.IN(self).LEFT(10).RIGHT(15 + 10).TOP.BOTTOM.MAKE()
        iconView.IN(self).RIGHT(0).TOP.BOTTOM.WIDTH(35).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 这个用来实现搜索框背景的颜色渐变
class SearchBack: UIView {
    
    var transAlpha: CGFloat = 0 {
        didSet {

            // 实现view下方的分割线
            layer.shadowOffset = CGSize(width: 0, height: 0.1)
            layer.shadowColor = UIColor.black.cgColor
            if transAlpha > 0.9 {
                layer.shadowOpacity = 1
            } else {
                layer.shadowOpacity = 0
            }
            layer.shadowRadius = 0.4;//阴影半径，默认3
        }
    }
    
//    let radius: CGFloat = 5
    let borderWidth: CGFloat = 0.3
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 默认搜索提示居中
class SearchViewTypeB: RootView, UITextFieldDelegate {
    
    var respondBegin: (() -> ())?
    var respondSearch: ((_ text: String?) -> ())?
    var respondChange: ((_ text: String?) -> ())?
    var respondEnd: ((_ text: String?) -> ())?
    
    var characterLimit: Int = 10
    var placeHolder: String? {
        didSet {
            if let holder = placeHolder {
                searchLabel.text = holder
            } else {
                searchLabel.text = "搜索"
            }
        }
    }
    
    lazy var textField: UITextField = {
        let one = UITextField()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.black
        one.placeholder = ""
        one.backgroundColor = UIColor.clear
        one.delegate = self
        one.returnKeyType = .search
        one.signal_event_editingDidBegin.head({ [unowned self] (signal) in
            self.editBegin()
        })
        one.signal_event_editingChanged.head({ [unowned self] (signal) in
            self.editChange()
        })
        one.signal_event_editingDidEnd.head({ [unowned self] (signal) in
            self.editEnd()
        })
        return one
    }()
    lazy var searchBack: UIView = {
        let one = UIView()
        one.isUserInteractionEnabled = false
        one.backgroundColor = UIColor.clear
        one.addSubview(self.searchIcon)
        one.addSubview(self.searchLabel)
        one.HEIGHT.EQUAL(20).MAKE()
        self.searchIcon.IN(one).LEFT.CENTER.SIZE(15, 15).MAKE()
        self.searchLabel.IN(one).RIGHT.CENTER.MAKE()
        self.searchIcon.RIGHT.EQUAL(self.searchLabel).LEFT.OFFSET(-5).MAKE()
        return one
    }()
    lazy var searchIcon: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconSearchSmall")
        return one
    }()
    lazy var searchLabel: UILabel = {
        let one = UILabel()
        one.text = "搜索"
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.lightGray
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(textField)
        addSubview(searchBack)
        backgroundColor = UIColor.clear
        textField.IN(self).LEFT(20).RIGHT(10).TOP.BOTTOM.MAKE()
        searchBack.IN(self).CENTER.MAKE()
        searchOnCenter()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func searchOnLeft() {
        searchBack.IN(self).LEFT.CENTER.MAKE()
    }
    fileprivate func searchOnCenter() {
        searchBack.REMOVE_CONSES()
        searchBack.IN(self).CENTER.MAKE()
    }
    
    fileprivate func searchNeedsHide() -> Bool {
        if let text = textField.text {
            if text.characters.count > 0 {
                return true
            }
        }
        return false
    }
    fileprivate func checkToLimit() {
        if let text = textField.text {
            if text.characters.count > 0 {
                if text.characters.count > characterLimit {
                    textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
            }
        }
    }
    fileprivate func editBegin() {
        respondBegin?()
        searchOnLeft()
        searchLabel.isHidden = searchNeedsHide()
    }
    fileprivate func editChange() {
        checkToLimit()
        respondChange?(textField.text)
        searchLabel.isHidden = searchNeedsHide()
    }
    fileprivate func editEnd() {
        if NullText(textField.text) {
            searchOnCenter()
        }
        searchLabel.isHidden = searchNeedsHide()
        respondEnd?(textField.text)
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        respondSearch?(textField.text)
        return true
    }
    
}


class SearchHeaderView: RootView {
    
    var respondBegin: (() -> ())? {
        didSet {
            searchView.respondBegin = respondBegin
        }
    }
    var respondSearch: ((_ text: String?) -> ())? {
        didSet {
            searchView.respondSearch = respondSearch
        }
    }
    var respondChange: ((_ text: String?) -> ())?
    
    var respondEnd: ((_ text: String?) -> ())? {
        didSet {
            searchView.respondEnd = respondEnd
        }
    }
    
    var respondCancel: (() -> ())?
    
    var characterLimit: Int = 99 {
        didSet {
            searchView.characterLimit = characterLimit
        }
    }
    var placeHolder: String? {
        didSet {
            searchView.placeHolder = placeHolder
        }
    }
    
    lazy var backView: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor.white
        return one
    }()
    
    lazy var searchView: SearchViewTypeB = {
        let one = SearchViewTypeB()
        one.characterLimit = 99
        one.respondChange = { [unowned self] text in
            self.cancelIcon.isHidden = NullText(text)
            self.respondChange?(text)
        }
        return one
    }()
    
    lazy var cancelIcon: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 15, height: 15)
        one.iconView.image = UIImage(named: "iconInputCancle")
        one.signal_event_touchUpInside.head({ [unowned self, unowned one] (signal) in
            self.searchView.textField.text = nil
            self.respondCancel?()
            one.isHidden = true
            self.searchView.searchBack.isHidden = false
        })
        one.isHidden = true
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(backView)
        addSubview(searchView)
        addSubview(cancelIcon)
        backgroundColor = kClrBackGray
        backView.IN(self).LEFT.WIDTH(kScreenW).TOP(10).BOTTOM(10).MAKE()
        searchView.IN(backView).LEFT(12.5).RIGHT(12.5 + 20).TOP.BOTTOM.MAKE()
        cancelIcon.IN(backView).RIGHT(12.5).CENTER.SIZE(20, 30).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
