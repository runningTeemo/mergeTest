//
//  IndexViewHeaderView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndexViewHeaderView: UIView {
    
    /// 分栏的反馈接口
    var respondColum: ((_ item: ColumnItem) -> ())? {
        didSet {
            columsView.respondItem = respondColum
        }
    }
    
    var respondEvents: (() -> ())?
 
    lazy var bannerView: IndexViewBannerView = {
        let one = IndexViewBannerView()
        return one
    }()
    lazy var columsView: IndexViewColumnsView = {
        let one = IndexViewColumnsView()
        return one
    }()
    lazy var newsView: IndexViewNewsView = {
        let one = IndexViewNewsView()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondEvents?()
        })
        return one
    }()
    lazy var subBannerView: IndexViewSubBannerView = {
        let one = IndexViewSubBannerView()
        return one
    }()
    lazy var breakLine: UIView = NewBreakLine
    
    lazy var segmentView: SegmentControl = {
        let one = SegmentControl(titles: "推荐新闻", "研究报告", "推荐事件")
        return one
    }()
    
    var viewHeight: CGFloat {
        return bannerView.viewHeight + columsView.viewHeight + newsView.viewHeight + subBannerView.viewHeight + 50
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(bannerView)
        addSubview(columsView)
        addSubview(newsView)
        addSubview(subBannerView)
        addSubview(breakLine)
        addSubview(segmentView)
        
        var topMargin: CGFloat = 0
        bannerView.IN(self).LEFT.RIGHT.TOP(topMargin).HEIGHT(bannerView.viewHeight).MAKE()
        topMargin += bannerView.viewHeight
        columsView.IN(self).LEFT.RIGHT.TOP(topMargin).HEIGHT(columsView.viewHeight).MAKE()
        topMargin += columsView.viewHeight
        newsView.IN(self).LEFT.RIGHT.TOP(topMargin).HEIGHT(newsView.viewHeight).MAKE()
        breakLine.TOP(newsView).LEFT.RIGHT.HEIGHT(0.3).MAKE()
        topMargin += newsView.viewHeight
        subBannerView.IN(self).LEFT.RIGHT.TOP(topMargin).HEIGHT(subBannerView.viewHeight).MAKE()
        
        segmentView.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(50).MAKE()
                
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
