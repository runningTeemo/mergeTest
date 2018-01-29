//
//  QxyHomeView.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class QxyHomeView: UIView{

    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    lazy var contentScrollV:QXYContentScrollView = {
        let contentS = QXYContentScrollView()
        contentS.delegate = self
        contentS.tag = 1000
        return contentS
    }()
    
    lazy var topScrollV:QXYTitleScrollView = {
        let topScroll = QXYTitleScrollView()
        topScroll.tag = 2000
        return topScroll
    }()
    var titles:[String]?{
        didSet{
            topScrollV.titles = titles
        }
    }
    var viewArr:[UIViewController]? = [UIViewController](){
        didSet{
            contentScrollV.viewArr = viewArr
        }
    }
    /// 标题lable没有被放大时候的文字颜色(默认是黑色)
    var topSmallRGB: (R: CGFloat, G: CGFloat, B: CGFloat)? = (1,0,0){
        didSet {
            topScrollV.labelSmallRGB = topSmallRGB
        }
    }
    /// 标题lable被放大时候的文字颜色(默认是绿色)
    var topBigRGB: (R: CGFloat, G: CGFloat, B: CGFloat)? = (0,1,0){
        didSet {
            topScrollV.labelBigRGB = topBigRGB
        }
    }
    var toplabelLineColor:UIColor?{
        didSet{
            topScrollV.labelLineColor = toplabelLineColor
        }
    }
    var titleClickIndex:((_ index:Int)->())?
    
    var tagStart = 100
    
    
    var topLabelWidth:CGFloat = 100
    
    var selectIndex:Int = 0 {
        didSet{
            //           scrollViewDidEndScrollingAnimation(contentScrollV)
            //           scrollViewDidScroll(contentScrollV)
            //           selectTopBtn(selectIndex)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(UIScrollView())
        addSubview(contentScrollV)
        addSubview(topScrollV)
    }
    func updateFrame(){
        self.topScrollV.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        self.topScrollV.updateFrame()
        topScrollV.labelWidth = topLabelWidth
        weak var ws = self
        topScrollV.titleClickIndex = { (index) -> Void in
            ws?.selectTopBtn(index)
        }
        self.contentScrollV.frame = CGRect(x: 0, y: topScrollV.frame.maxY, width: self.frame.width, height: self.frame.height - topScrollV.frame.maxY)
        self.contentScrollV.contentSize = CGSize(width: self.frame.width*CGFloat((viewArr?.count)!), height: 0)
    }
    
    func selectTopBtn(_ index:Int){
        let offsetX = self.bounds.size.width * CGFloat(index)
        self.contentScrollV.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollViewDidEndScrollingAnimation(contentScrollV)
        scrollViewDidScroll(contentScrollV)
        selectTopBtn(selectIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension QxyHomeView: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        let scrollH = scrollView.frame.size.height
        let index: Int = Int(offset.x / self.frame.size.width)
        let vc = viewArr![index]
        vc.view.frame = CGRect(x: CGFloat(index) * self.frame.size.width, y: 0, width: self.frame.size.width, height: scrollH)
        contentScrollV.addSubview(vc.view)
        /*********************************/
        if topScrollV.contentSize.width<=0 {
            return
        }
        let subView = topScrollV.subviews[index]
        offset.x = subView.center.x - self.frame.size.width * 0.5
        if offset.x <= 0 {
            offset.x = 0
        }
        if offset.x >= topScrollV.contentSize.width - self.frame.size.width - topScrollV.labelWidth * 0.5 {
            offset.x = topScrollV.contentSize.width - self.frame.size.width
        }
        topScrollV.setContentOffset(offset, animated: true)
        for lable: QXYTitleLabel in (topScrollV.subviews as? [QXYTitleLabel])! {
            if lable != subView {
                lable.scale = 0
            }
        }
        titleClickIndex?(index)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.frame.size.width==0 {
            return
        }
        let index = Int(scrollView.contentOffset.x / self.frame.size.width)
        let scale = scrollView.contentOffset.x / self.frame.size.width - CGFloat(index)
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width {
            return
        }
        let leftLable = topScrollV.viewWithTag(tagStart + index) as! QXYTitleLabel
        leftLable.scale = 1 - scale
        if index >= viewArr!.count - 1 {
            return
        }
        let rightLable = topScrollV.viewWithTag(tagStart + index + 1) as! QXYTitleLabel
        rightLable.scale = scale
    }


}
