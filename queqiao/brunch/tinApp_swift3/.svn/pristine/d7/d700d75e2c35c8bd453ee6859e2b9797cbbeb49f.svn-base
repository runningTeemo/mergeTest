//
//  RootNavigationController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav 背景色
//        let image = UIImage.image(CGSize(width: 10, height: 10), color: UIColor.white)
//        navigationBar.setBackgroundImage(image, for: .default)
        
        // nav 颜色设置
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        // 箭头颜色
        navigationBar.tintColor = UIColor.white

        // 去除nav 底下的黑线
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
                
//        interactivePopGestureRecognizer?.delegate = self
        
    }
    
}

class CustomNavView: UIView {
    
    var respondBack: (() -> ())?
    var respondRefresh: ((_ done: @escaping (() -> ())) -> ())?
    
    var respondTransparent: (() -> ())?
    var respondWhite: (() -> ())?

    var viewHeight: CGFloat { return 20 + 44 }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrTitle
        one.font = UIFont.systemFont(ofSize: 18)
        one.textAlignment = .center
        return one
    }()

    func changeAlpha(_ a: CGFloat) {
        backView.alpha = a
        breakLine.alpha = a
    }
    
    lazy var backView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrWhite
        return one
    }()
    
    lazy var breakLine: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#b2b2b2")
        return one
    }()
    
//    lazy var indicatorCenter: UIActivityIndicatorView = {
//        let one = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        one.hidesWhenStopped = false
//        return one
//    }()
//    lazy var indicatorTitle: UIActivityIndicatorView = {
//        let one = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        one.hidesWhenStopped = false
//        one.isHidden = true
//        return one
//    }()
    
    
    var gradient: Bool = false
    private var navAlpha: CGFloat = 0
    private var isLoading: Bool = false
    private var scrollOffsetY: CGFloat = 0
    
    func handleScrollBegin() {
        
    }
    func handleScrollEnd() {
//        if !isLoading {
//            if scrollOffsetY < -60 {
//                isLoading = true
//                indicatorCenter.startAnimating()
//                indicatorTitle.startAnimating()
//                respondRefresh?({ [weak self] in
//                    self?.indicatorCenter.stopAnimating()
//                    self?.indicatorTitle.stopAnimating()
//                    self?.indicatorCenter.isHidden = true
//                    self?.indicatorTitle.isHidden = true
//                    self?.isLoading = false
//                    })
//            }
//        }
    }
    func handleScroll(offsetY: CGFloat, headHeight: CGFloat) {
        
        scrollOffsetY = offsetY
        
        let totalHeight = headHeight - 64
        if offsetY > 0 {
            navAlpha =  offsetY / totalHeight
            navAlpha = min(navAlpha, 1)
        } else {
            navAlpha = 0
        }
        
        // 当 searchView 的背景接近白色时，状态栏的颜色变黑色
        if navAlpha > 0.9 {
            respondWhite?()
            if !gradient {
                changeAlpha(1)
            }
            
            titleLabel.isHidden = false
//            indicatorCenter.isHidden = true
//            indicatorTitle.isHidden = self.isLoading ? false : true
            
            backBlackBtn.isHidden = false
            backWhiteBtn.isHidden = true
            
        } else {
            
            respondTransparent?()
            if !gradient {
                changeAlpha(0)
            }
            
            titleLabel.isHidden = true
//            indicatorCenter.isHidden = self.isLoading ? false : true
//            indicatorTitle.isHidden = true
            
            backBlackBtn.isHidden = true
            backWhiteBtn.isHidden = false
        }
        
        if gradient {
            changeAlpha(navAlpha)
        }
        
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        addSubview(backView)
        backView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        addSubview(titleLabel)
        titleLabel.IN(self).BOTTOM.HEIGHT(44).CENTER.MAKE()
        titleLabel.WIDTH.LESS_THAN_OR_EQUAL(kScreenW - 100 * 2).MAKE()
        
        addSubview(breakLine)
        breakLine.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(0.5).MAKE()
//        // 实现view下方的分割线
//        layer.shadowOffset = CGSize(width: 0, height: 0.1)
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 1
//        layer.shadowRadius = 0.4;//阴影半径，默认3
        
//        qxRamdomColorForAllViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backWhiteBtn: BarIconButton = {
        let one = BarIconButton(iconName: "iconTopBackWhite")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondBack?()
            })
        return one
    }()
    lazy var backBlackBtn: BarIconButton = {
        let one = BarIconButton(iconName: "iconTopBackBlack")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondBack?()
            })
        return one
    }()
    func setupBackButton() {
        self.addSubview(backWhiteBtn)
        self.addSubview(backBlackBtn)
        backBlackBtn.IN(self).LEFT.BOTTOM.SIZE(40, 44).MAKE()
        backWhiteBtn.IN(self).LEFT.BOTTOM.SIZE(40, 44).MAKE()
    }
    
}
