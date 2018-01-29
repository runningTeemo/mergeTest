//
//  RootDataModel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RootDataModel: NSObject {

    /**
     把模型转化成字典
     
     - author: zerlinda
     - date: 16-09-06 19:09:56
     
     - parameter instance: 模型
     
     - returns: 字典
     */
    class func getDic(_ model:RootDataModel)->Dictionary<String,AnyObject>?{
        let dic:Dictionary<String,AnyObject> = Dictionary()
//        if let dict = model.keyValues{
//            do{ //转化为JSON 字符串，打印出来更直观
//                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
//    
//                dic = dict
//            }catch{
//                print("解析异常")
//            }
//        }
        return dic
    }
    
    /**
     把模型转化成json字符串
     
     - author: zerlinda
     - date: 16-09-06 19:09:51
     
     - parameter instance: 模型
     
     - returns: json格式字符串
     */
    class func getDicStr(_ model:RootDataModel)->String{
       
        var DicStr = ""
        if let dict = model.keyValues{
            do{ //转化为JSON 字符串，打印出来更直观
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
              DicStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            }catch{
                print("解析异常")
            }
        }
        return DicStr
    }
    
    func updateDataModel(){
        
    }
    
}
