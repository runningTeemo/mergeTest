//
//  TitleScroll.swift
//  touzhong
//
//  Created by zerlinda on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class QXYTitleScrollView: UIScrollView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    fileprivate let tagStart = 100
    
    /// 标题数组（必须要的）
    var titles:[String]?{
        didSet{
            setTitleLabel()
        }
    }
    
    /// label的宽度，默认100
    var  labelWidth:CGFloat = 100
    
    /// label的背景颜色
    var labelBgColor:UIColor?{
        didSet{
            for label in subviews {
                label.backgroundColor = labelBgColor
            }
        }
    }
    /// label的字体大小 默认是14
    var labelFont:CGFloat? = 14{
        didSet{
            for i in 0..<subviews.count {
                let lable = subviews[i] as? QXYTitleLabel
                lable?.font = UIFont.systemFont(ofSize: labelFont!)
            }
        }
    }
    
    /// 标题lable没有被放大时候的文字颜色(默认是黑色)
    var labelSmallRGB: (R: CGFloat, G: CGFloat, B: CGFloat)? = (1,0,0){
        didSet {
            for i in 0..<subviews.count {
                let lable = subviews[i] as? QXYTitleLabel
                lable?.startColor = labelSmallRGB
            }
        }
    }
    /// 标题lable被放大时候的文字颜色(默认是绿色)
    var labelBigRGB: (R: CGFloat, G: CGFloat, B: CGFloat)? = (0,1,0){
        didSet {
            for i in 0..<subviews.count {
                let lable = subviews[i] as? QXYTitleLabel
                lable?.endColor = labelBigRGB
            }
        }
    }
    
    var labelLineColor:UIColor?{
        didSet{
            for i in 0..<subviews.count {
                let lable = subviews[i] as? QXYTitleLabel
                lable?.labelLineColor = labelLineColor
            }
        }
    }
    var line : UIView = {
        let line = UIView()
        line.backgroundColor = MyColor.colorWithHexString("#f2f2f2")
        return line
    }()
    
    /// label点击
    var titleClickIndex: ((_ index: Int) -> Void)?
    
    //MARK:方法
    /**
     创建label
     
     - author: zerlinda
     - date: 16-09-02 15:09:13
     */
    func setTitleLabel(){
        
        for i in 0..<titles!.count{
           let label = QXYTitleLabel()
            label.backgroundColor = labelBgColor
            label.text = titles![i]
            label.startColor = labelSmallRGB
            label.endColor = labelBigRGB
            label.tag = tagStart + i
            if i==0 {
                label.scale = 1
            }
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QXYTitleScrollView.lableClick)))
            addSubview(label)
        }
  
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        //self.addSubview(line)
    }
    
    func updateFrame(){
        labelWidth = frame.size.width/CGFloat(titles!.count)
        for i in 0..<titles!.count{
            let label = viewWithTag(tagStart+i)
            if let l = label {
                l.frame = CGRect(x: CGFloat(i)*labelWidth, y: 0, width: labelWidth, height: frame.size.height)
            }
        }
        let lastLable = viewWithTag(tagStart + titles!.count - 1)
        contentSize = CGSize(width: lastLable!.frame.maxX, height: 0)
        line.frame = CGRect(x: 0, y: self.frame.height-0.4, width: self.frame.width, height: 0.4)
    }
    
    
    /**
     按钮点击
     
     - author: zerlinda
     - date: 16-09-02 15:09:39
     */
    func lableClick(_ tap:UITapGestureRecognizer){
        titleClickIndex?(tap.view!.tag - tagStart)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
