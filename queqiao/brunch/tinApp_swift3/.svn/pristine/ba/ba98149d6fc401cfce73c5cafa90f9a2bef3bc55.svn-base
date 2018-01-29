//
//  StringTool.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

typealias SizeAttriString = (size: CGSize, attriStr: NSAttributedString?)

struct StringTool {
    
    static func short(_ text: String?, toLength: UInt) -> String? {
        if let text = text {
            
            if toLength > 0 {
                if text.characters.count <= Int(toLength) {
                    return text
                } else {
                    let idx = text.index(text.startIndex, offsetBy: Int(toLength) - 1)
                    return text.substring(to: idx) + "..."
                }
            } else {
                return ""
            }
        }
        return nil
    }
    
    static func fitFontSize(_ text: String?, fontSize: CGFloat, toMeetWidth: CGFloat) -> CGFloat? {
        if let text = text {
            var _fontSize: CGFloat = fontSize
            let tSize = size(text, font: UIFont.systemFont(ofSize: _fontSize)).size
            
            if tSize.width <= toMeetWidth {
                return fontSize
            } else {
                _fontSize -= 1
                while size(text, font: UIFont.systemFont(ofSize: _fontSize)).size.width > toMeetWidth && _fontSize != 0 {
                    _fontSize -= 1
                }
                return _fontSize
            }
        }
        return nil
    }
    
    static func makeAttributeDic(_ font: UIFont?, color: UIColor?) -> [String: AnyObject] {
        var dic = [String: AnyObject]()
        if let font = font {
            dic[NSFontAttributeName] = font
        }
        if let color = color {
            dic[NSForegroundColorAttributeName] = color
        }
        return dic
    }
    
    static func makeAttributeString(_ text: String?, dic: [String: AnyObject]?) -> NSAttributedString? {
        if let text = text {
            return NSAttributedString(string: text, attributes: dic)
        }
        return nil
    }

    static func size(_ text: String?, font: UIFont?, maxWidth: CGFloat) -> SizeAttriString {
        let attriDic = makeAttributeDic(font, color: nil)
        return size(text, attriDic: attriDic, maxWidth: maxWidth)
    }
    
    static func size(_ text: String?, font: UIFont?) -> SizeAttriString {
        return size(text, font: font, maxWidth: CGFloat.greatestFiniteMagnitude)
    }
    
    static func size(_ text: String?, attriDic: [String: AnyObject]?) -> SizeAttriString {
        return size(text, attriDic: attriDic, maxWidth: CGFloat.greatestFiniteMagnitude)
    }
    
    static func size(_ text: String?, attriDic: [String: AnyObject]?, maxWidth: CGFloat) -> SizeAttriString {
        if let attriDic = attriDic {
            if let attiStr = makeAttributeString(text, dic: attriDic) {
                let size = attiStr.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
                return (size, attiStr)
            }
        }
        return (CGSize.zero, nil)
    }
    
    static func size(_ attriStr: NSAttributedString?) -> CGSize {
        return size(attriStr, maxWidth: CGFloat.greatestFiniteMagnitude)
    }
    
    static func size(_ attriStr: NSAttributedString?, maxWidth: CGFloat) -> CGSize {
        if let attriStr = attriStr {
            return attriStr.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
        } else {
            return CGSize.zero
        }
    }
    
    static func appendAverageLinesStyle(_ attriDic: [String: AnyObject]?) -> [String: AnyObject]? {
        if let attriDic = attriDic {
            var newDic = attriDic;
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = .byWordWrapping
            style.alignment = .justified
            newDic[NSParagraphStyleAttributeName] = style
            return newDic
        }
        return nil
    }
    
    static func makeHighlightAttriText(text: String?, prefix: String, suffix: String, norAttriDic: [String: AnyObject], higAttriDic: [String: AnyObject]) -> NSAttributedString? {
        if let text = text {
            if text.characters.count > 0 {
                let mArriStri = NSMutableAttributedString()
                
                var remainStri: NSString = text as NSString
                
                var prefixMode: Bool = true
                
                while remainStri.length > 0 {
                    if prefixMode {
                        let range = remainStri.range(of: prefix)
                        if range.length > 0 {
                            if range.location > 0 {
                                let foreText = remainStri.substring(to: range.location)
                                if let attri = makeAttributeString(foreText, dic: norAttriDic) {
                                    mArriStri.append(attri)
                                }
                            }
                            remainStri = remainStri.substring(from: range.location + range.length) as NSString
                            prefixMode = false
                        } else {
                            if let attri = makeAttributeString(remainStri as String, dic: norAttriDic) {
                                mArriStri.append(attri)
                            }
                            remainStri = ""
                        }
                        
                    } else {
                        let range = remainStri.range(of: suffix)
                        if range.length > 0 {
                            if range.location > 0 {
                                let foreText = remainStri.substring(to: range.location)
                                if let attri = makeAttributeString(foreText, dic: higAttriDic) {
                                    mArriStri.append(attri)
                                }
                            }
                            remainStri = remainStri.substring(from: range.location + range.length) as NSString
                        } else {
                            if let attri = makeAttributeString(remainStri as String, dic: norAttriDic) {
                                mArriStri.append(attri)
                            }
                            remainStri = ""
                        }
                        prefixMode = true
                    }
                    
                }
                
                return mArriStri
            }
        }
        return nil
    }
    
    
}



