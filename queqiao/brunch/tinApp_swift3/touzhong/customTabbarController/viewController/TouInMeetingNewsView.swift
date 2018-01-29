//
//  TouInMeetingNewsView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TouInMeetingNewsView: UIView {
    
    var responder: (() -> ())?
    
    var viewHeight: CGFloat { return 72 }
    
    lazy var dotView1: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        one.clipsToBounds = true
        return one
    }()
    lazy var dotView2: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        one.clipsToBounds = true
        return one
    }()
    
    lazy var imageView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHyTzhy")
        return one
    }()
    
    lazy var label1: UILabel = {
        let one = UILabel()
        one.font = kFontNormal
        one.textColor = kClrDeepGray
        return one
    }()
    lazy var label2: UILabel = {
        let one = UILabel()
        one.font = kFontNormal
        one.textColor = kClrDeepGray
        return one
    }()
    lazy var arrowView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconListMore")
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        addSubview(imageView)
        addSubview(dotView1)
        addSubview(dotView2)
        addSubview(label1)
        addSubview(label2)
        addSubview(arrowView)
        imageView.IN(self).LEFT(20).TOP.SIZE(36, 49).MAKE()
        dotView1.IN(self).LEFT(75).TOP(20).SIZE(4, 4).MAKE()
        dotView2.IN(self).LEFT(75).BOTTOM(20).SIZE(4, 4).MAKE()
        dotView1.layer.cornerRadius = 2
        dotView2.layer.cornerRadius = 2
        arrowView.IN(self).RIGHT(12.5).CENTER.SIZE(15, 15).MAKE()
        label1.RIGHT(dotView1).OFFSET(10).CENTER.MAKE()
        label2.RIGHT(dotView2).OFFSET(10).CENTER.MAKE()
        label1.RIGHT.LESS_THAN_OR_EQUAL(arrowView).LEFT.OFFSET(-20).MAKE()
        label2.RIGHT.LESS_THAN_OR_EQUAL(arrowView).LEFT.OFFSET(-20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = kClrSlightGray
        responder?()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.backgroundColor = kClrWhite
        }
    }
    
}
