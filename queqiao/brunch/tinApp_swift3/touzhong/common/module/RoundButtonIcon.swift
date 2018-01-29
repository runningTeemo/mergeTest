//
//  RoundButtonIcon.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RoundUserIcon: UIButton {
    lazy var iconView: ImageView = {
        let one = ImageView(type: .user)
        one.image = nil
        return one
    }()
    
    lazy var circleView: CircleView = {
        let one = CircleView()
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(iconView)
        addSubview(circleView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = bounds
        circleView.frame = bounds
        iconView.layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2
    }
}


class CircleView: UIView {
    var edgeWidth: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    var color: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let edgeWidth = edgeWidth {
            let ctx = UIGraphicsGetCurrentContext()!
            let r = min(rect.width, rect.height) / 2
            let p = UIBezierPath(roundedRect: rect, cornerRadius: r)
            ctx.setLineWidth(edgeWidth * 2)
            ctx.addPath(p.cgPath)
            
            if let color = color {
                color.setStroke()
            } else {
                UIColor.white.setStroke()
            }
            ctx.strokePath()
        }
    }
}


class RoundImageIcon: UIButton {
    lazy var iconView: ImageView = {
        let one = ImageView(type: self.iconType)
        one.image = nil
        one.contentMode = UIViewContentMode.scaleAspectFit
        return one
    }()
    lazy var circleView: CircleView = {
        let one = CircleView()
        return one
    }()
    let iconType: IconType
    required init(iconType: IconType = .image) {
        self.iconType = iconType
        super.init(frame: CGRect.zero)
        addSubview(iconView)
        addSubview(circleView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = bounds
        circleView.frame = bounds
        iconView.layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2
    }
}
