//
//  UIViewExt.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

extension UIView {
    func qxRamdomColorForAllViews() {
        func ramdomColor() -> UIColor {
            let r = CGFloat(arc4random_uniform(255)) / 255
            let g = CGFloat(arc4random_uniform(255)) / 255
            let b = CGFloat(arc4random_uniform(255)) / 255
            let a = CGFloat(arc4random_uniform(255)) / 255
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        backgroundColor = ramdomColor()
        if subviews.count > 0 {
            for subView in subviews {
                subView.qxRamdomColorForAllViews()
            }
        }
    }
}
