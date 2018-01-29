//
//  QXTiper.swift
//  tinCRM
//
//  Created by Richard.q.x on 16/8/3.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

typealias QXTiperContent = [UIView]

enum QXTipType {
    case success
    case warning
    case failed
    case waiting
}

class QXTiper {
    
    //MARK: public
    
    class func showSuccess(_ msg: String?, inView: UIView?, cover: Bool) {
        if inView == nil || msg == nil { return }
        let content = _show(.success, msg: msg!, inView: inView!, cover: cover)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            _hide(content)
        }
    }
    class func showFailed(_ msg: String?, inView: UIView?, cover: Bool) {
        if inView == nil || msg == nil { return }
        let content = _show(.failed, msg: msg!, inView: inView!, cover: cover)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            _hide(content)
        }
    }
    class func showWarning(_ msg: String?, inView: UIView?, cover: Bool) {
        if inView == nil || msg == nil { return }
        let content = _show(.warning, msg: msg!, inView: inView!, cover: cover)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            _hide(content)
        }
    }
    
    class func showWaiting(_ msg: String?, inView: UIView?, cover: Bool) -> QXTiperContent? {
        if inView == nil || msg == nil { return nil }
        return _show(.waiting, msg: msg!, inView: inView!, cover: cover)
    }
    class func hideWaiting(_ content: QXTiperContent?) {
        if content == nil { return }
        _hide(content!)
    }
    
    
    //MARK: private
    
    fileprivate class func _show(_ type: QXTipType, msg: String, inView: UIView, cover: Bool) -> [UIView] {

        var contents = QXTiperContent()
        
        if cover {
            let coverView = QXTipCover()
            coverView.backgroundColor = UIColor.black
            inView.addSubview(coverView)
            coverView.translatesAutoresizingMaskIntoConstraints = false
            inView.addConstraint(NSLayoutConstraint(item: coverView, attribute: .top, relatedBy: .equal, toItem: inView, attribute: .top, multiplier: 1, constant: 0))
            inView.addConstraint(NSLayoutConstraint(item: coverView, attribute: .bottom, relatedBy: .equal, toItem: inView, attribute: .bottom, multiplier: 1, constant: 0))
            inView.addConstraint(NSLayoutConstraint(item: coverView, attribute: .left, relatedBy: .equal, toItem: inView, attribute: .left, multiplier: 1, constant: 0))
            inView.addConstraint(NSLayoutConstraint(item: coverView, attribute: .right, relatedBy: .equal, toItem: inView, attribute: .right, multiplier: 1, constant: 0))
            contents.append(coverView)
            
            coverView.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                coverView.alpha = 0.1
                }, completion: nil)
            
        }
        
        let tipView = QXTipView(type: type)
        tipView.message = msg
        inView.addSubview(tipView)
        
        tipView.translatesAutoresizingMaskIntoConstraints = false
        inView.addConstraint(NSLayoutConstraint(item: tipView, attribute: .centerX, relatedBy: .equal, toItem: inView, attribute: .centerX, multiplier: 1, constant: 0))
        inView.addConstraint(NSLayoutConstraint(item: tipView, attribute: .centerY, relatedBy: .equal, toItem: inView, attribute: .centerY, multiplier: 1, constant: 0))
        contents.append(tipView)
        
        tipView.setNeedsLayout()
        tipView.layoutIfNeeded()

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.08
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        tipView.layer.add(animation, forKey: "QXTiper_animation")
        
        return contents
        
    }
    
    fileprivate class func _hide(_ content: QXTiperContent) {
        for v in content {
            v.removeFromSuperview()
        }
    }
    
}

class QXTipCover: UIButton { }

class QXTipView: UIView {
    
    let iconSize = CGSize(width: 25, height: 25)
    let inMargin: CGFloat = 12
    let outMargin: CGFloat = 20
    let maxWidth: CGFloat = UIScreen.main.bounds.size.width * 2 / 3
    let minWidth: CGFloat = 150
    
    required init(type: QXTipType) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        layer.cornerRadius = 3
        clipsToBounds = true
        
        addSubview(iconView)
        addSubview(indicatorView)
        addSubview(messageView)
        switch type {
        case .success:
            iconView.image = QXTipView._successImage
            iconView.isHidden = false
            indicatorView.stopAnimating()
        case .warning:
            iconView.image = QXTipView._warningImage
            iconView.isHidden = false
            indicatorView.stopAnimating()
        case .failed:
            iconView.image = QXTipView._failedImage
            iconView.isHidden = false
            indicatorView.stopAnimating()
        case .waiting:
            indicatorView.startAnimating()
            iconView.isHidden = true
        }
    }
    var message: String = "" {
        didSet {
            messageView.text = message
        }
    }
    
    fileprivate class func _getImage(_ name: String) -> UIImage {
        var path = Bundle.main.path(forResource: "QXTiper.bundle", ofType: nil)!
        let bundle = Bundle(path: path)!
        path = bundle.path(forResource: name, ofType: "png")!
        return UIImage(contentsOfFile: path)!
    }
    
    override var intrinsicContentSize : CGSize {
        let size = textSize()
        let width = size.width + outMargin * 2 + inMargin + iconSize.width
        if width < maxWidth {
            return CGSize(width: max(width, minWidth), height: max(75, size.height + outMargin * 2))
        } else {
            return CGSize(width: maxWidth, height: max(75, size.height + outMargin * 2))
        }
    }
    fileprivate func textSize() -> CGSize {
        let maxTextWidth: CGFloat = maxWidth - outMargin * 2 - inMargin - iconSize.width
        let attriStr = NSAttributedString(string: message, attributes: [
            NSFontAttributeName: messageView.font
            ])
        return attriStr.boundingRect(with: CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
    }
    
    fileprivate static let _successImage = QXTipView._getImage("icon_success")
    fileprivate static let _failedImage = QXTipView._getImage("icon_fail")
    fileprivate static let _warningImage = QXTipView._getImage("icon_warning")
    fileprivate lazy var iconView: UIImageView = {
        let one = UIImageView()
        return one
    }()
    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        let one = UIActivityIndicatorView(activityIndicatorStyle: .white)
        one.hidesWhenStopped = true
        return one
    }()
    fileprivate lazy var messageView: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.textAlignment = .left
        one.numberOfLines = 0
        one.font = UIFont.systemFont(ofSize: 17)
        return one
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.size.width
        if width < maxWidth {
            let textWidth = textSize().width
            let leftMargin = (bounds.size.width - textWidth - inMargin - iconSize.width) / 2
            iconView.frame = CGRect(x: leftMargin, y: (bounds.size.height - iconSize.height) / 2, width: iconSize.width, height: iconSize.height)
            indicatorView.frame = iconView.frame
            messageView.frame = CGRect(x: iconView.frame.maxX + inMargin, y: 0, width: textWidth, height: bounds.size.height)
        } else {
            iconView.frame = CGRect(x: outMargin, y: (bounds.size.height - iconSize.height) / 2, width: iconSize.width, height: iconSize.height)
            indicatorView.frame = iconView.frame
            messageView.frame = CGRect(x: iconView.frame.maxX + inMargin, y: 0, width: bounds.size.width - iconView.frame.maxX - inMargin - outMargin, height: bounds.size.height)
        }
        
    }
    
}
