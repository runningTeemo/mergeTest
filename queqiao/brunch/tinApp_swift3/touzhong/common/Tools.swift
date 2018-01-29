//
//  Tools.swift
//  touzhong
//
//  Created by zerlinda on 16/8/16.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit


class Tools: NSObject {
    
    //MARK:和时间数字相关
    
    /**
     根据时间字符串返回年
     */
    class func getYears(timeStr:String)->String{
        let str = (timeStr as NSString).substring(to: 4)
        return str
    }
    
    /**
     把时间转换成字符串
     - parameter date:          时间
     - parameter dataFormatter: 时间格式
     
     - returns: 时间字符串
     */
    class func getTimeStrFromDate(_ date:Date,dataFormatter:String?="yyyy-MM-dd 'at' HH:mm:ss.SSS")->String{
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = dataFormatter
        let timeStr = timeFormatter.string(from: date) as String
        return timeStr
    }
    /**
     获取系统时间字符串
     */
    class func getSystemTime(_ dataFormatter:String?="yyyy-MM-dd")->String{
        let date = Date()
        let strNowTime = getTimeStrFromDate(date,dataFormatter: dataFormatter)
        return strNowTime
    }
    
    /// 时间字符串转成时间
    ///
    /// - Parameters:
    ///   - dateString: 时间字符串
    ///   - formatterStr: 时间格式
    /// - Returns: 时间
    class func timteStrToTime(dateString:String,formatterStr:String? = "yyyy-MM-dd hh:mm:ss")->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        let date = formatter.date(from: dateString)
        return date!
    }
    
    /// 时间字符串转成时间戳
    ///
    /// - Parameter timeStr: 时间字符串
    /// - Returns: 时间戳
    class func timeStrToTimestemp(timeStr:String)->String{
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date1 = formatter1.date(from: timeStr)
        formatter1.timeZone = TimeZone(abbreviation: "Asia/Shanghai")
        // let nowStr = IntMax((date1?.timeIntervalSince1970)!)*1000
        // let milliSecs = CUnsignedLongLong((date1?.timeIntervalSince1970)! * 1000)
        let timeStemp = UInt64((date1?.timeIntervalSince1970)! * 1000)
        return "\(timeStemp)"
    }
    
    /// 获取系统的时间戳
    class func getSystemTimeStemp()->String{
        let timeStr = Tools.getSystemTime("yyyy-MM-dd hh:mm:ss")
        let timeStemp = Tools.timeStrToTimestemp(timeStr: timeStr)
        return timeStemp
    }
    class func timeStempToDate(timeStempStr:String)->Date{
        let timeStemp = UInt64(timeStempStr)
        let stemp = timeStemp!/1000
        let timeInterval:TimeInterval = TimeInterval(stemp)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
    
    
    
    ///保留小数
    class func decimal(_ fix:Int,originalStr:String)->String{
        if originalStr == "N/A" {
            return originalStr
        }
        let strF:CFloat = Float(originalStr)!
        return String(format: "%.\(fix)f", strF)
    }
    ///根据输入的分割字符串返回数组
    class func divisionStr(originStr:String,divisionStr:String)->[String]{
        let array = originStr.components(separatedBy: divisionStr)
        return array
    }
    ///是否包含字符串，不区分大小写
    class func contains(originStr:String,containStr:String)->Bool{
        let originStr = originStr.uppercased()
        let containStr = containStr.uppercased()
        if originStr.contains(containStr) {
            return true
        }
        return false
    }
    
    ///把json字符串转成字典
    class func jsonStrToDic(str:String)->Dictionary<String,Any>{
        var dic = [String:Any]()
        let data = str.data(using: String.Encoding.utf8)
        do {
            let result: Any = try JSONSerialization.jsonObject(with: data!, options: [])
            if let dataDic:[String: Any] = result as? [String: Any]{
                dic = dataDic
            }
        } catch {   // 如果反序列化失败，能够捕获到 json 失败的准确原因，而不会崩溃
            print(error)
        }
        return dic
    }
    
    /// 字符串转Int
    ///
    /// - Parameter string: 被转的字符串
    /// - Returns: 转出的Int类型
    class func stringToInt(string:String?)->Int{
        if let str = string{
            let nsstr = str as NSString
            return nsstr.integerValue
        }
        return 0
    }
    
    /// 判断字符串是否为空
    ///
    /// - Parameter str: 需要判断的字符串
    /// - Returns: 字符串是否为空
    class func isEmptyString(str:String?)->Bool{
        if str == nil || str?.characters.count == 0 || str == "" {
            return true
        }
        return false
    }
    
    //MARK:和推送相关
    class func postNotification(notificationName:NSNotification.Name,object:AnyObject?,userInfo:[String:Any]? = [String:Any]()){
        NotificationCenter.default.post(name:notificationName, object: object,userInfo:userInfo)
    }
    
    class func addNotification(selector:Selector,notificationName:Notification.Name){
        let center = NotificationCenter.default
        center.addObserver(self, selector: selector, name:notificationName, object: nil);
    }
    //MARK:和view相关
    
    /**
     从分割线到最后的attribute
     
     - author: zerlinda
     - date: 16-09-27 09:09:33
     
     - parameter label:          <#label description#>
     - parameter divisionStr:    <#divisionStr description#>
     - parameter attributeColor: <#attributeColor description#>
     - parameter attributeFont:  <#attributeFont description#>
     */
    
    class func setAttibuteColor(_ label:UILabel,divisionStr:String,attributeColor:UIColor=UIColor.black,attributeFont:UIFont=UIFont.systemFont(ofSize: 14)){
        let labelText  = label.text
        if labelText == nil {
            return
        }
        let range:NSRange =  (labelText! as NSString).range(of: divisionStr)
        if range.length==0 {
            return
        }
        let bracketsRange:NSRange = NSMakeRange(range.location, labelText!.characters.count-range.location)
        let attributeText = NSMutableAttributedString(string: labelText!)
        attributeText.addAttributes([NSForegroundColorAttributeName:attributeColor,NSFontAttributeName:attributeFont], range: bracketsRange)
        label.attributedText = attributeText
        label.sizeToFit()
    }
    
    /**
     divisionStr变色
     
     - author: zerlinda
     - date: 16-09-27 09:09:54
     
     - parameter label:          <#label description#>
     - parameter divisionStr:    <#divisionStr description#>
     - parameter attributeColor: <#attributeColor description#>
     - parameter attributeFont:  <#attributeFont description#>
     */
    
    class func setRangeAttibuteColor(_ label:UILabel,divisionStr:String,attributeColor:UIColor=UIColor.black,attributeFont:UIFont=UIFont.systemFont(ofSize: 14)){
        
        
        let labelText  = label.text
        let range:NSRange =  (labelText! as NSString).range(of: divisionStr)
        if range.length==0 {
            return
        }
        let bracketsRange:NSRange = NSMakeRange(range.location, divisionStr.characters.count)
        let attributeText = NSMutableAttributedString(string: labelText!)
        attributeText.addAttributes([NSForegroundColorAttributeName:attributeColor,NSFontAttributeName:attributeFont], range: bracketsRange)
        label.attributedText = attributeText
    }
    ///设置高亮
    class func setHighLightAttibuteColor(label:UILabel, startStr:String, endStr:String, attributeColor:UIColor=UIColor.red, attributeFont:UIFont=UIFont.systemFont(ofSize: 14)) {
        
        let norAttriDic = StringTool.makeAttributeDic(label.font, color: label.textColor)
        let higAttriDic = StringTool.makeAttributeDic(attributeFont, color: attributeColor)
        label.attributedText = StringTool.makeHighlightAttriText(text: label.text, prefix: startStr, suffix: endStr, norAttriDic: norAttriDic, higAttriDic: higAttriDic)
        
    }
    
    /**
     富文本加载html样式
     
     - author: zerlinda
     - date: 16-09-27 09:09:58
     
     - parameter label:          <#label description#>
     - parameter htmlStr:        <#htmlStr description#>
     - parameter divisionStr:    <#divisionStr description#>
     - parameter attributeColor: <#attributeColor description#>
     - parameter attributeFont:  <#attributeFont description#>
     */
    class func setHtmlAttibuteColor(_ label:UILabel,htmlStr:String?){
        if htmlStr == nil {
            return
        }
        do{
            let attrStr = try
                NSAttributedString(data: htmlStr!.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes:nil)
            let mArrti = NSMutableAttributedString(attributedString: attrStr)
            let range = NSMakeRange(0, mArrti.length)
            mArrti.addAttributes([
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: RGBA(51, 51, 51, 255),
                NSParagraphStyleAttributeName: {
                    let one = NSMutableParagraphStyle()
                    one.lineBreakMode = .byWordWrapping
                    one.alignment = .justified
                    return one
                }()
                ], range: range)
            
            
            label.attributedText = mArrti
            
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /// 把view画成图片
    ///
    /// - Parameter view:
    /// - Returns:
    class func imageWithUIView(view:UIView)->UIImage{
       // UIGraphicsBeginImageContext(view.bounds.size)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, view.layer.contentsScale)
        let ctx = UIGraphicsGetCurrentContext()
        view.layer.render(in: ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
}
