//
//  IndexViewSearchView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndexViewSearchView: UIView {
    
    var respondCLick: (() -> ())?
    
    lazy var searchBar: SearchView = {
        let one = SearchView()
        one.userInteractionEnabled = false
        return one
    }()
    lazy var coverBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondCLick?()
        })
        return one
    }()
    
    var transAlpha: CGFloat = 0 {
        didSet {
            //backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: transAlpha)
            searchBar.transAlpha = transAlpha
        }
    }
    
    var viewHeight: CGFloat { return 20 + 7 + 30 + 7 }
    required init() {
        super.init(frame: CGRectZero)
        addSubview(searchBar)
        addSubview(coverBtn)
        searchBar.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        coverBtn.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        // 实现view下方的分割线
//        layer.shadowOffset = CGSizeMake(0, 0.1)
//        layer.shadowColor = UIColor.blackColor().CGColor
//        layer.shadowOpacity = 1
//        layer.shadowRadius = 0.4;//阴影半径，默认3

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
