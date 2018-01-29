//
//  ArticleSearchView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleSearchHeader: UIView, UITextFieldDelegate {
    
    func reset() {
        searchBar.textField.text = nil
        isCleanModel = false
        segView.reset()
    }
    
    var respondSearch: ((_ key: String?) -> ())?
    var respondClean: (() -> ())?
    var respondChange: ((_ key: String?) -> ())?
    var respondBeginEditing: ((_ key: String?) -> ())?
    var respondEndEditing: ((_ key: String?) -> ())?

    class func headerHeight() -> CGFloat {
        return 50
    }
    
    class func viewHeight() -> CGFloat {
        return 50 + 44
    }
    
    var isCleanModel: Bool = false
    lazy var searchBar: SearchView = {
        let one = SearchView()
        one.backgroundColor = kClrSlightGray
        one.transAlpha = 0
        one.textField.placeholder = "搜索项目"
        one.textField.signal_event_editingChanged.head({ [unowned self, unowned one] (signal) in
            if let text = one.textField.text {
                if text.characters.count > 99 {
                    one.textField.text = text.substring(to: text.characters.index(text.endIndex, offsetBy: -1))
                }
            }
            self.respondChange?(one.textField.text)
            
            if NullText(one.textField.text) {
                self.isCleanModel = false
                self.searchBar.iconView.iconView.image = UIImage(named: "iconSearchSmall")
            } else {
                self.isCleanModel = true
                self.searchBar.iconView.iconView.image = UIImage(named: "iconInputCancle")
            }
            
        })
        one.textField.signal_event_editingDidBegin.head({ [unowned self, unowned one] (signal) in
            self.respondBeginEditing?(one.textField.text)
            if NullText(one.textField.text) {
                self.isCleanModel = false
                self.searchBar.iconView.iconView.image = UIImage(named: "iconSearchSmall")
            } else {
                self.isCleanModel = true
                self.searchBar.iconView.iconView.image = UIImage(named: "iconInputCancle")
            }
        })
        one.textField.signal_event_editingDidEnd.head({ [unowned self, unowned one] (signal) in
            self.respondEndEditing?(one.textField.text)
            if NullText(one.textField.text) {
                self.isCleanModel = false
                self.searchBar.iconView.iconView.image = UIImage(named: "iconSearchSmall")
            } else {
                self.isCleanModel = true
                self.searchBar.iconView.iconView.image = UIImage(named: "iconInputCancle")
            }
        })
        one.textField.delegate = self
        one.iconView.signal_event_touchUpInside.head({ [unowned self] (s) in
            if self.isCleanModel {
                self.searchBar.textField.text = nil
                self.respondClean?()
            }
        })
        return one
    }()
    
    let line1 = NewBreakLine
    let line2 = NewBreakLine

    lazy var segView: ArticleSearchSegView = {
        let one = ArticleSearchSegView()
        one.btn0.label.text = "项目"
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = kClrWhite
        addSubview(searchBar)
        addSubview(segView)
        addSubview(line1)
        addSubview(line2)
        searchBar.IN(self).LEFT(12.5).RIGHT(12.5).HEIGHT(30).TOP(10).MAKE()
        segView.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(44).MAKE()
        line1.IN(self).LEFT.RIGHT.TOP(49).HEIGHT(0.5).MAKE()
        line2.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(0.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        respondSearch?(textField.text)
        if NullText(textField.text) {
            self.isCleanModel = false
            self.searchBar.iconView.iconView.image = UIImage(named: "iconSearchSmall")
        } else {
            self.isCleanModel = true
            self.searchBar.iconView.iconView.image = UIImage(named: "iconInputCancle")
        }
        return true
    }
    
}

class ArticleSearchSegView: UIView {
    
    func reset() {
        foldAll()
        btn0.label.text = "项目"
        btn1.label.text = "城市不限"
        btn2.label.text = "最新发布"
    }
    
    var respondTag: ((_ tag: Int?, _ lastTag: Int?) -> ())?
    var currentTag: Int?
    
    func foldAll() {
        btn0.fold(true)
        btn1.fold(true)
        btn2.fold(true)
        currentTag = nil
    }
    
    lazy var btn0: ArticleSearchSegBtn = {
        let one = ArticleSearchSegBtn()
        one.label.text = "全部分类"
        one.fold(true)
        one.tag = 0
        one.addTarget(self, action: #selector(ArticleSearchSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btn1: ArticleSearchSegBtn = {
        let one = ArticleSearchSegBtn()
        one.label.text = "城市不限"
        one.fold(true)
        one.tag = 1
        one.addTarget(self, action: #selector(ArticleSearchSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btn2: ArticleSearchSegBtn = {
        let one = ArticleSearchSegBtn()
        one.label.text = "最新发布"
        one.fold(true)
        one.tag = 2
        one.addTarget(self, action: #selector(ArticleSearchSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    
    func btnClick(_ sender: ArticleSearchSegBtn) {
        
        let tag = sender.tag

        if let _tag = currentTag {
            if _tag == tag {
                foldAll()
                currentTag = nil
                respondTag?(nil, tag)
            } else {
                if tag == 0 {
                    btn0.fold(false)
                    btn1.fold(true)
                    btn2.fold(true)
                } else if tag == 1 {
                    btn0.fold(true)
                    btn1.fold(false)
                    btn2.fold(true)
                } else {
                    btn0.fold(true)
                    btn1.fold(true)
                    btn2.fold(false)
                }
                currentTag = tag
                respondTag?(tag, _tag)
            }
        } else {
            if tag == 0 {
                btn0.fold(false)
                btn1.fold(true)
                btn2.fold(true)
            } else if tag == 1 {
                btn0.fold(true)
                btn1.fold(false)
                btn2.fold(true)
            } else {
                btn0.fold(true)
                btn1.fold(true)
                btn2.fold(false)
            }
            currentTag = tag
            respondTag?(tag, nil)
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(btn0)
        addSubview(btn1)
        addSubview(btn2)
        
        btn0.IN(self).LEFT.TOP.BOTTOM.WIDTH(kScreenW / 3).MAKE()
        btn1.RIGHT(btn0).TOP.BOTTOM.WIDTH(kScreenW / 3).MAKE()
        btn2.RIGHT(btn1).TOP.BOTTOM.WIDTH(kScreenW / 3).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ArticleSearchSegBtn: ButtonBack {
    
    func fold(_ b: Bool) {
        if b {
            iconView.image = UIImage(named: "sortGrey")
            label.textColor = HEX("#666666")
        } else {
            iconView.image = UIImage(named: "sortRed")
            label.textColor = kClrDeepGray
        }
    }
    
    lazy var bgView: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor.clear
        return one
    }()
    
    lazy var label: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrDeepGray
        one.text = "全部分类"
        return one
    }()
    
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "sortGrey")
        return one
    }()
    
    required init() {
        super.init()
        norBgColor = UIColor.clear
        dowBgColor = UIColor.clear
        addSubview(bgView)
        addSubview(label)
        addSubview(iconView)
        
        bgView.IN(self).CENTER.MAKE()
        label.IN(bgView).LEFT.TOP.BOTTOM.MAKE()
        iconView.IN(bgView).RIGHT.CENTER.SIZE(11, 5).MAKE()
        label.RIGHT.EQUAL(iconView).LEFT.OFFSET(-2).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
