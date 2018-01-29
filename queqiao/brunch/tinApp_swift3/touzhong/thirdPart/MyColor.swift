//
//  MyColor.swift
//  NewProject
//
//  Created by Zerlinda on 16/6/1.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit

class MyColor: NSObject {

      class func colorWithHexString(_ color:String)->UIColor{
      
        let set = NSCharacterSet.whitespacesAndNewlines
        var cString = color.trimmingCharacters(in: set).uppercased()
        
        if cString.characters.count<6 {
            
            return UIColor.clear
        }
        if cString.hasPrefix("0x") {
           
            cString = (cString as NSString).substring(from: 2)
        }
        if cString.hasPrefix("#") {
            
            cString = (cString as NSString).substring(from: 1)
        }
        if cString.characters.count != 6 {
            
            return UIColor.clear
        }
        
        var range = NSMakeRange(0, 2)
        let rStr = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gStr = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bStr = (cString as NSString).substring(with: range)
        
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
      
        (Scanner.localizedScanner(with: rStr) as! Scanner).scanHexInt32(&r)
        (Scanner.localizedScanner(with: gStr) as! Scanner).scanHexInt32(&g)
        (Scanner.localizedScanner(with: bStr) as! Scanner).scanHexInt32(&b)
        return  UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
        
    }
    
}
