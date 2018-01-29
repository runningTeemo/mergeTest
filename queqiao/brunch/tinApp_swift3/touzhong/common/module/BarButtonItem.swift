//
//  BarButtonItem.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/2.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class BarButtonItem: UIBarButtonItem {

    var responder: (() -> ())?
    
    var count: Int? {
        didSet {
            if let view = customView as? BarIconButton {
                view.count = count
            }
        }
    }
    
    init(indicatorStyle: UIActivityIndicatorViewStyle) {
        super.init()
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.customView = indicator
        indicator.startAnimating()
    }
    
    init(title: String, responder: (() -> ())?) {
        super.init()
        let attriStr = NSAttributedString(string: title, attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                        NSForegroundColorAttributeName: UIColor.black
                        ])
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(BarButtonItem.btnClick), for: .touchUpInside)
        btn.setAttributedTitle(attriStr, for: UIControlState())
        btn.sizeToFit()
        btn.frame = CGRect(x: 0, y: 0, width: btn.frame.width + 25, height: 40)
        self.customView = btn
        self.responder = responder
    }
    
    init(iconName: String, responder: (() -> ())?) {
        super.init()
        let view = BarIconButton(iconName: iconName)
        self.responder = responder
        self.customView = view
        view.addTarget(self, action: #selector(BarButtonItem.btnClick), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnClick() {
        responder?()
    }
    
}

/// 放在navgaiton上的按钮
class BarIconButton: ButtonBack {
    
    var iconView: UIImageView
    
    var count: Int? {
        didSet {
            if let c = count {
//                countLabel.isHidden = false
//                if c <= 99 {
//                    countLabel.text = "\(c)"
//                } else {
//                    countLabel.text = "99+"
//                }
                countLabel.isHidden = c == 0
            } else {
                countLabel.isHidden = true
            }
            
        }
    }
    
    lazy var countLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 9)
        one.backgroundColor = UIColor.red
        one.layer.cornerRadius = 4
        one.textAlignment = .center
        one.clipsToBounds = true
        return one
    }()
    
    /// 由于系统navgaitonItem位置的限制，这里的pos强制给按钮添加一定的偏移量，左边的按钮，选左边，右边的按钮选右边
    required init(iconName: String) {
        let iconView = UIImageView()
        iconView.image = UIImage(named: iconName)
        self.iconView = iconView
        super.init()
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        norBgColor = UIColor.clear
        dowBgColor = UIColor.clear
        addSubview(iconView)
        
        countLabel.isHidden = true
        addSubview(countLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = CGSize(width: 18, height: 18)
        iconView.frame = CGRect(x: (bounds.size.width - size.width) / 2, y: (bounds.size.height - size.height) / 2, width: size.width, height: size.height)
        
        do {
            let w: CGFloat = 8
            let h: CGFloat = 8
            let x = iconView.frame.maxX - w / 2
            let y = iconView.frame.minY
            countLabel.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func onSuccess() {
        super.onSuccess()
        iconView.alpha = 0.5
        UIView.animate(withDuration: 0.3, animations: {
            self.iconView.alpha = 1
        }) 
    }
    
}
