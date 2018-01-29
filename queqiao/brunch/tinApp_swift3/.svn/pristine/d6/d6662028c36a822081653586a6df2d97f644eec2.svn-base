//
//  StaticCellTools.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/24.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class StaticCellTools {
    
    class func textToPercentage(origenText: String?) -> String {
        if NullText(origenText) {
            return ""
        }
        var text = ""
        var findADot: Bool = false
        var firstNot0: Bool = false
        for c in origenText!.characters {
            let t = "\(c)"
            if "1234567890.".contains(t) {
                if t != "0" && !firstNot0 {
                    firstNot0 = true
                }
                if firstNot0 {
                    if !findADot || t != "." {
                        text += t
                    }
                    if t == "." {
                        findADot = true
                    }
                }
            }
        }
        if text == "." {
            text = "0."
        } else {
            let texts = text.components(separatedBy: ".")
            if texts.count >= 2 {
                var t0 = texts[0]
                var t1 = texts[1]
                if t0.characters.count == 0 {
                    t0 = "0"
                    if t1.characters.count > 3 {
                        t1 = t1.substring(to: t1.index(t1.startIndex, offsetBy: 3))
                    }
                } else if t0.characters.count > 2  {
                    t0 = "100"
                    t1 = ""
                } else {
                    if t1.characters.count > 3 {
                        t1 = t1.substring(to: t1.index(t1.startIndex, offsetBy: 3))
                    }
                }
                text = ""
                text += t0
                text += "."
                text += t1
            } else if texts.count == 1 {
                var t0 = texts[0]
                if t0.characters.count == 0 {
                    t0 = "0"
                } else if t0.characters.count > 2  {
                    t0 = "100"
                }
                text = t0
            } else {
                text = ""
            }
        }
        text += ""
        return text
    }
    
    class func textToPercentageFreeLimit(origenText: String?) -> String {
        if NullText(origenText) {
            return ""
        }
        var text = ""
        var findADot: Bool = false
        var firstNot0: Bool = false
        for c in origenText!.characters {
            let t = "\(c)"
            if "1234567890.".contains(t) {
                if t != "0" && !firstNot0 {
                    firstNot0 = true
                }
                if firstNot0 {
                    if !findADot || t != "." {
                        text += t
                    }
                    if t == "." {
                        findADot = true
                    }
                }
            }
        }
        if text == "." {
            text = "0."
        } else {
            let texts = text.components(separatedBy: ".")
            if texts.count >= 2 {
                let t0 = texts[0]
                var t1 = texts[1]
                if t1.characters.count > 3 {
                    t1 = t1.substring(to: t1.index(t1.startIndex, offsetBy: 3))
                }
                text = ""
                text += t0
                text += "."
                text += t1
            } else if texts.count == 1 {
                let t0 = texts[0]
                text = t0
            } else {
                text = ""
            }
        }
        return text
    }
    
    class func numberToDecNumber(number: Double?) -> String {
        if number == nil {
            return "0"
        }
        let number = NSNumber(value: number!)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var text = ""
        if let t = formatter.string(from: number) {
            text = t
        }
        return text
    }
    
    class func textToDecNumber(origenText: String?) -> String {
        let n = textToNumber(origenText: origenText)
        let number = NSNumber(value: n)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var text = ""
        if let t = formatter.string(from: number) {
            text = t
        }
        return text
    }
    
    class func textToNumber(origenText: String?) -> Int64 {
        if NullText(origenText) {
            return 0
        }
        var text = ""
        var firstNot0: Bool = false
        for c in origenText!.characters {
            let t = "\(c)"
            if "1234567890".contains(t) {
                if t != "0" && !firstNot0 {
                    firstNot0 = true
                }
                if firstNot0 {
                    text += t
                }
            }
        }
        return (text as NSString).longLongValue
    }
    
    class func textToNatureMoney(origenText: String?) -> String {
        let d = Double(textToNumber(origenText: origenText))
        return doubleToNatureMoney(n: d)
    }
    
    class func doubleToNatureMoney(n: Double) -> String {
        var text = ""
        if n < 10000 {
            text = doubleToCutZero(n: n)
        } else if n < 100000000 {
            text = doubleToCutZero(n: n / 10000)
            text += "万"
        } else {
            text = doubleToCutZero(n: n / 100000000)
            text += "亿"
        }
        return text
    }
    
    class func doubleToCutZero(n: Double) -> String {
        var text = String(format: "%.2f", n)
        let texts = text.components(separatedBy: ".")
        if texts.count >= 2 {
            let t0 = texts[0]
            var t1 = texts[1]
            if t1.characters.count >= 2 {
                if t1.substring(from: t1.index(before: t1.endIndex)) == "0" {
                    t1 = t1.substring(to: t1.index(before: t1.endIndex))
                }
            }
            if t1.characters.count >= 1 {
                if t1.substring(from: t1.index(before: t1.endIndex)) == "0" {
                    t1 = t1.substring(to: t1.index(before: t1.endIndex))
                }
            }
            text = t0
            if t1.characters.count > 0 {
                text += "."
                text += t1
            }
        } else {
            text = texts[0]
        }
        return text
    }
    
    
}
