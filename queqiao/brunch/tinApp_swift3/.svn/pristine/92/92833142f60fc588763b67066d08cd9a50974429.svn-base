//
//  LoaingView.swift
//  UIActivityIndicatorViewTest
//
//  Created by zerlinda on 2016/12/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func showDefaultLoading(){
        let view = self.superview?.viewWithTag(self.tag + 1111)
        if view != nil {
           view?.removeFromSuperview()
        }
        let loadingV : UIActivityIndicatorView = UIActivityIndicatorView()
        loadingV.frame = self.frame
        loadingV.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingV.startAnimating()
        loadingV.backgroundColor = UIColor.white
        loadingV.layer.cornerRadius = self.layer.cornerRadius
        loadingV.layer.masksToBounds = self.clipsToBounds
        loadingV.alpha = 0.8
        loadingV.tag = self.tag + 1111
        self.superview?.addSubview(loadingV)
        self.superview?.bringSubview(toFront: loadingV)
    }
    func hideDefaultLoading(){
        if self.superview?.subviews != nil {
            for view in (self.superview?.subviews)! {
                if view.classForCoder == UIActivityIndicatorView.classForCoder() && view.tag == self.tag + 1111{
                    print("找到啦")
                    view.removeFromSuperview()
                }
            }
        }
    }
    
}

