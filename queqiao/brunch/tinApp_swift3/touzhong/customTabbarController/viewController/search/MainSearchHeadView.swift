//
//  MainSearchHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/10.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MainSearchHeadView: UIView, UITextFieldDelegate {
    
    var respondBack: (() -> ())?
    var respondClean: (() -> ())?
    var respondSearch: ((_ key: String) -> ())?
    var respondFilter: (() -> ())?
    var respondChange: ((_ key: String?) -> ())?
    var respondBeginEditing: ((_ key: String?) -> ())?
    
    func showSearch() {
        filterIconBtn.isHidden = true
        searchBtn.isHidden = false
    }
    
    func showFilter() {
        filterIconBtn.isHidden = false
        searchBtn.isHidden = true
    }

    lazy var btnBack: BarIconButton = {
        let one = BarIconButton(iconName: "iconTopBackBlack")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondBack?()
        })
        return one
    }()
    lazy var searchBar: SearchView = {
        let one = SearchView()
        one.iconView.iconView.image = UIImage(named: "iconInputCancle")
        one.iconView.isHidden = true
        one.iconView.signal_event_touchUpInside.head({ [unowned self, unowned one] (signal) in
            one.textField.text = nil
            self.searchBtn.forceDown(true)
            self.respondClean?()
            one.iconView.isHidden = true
        })
        one.textField.signal_event_editingChanged.head({ [unowned self, unowned one] (signal) in
            if let text = one.textField.text {
                if text.characters.count > 99 {
                   one.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
            }
            one.iconView.isHidden = NullText(one.textField.text)
            self.searchBtn.forceDown(NullText(one.textField.text))
            self.respondChange?(one.textField.text)
        })
        one.textField.signal_event_editingDidBegin.head({ [unowned self, unowned one] (signal) in
            one.iconView.isHidden = NullText(one.textField.text)
            self.showSearch()
            self.searchBtn.forceDown(NullText(one.textField.text))
            self.respondBeginEditing?(one.textField.text)
        })
        one.textField.signal_event_editingDidEnd.head({ [unowned self, unowned one] (signal) in
            one.iconView.isHidden = NullText(one.textField.text)
        })
        one.textField.delegate = self
        one.transAlpha = 0.5
        return one
    }()
    lazy var searchBtn: TitleButton = {
        let one = TitleButton()
        one.norTitlefont = UIFont.systemFont(ofSize: 18)
        one.dowTitlefont = UIFont.systemFont(ofSize: 18)
        one.norTitleColor = kClrDeepGray
        one.dowTitleColor = kClrLightGray
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.signal_event_touchUpInside.head({ [unowned self, unowned one] (signal) in
            self.respondSearch?(self.searchBar.textField.text!)
            })
        one.title = "搜索"
        return one
    }()
    lazy var filterIconBtn: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 20, height: 20)
        one.iconView.image = UIImage(named: "iconTopFilter")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondFilter?()
            })
        one.forceDown(true)
        return one
    }()
 
    var viewHeight: CGFloat { return 20 + 7 + 30 + 7 }
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(btnBack)
        addSubview(searchBar)
        addSubview(searchBtn)
        addSubview(filterIconBtn)

        btnBack.IN(self).LEFT.TOP.BOTTOM.WIDTH(30).MAKE()
        searchBar.IN(self).LEFT(30).RIGHT(50).TOP.BOTTOM.MAKE()
        searchBtn.IN(self).RIGHT.TOP.BOTTOM.MAKE()
        filterIconBtn.IN(self).RIGHT.TOP.BOTTOM.WIDTH(40).MAKE()
        filterIconBtn.isHidden = true
        self.searchBtn.forceDown(true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if NotNullText(textField.text) {
            respondSearch?(textField.text!)
        }        
        return true
    }
    
}
