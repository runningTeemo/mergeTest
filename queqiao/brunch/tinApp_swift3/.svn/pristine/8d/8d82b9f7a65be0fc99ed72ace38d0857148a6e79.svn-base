//
//  Button.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/26.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit


class LoadingButton: ButtonBack {
    
    var title: String? {
        didSet {
            myTitleLabel.text = title
            setNeedsLayout()
        }
    }
    
    func startLoading() {
        indicator.startAnimating()
        forceDown(true)
        loadingMode = true
        setNeedsLayout()
    }
    func stopLoading() {
        indicator.stopAnimating()
        forceDown(false)
        loadingMode = false
        setNeedsLayout()
    }
    
    var titlefont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet { myTitleLabel.font = titlefont }
    }
    
    var titleColor: UIColor = UIColor.white {
        didSet { myTitleLabel.textColor = titleColor }
    }
    lazy var myTitleLabel: UILabel = {
        let one = UILabel()
        one.isUserInteractionEnabled = false
        one.textAlignment = .left
        return one
    }()
    lazy var indicator: UIActivityIndicatorView = {
        let one = UIActivityIndicatorView(activityIndicatorStyle: .white)
        one.hidesWhenStopped = true
        return one
    }()
    
    fileprivate var loadingMode: Bool = false
    
    required init() {
        super.init()
        addSubview(myTitleLabel)
        addSubview(indicator)
        myTitleLabel.textColor = titleColor
        myTitleLabel.font = titlefont
        cornerRadius = 5
        layer.cornerRadius = cornerRadius
        norBgColor = HEX("#d61f26")
        dowBgColor = HEX("#c01a21")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let indicatorSize = CGSize(width: 20, height: 20)
        myTitleLabel.sizeToFit()
        let textWidth = myTitleLabel.frame.size.width
        if loadingMode {
            let totalWidth = textWidth + indicatorSize.width + 10
            let x = (bounds.size.width - totalWidth) / 2
            let indicatorY = (bounds.size.height - indicatorSize.height) / 2
            myTitleLabel.frame = CGRect(x: x, y: 0, width: textWidth, height: bounds.size.height)
            indicator.frame = CGRect(x: x + 10 + textWidth, y: indicatorY, width: indicatorSize.width, height: indicatorSize.height)
        } else {
            let x = (bounds.size.width - textWidth) / 2
            myTitleLabel.frame =  CGRect(x: x, y: 0, width: textWidth, height: bounds.size.height)
        }
        
    }
    
    override func onTouchDown() {
        backgroundColor = dowBgColor
    }
    
    override func onFailed() {
        backgroundColor = norBgColor
    }
    
    override func onSuccess() {
        startLoading()
        backgroundColor = dowBgColor
    }
    
}

class TitleButton: ButtonBack {
    
    override func forceDown(_ down: Bool) {
        super.forceDown(down)
        if down {
            myTitleLabel.font = dowTitlefont
            myTitleLabel.textColor = dowTitleColor
        } else {
            myTitleLabel.font = norTitlefont
            myTitleLabel.textColor = norTitleColor
        }
    }
    
    var title: String? {
        didSet {
            myTitleLabel.text = title
        }
    }
    
    var norTitlefont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet { myTitleLabel.font = norTitlefont }
    }
    var dowTitlefont: UIFont = UIFont.systemFont(ofSize: 16)
    
    var norTitleColor: UIColor = UIColor.black {
        didSet { myTitleLabel.textColor = norTitleColor }
    }
    var dowTitleColor: UIColor = UIColor.black
    
    lazy var myTitleLabel: UILabel = {
        let one = UILabel()
        one.isUserInteractionEnabled = false
        one.textAlignment = .center
        return one
    }()
    
    override var intrinsicContentSize : CGSize {
        let size = myTitleLabel.intrinsicContentSize
        return size
    }
    
    required init() {
        super.init()
        addSubview(myTitleLabel)
        myTitleLabel.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        myTitleLabel.textColor = norTitleColor
        myTitleLabel.font = norTitlefont
        norBgColor = HEX("#d61f26")
        dowBgColor = HEX("#c01a21")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onTouchDown() {
        super.onTouchDown()
        myTitleLabel.font = dowTitlefont
        myTitleLabel.textColor = dowTitleColor
    }
    
    override func onFailed() {
        super.onFailed()
        myTitleLabel.font = norTitlefont
        myTitleLabel.textColor = norTitleColor
    }

    override func onSuccess() {
        super.onSuccess()
        self.myTitleLabel.font = self.norTitlefont
        self.myTitleLabel.textColor = self.norTitleColor
    }
    
    override func onAnimate() {
        self.myTitleLabel.font = self.dowTitlefont
        self.myTitleLabel.textColor = self.dowTitleColor
        self.backgroundColor = self.dowBgColor
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.myTitleLabel.font = self?.norTitlefont
            self?.myTitleLabel.textColor = self?.norTitleColor
            self?.backgroundColor = self?.norBgColor
        }
    }
    
}

class ImageButton: ButtonBack {
    lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        one.isUserInteractionEnabled = false
        return one
    }()
    required init() {
        super.init()
        addSubview(iconView)
        iconView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        norBgColor = UIColor.clear
        dowBgColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 动作
    override func onTouchDown() {
        iconView.alpha = 0.5
    }
    
    override func onFailed() {
        iconView.alpha = 1
    }
    
    override func onSuccess() {
        super.onSuccess()
        iconView.alpha = 1
    }
    
    override func onAnimate() {
        iconView.alpha = 0.5
        self.backgroundColor = self.dowBgColor
        UIView.animate(withDuration: 0.3, animations: {
            self.iconView.alpha = 1
            self.backgroundColor = self.norBgColor
        }) 
    }
    
}

class ImageFixButton: ButtonBack {
    
    var iconSize: CGSize = CGSize(width: 15, height: 15) {
        didSet {
            iconWidthCons?.constant = iconSize.width
            iconHeightCons?.constant = iconSize.height
        }
    }
    fileprivate var iconWidthCons: NSLayoutConstraint?
    fileprivate var iconHeightCons: NSLayoutConstraint?
    lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        one.isUserInteractionEnabled = false
        one.contentMode = .scaleAspectFit
        return one
    }()
    required init() {
        super.init()
        addSubview(iconView)
        iconView.IN(self).CENTER.MAKE()
        iconWidthCons = iconView.WIDTH.EQUAL(iconSize.width).MAKE()
        iconHeightCons = iconView.HEIGHT.EQUAL(iconSize.height).MAKE()
        norBgColor = UIColor.clear
        dowBgColor = UIColor.clear
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func iconAtRight() {
//        iconView.REMOVE_CONSES()
//        iconView.IN(self).RIGHT.CENTER.MAKE()
//        iconWidthCons = iconView.WIDTH.EQUAL(iconSize.width).MAKE()
//        iconHeightCons = iconView.HEIGHT.EQUAL(iconSize.height).MAKE()
//    }
//    func iconAtLeft() {
//        iconView.REMOVE_CONSES()
//        iconView.IN(self).LEFT.CENTER.MAKE()
//        iconWidthCons = iconView.WIDTH.EQUAL(iconSize.width).MAKE()
//        iconHeightCons = iconView.HEIGHT.EQUAL(iconSize.height).MAKE()
//    }
    
    override func forceDown(_ down: Bool) {
        super.forceDown(down)
        alpha = down ? 0.5 : 1
    }
    
    // 动作
    override func onTouchDown() {
        iconView.alpha = 0.5
    }
    
    override func onFailed() {
        iconView.alpha = 1
    }
    
    override func onSuccess() {
        super.onSuccess()
        iconView.alpha = 1
    }
    
    override func onAnimate() {
        iconView.alpha = 0.5
        self.backgroundColor = self.dowBgColor
        UIView.animate(withDuration: 0.3, animations: {
            self.iconView.alpha = 1
            self.backgroundColor = self.norBgColor
        }) 
    }

}


class ButtonBack: UIControl {
    
    /// 强制设置为按下状态（这个状态下不可点击）
    func forceDown(_ down: Bool) {
        if down {
            backgroundColor = dowBgColor
        } else {
            backgroundColor = norBgColor
        }
        isUserInteractionEnabled = !down
    }
    
    /// 强制设置为按下状态（这个状态下不可点击）
    func forceDisable(_ disable: Bool) {
        if disable {
            alpha = 0.3
        } else {
            alpha = 1
        }
        isUserInteractionEnabled = !disable
    }
    
    var norBgColor: UIColor = UIColor.orange {
        didSet {
            backgroundColor = norBgColor
        }
    }
    var dowBgColor: UIColor = kClrBtnDown
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var animate: Bool = true
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = norBgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 模拟touchUpInSide
    
    fileprivate var outOfRange = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        outOfRange = false
        onTouchDown()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if outOfRange {
            onFailed()
            return
        }
        if let touch = touches.first {
            let point = touch.location(in: self)
            if !bounds.contains(point) {
                outOfRange = true
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if outOfRange {
            onFailed()
            return
        }
        onSuccess()
        sendActions(for: .touchUpInside)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onFailed()
    }
    
    // 动作
    func onTouchDown() {
        backgroundColor = dowBgColor
    }
    
    func onFailed() {
        backgroundColor = norBgColor
    }
    
    func onSuccess() {
        if animate {
            onAnimate()
        } else {
            self.backgroundColor = self.norBgColor
        }
    }
    
    func onAnimate() {
        self.backgroundColor = self.dowBgColor
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = self.norBgColor
        }) 
    }

}

class BorderButton: TitleButton {
    
    var norBorderColor: UIColor = HEX("#fda271") {
        didSet {
            layer.borderColor = norBorderColor.cgColor
        }
    }
    var norBorderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = norBorderWidth
        }
    }
    var dowBorderColor: UIColor = kClrSlightGray
    var dowBorderWidth: CGFloat = 1
    var borderRadius: CGFloat = 3 {
        didSet {
            layer.cornerRadius = borderRadius
        }
    }
    
    override func onTouchDown() {
        super.onTouchDown()
        myTitleLabel.font = dowTitlefont
        myTitleLabel.textColor = dowTitleColor
        layer.borderWidth = dowBorderWidth
        layer.borderColor = dowBorderColor.cgColor
    }
    
    override func onFailed() {
        super.onFailed()
        myTitleLabel.font = norTitlefont
        myTitleLabel.textColor = norTitleColor
        layer.borderWidth = norBorderWidth
        layer.borderColor = norBorderColor.cgColor
    }
    override func onSuccess() {
        super.onSuccess()
        myTitleLabel.font = norTitlefont
        myTitleLabel.textColor = norTitleColor
        layer.borderWidth = norBorderWidth
        layer.borderColor = norBorderColor.cgColor
    }
    
    required init() {
        super.init()
        norBgColor = UIColor.clear
        dowBgColor = UIColor.clear
        norTitleColor = UIColor.orange
        dowTitleColor = UIColor.lightGray
        layer.cornerRadius = borderRadius
        layer.borderWidth = norBorderWidth
        layer.borderColor = norBorderColor.cgColor
        clipsToBounds = true
        setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize : CGSize {
        let size = myTitleLabel.intrinsicContentSize
        return CGSize(width: size.width + 10 * 2, height: size.height + 3 * 2)
    }
    
}


