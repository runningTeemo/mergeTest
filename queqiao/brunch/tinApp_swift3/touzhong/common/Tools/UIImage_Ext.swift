//
//  UIImage_Ext.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/18.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

typealias RectCtxClosure = (_ ctx: CGContext ,_ rect: CGRect) -> ()

extension UIImage {
    
    /**
     根据颜色生成一个固定大小的色块
     
     - parameter size:  生成图片大小
     - parameter color: 生成图片颜色

     - returns: 生成的固定大小的色块
     */
    class func image(_ size: CGSize, color: UIColor) -> UIImage {
        return self.image(size) { (ctx, rect) in
            color.setFill()
            ctx.fill(rect);
        }
    }
    
    /**
     工具方法：通过核心绘图上下文生成一个图片
     
     - parameter size:   绘图区域大小
     - parameter render: 绘图上下文
     
     - returns: 生成图片
     */
    class func image(_ size: CGSize, render: RectCtxClosure) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let ctx = UIGraphicsGetCurrentContext()!;
        render(ctx, CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
}
