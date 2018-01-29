//
//  DataSummariseChartsCell.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/4.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

enum DataSummariseChartType: Int {
    case round = 0
    case amount = 1
    case scale = 2
}

class DataSummariseChartsCell: RootTableViewCell, UIScrollViewDelegate {
    
    var respondSelectRound: ((_ entry: TinRoundSummariseChartEntry, _ point: CGPoint) -> ())?
    var respondSelectAmount: ((_ entry: TinAmountSummariseChartEntry, _ point: CGPoint) -> ())?
    var respondSelectIndustry: ((_ entry: TinIndustrySummariseChartEntry, _ point: CGPoint) -> ())?

    var respondDisSelect: (() -> ())? {
        didSet {
            roundChart.respondDisSelect = respondDisSelect
            amountChart.respondDisSelect = respondDisSelect
            scaleChart.respondDisSelect = respondDisSelect
        }
    }
    
    var ammountChartEntries: [TinAmountSummariseChartEntry]? {
        didSet {
            amountChart.ammountChartEntries = ammountChartEntries
        }
    }
    var industryChartEntries: [TinIndustrySummariseChartEntry]? {
        didSet {
            scaleChart.industryChartEntries = industryChartEntries
        }
    }
    var roundChartEntries: [TinRoundSummariseChartEntry]? {
        didSet {
            roundChart.roundChartEntries = roundChartEntries
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return DataSummariseChartsCell.chartHeight + 30 + 15  //389 / 2
    }
    
    lazy var roundChart: DataSummariseRoundChartView = {
        let one = DataSummariseRoundChartView()
        one.respondSelect = { [unowned self] entry, p in
            let _p = self.roundChart.convert(p, to: self)
            self.respondSelectRound?(entry, _p)
        }
        one.respondDisSelect = { [unowned self] in
            self.respondDisSelect?()
        }
        return one
    }()
    lazy var amountChart: DataSummariseAmountChartView = {
        let one = DataSummariseAmountChartView()
        one.respondSelect = { [unowned self] entry, p in
            let _p = self.amountChart.convert(p, to: self)
            self.respondSelectAmount?(entry, _p)
        }
        one.respondDisSelect = { [unowned self] in
            self.respondDisSelect?()
        }
        return one
    }()
    lazy var scaleChart: DataSummariseScaleChartView = {
        let one = DataSummariseScaleChartView()
        one.respondSelect = { [unowned self] entry, p in
            let _p = self.scaleChart.convert(p, to: self)
            self.respondSelectIndustry?(entry, _p)
        }
        one.respondDisSelect = { [unowned self] in
            self.respondDisSelect?()
        }
        return one
    }()
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 12)
        one.textColor = kClrDeepGray
        return one
    }()
    
    lazy var titleLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBlue
        return one
    }()
    
    lazy var emptyLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrGray
        one.text = "暂无数据"
        return one
    }()
    
    lazy var pageControl: UIPageControl = {
        let one = UIPageControl()
        one.numberOfPages = 3
        one.currentPage = 0
        one.isUserInteractionEnabled = false
        one.pageIndicatorTintColor = HEX("#bdbdbd")
        one.currentPageIndicatorTintColor = HEX("#999999")
        return one
    }()
    
    static let chartHeight: CGFloat = 200
    
    lazy var scrollView: UIScrollView = {
        let one = UIScrollView()
        one.showsVerticalScrollIndicator = false
        one.showsHorizontalScrollIndicator = false
        one.delegate = self
        one.isPagingEnabled = true
        one.bounces = false
        
        one.contentSize = CGSize(width: kScreenW * 3, height: 0)
        self.roundChart.frame = CGRect(x: 0, y: 0, width: kScreenW, height: DataSummariseChartsCell.chartHeight)
        one.addSubview(self.roundChart)
        
        self.amountChart.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: DataSummariseChartsCell.chartHeight)
        one.addSubview(self.amountChart)
        
        self.scaleChart.frame = CGRect(x: kScreenW * 2, y: 0, width: kScreenW, height: DataSummariseChartsCell.chartHeight)
        one.addSubview(self.scaleChart)
        
        return one
    }()
    
    func setupOrder(types: [DataSummariseChartType]) {
        
        /// prepare funcs
        func resetChartsFrameAndShow() {
            self.roundChart.frame = CGRect.zero
            self.amountChart.frame = CGRect.zero
            self.scaleChart.frame = CGRect.zero
            self.roundChart.isHidden = true
            self.amountChart.isHidden = true
            self.scaleChart.isHidden = true
        }
        func setChartFrameAndShow(type: DataSummariseChartType, offsetX: CGFloat) {
            switch type {
            case .round:
                self.roundChart.isHidden = false
                self.roundChart.frame = CGRect(x: offsetX, y: 0, width: kScreenW, height: DataSummariseChartsCell.chartHeight)
            case .amount:
                self.amountChart.isHidden = false
                self.amountChart.frame = CGRect(x: offsetX, y: 0, width: kScreenW, height: DataSummariseChartsCell.chartHeight)
            case .scale:
                self.scaleChart.isHidden = false
                self.scaleChart.frame = CGRect(x: offsetX, y: 0, width: kScreenW, height: DataSummariseChartsCell.chartHeight)
            }
        }
        func showEmpty(_ b: Bool) {
            emptyLabel.isHidden = !b
            pageControl.isHidden = b
        }
        
        if types.count == 0 {
            scrollView.contentSize = CGSize.zero
            resetChartsFrameAndShow()
            self.pageControl.numberOfPages = 0
            showEmpty(true)
        } else if types.count == 1 {
            showEmpty(false)
            scrollView.contentSize = CGSize(width: kScreenW, height: 0)
            self.roundChart.frame = CGRect.zero
            self.amountChart.frame = CGRect.zero
            self.scaleChart.frame = CGRect.zero
            setChartFrameAndShow(type: types[0], offsetX: 0)
            self.pageControl.numberOfPages = 1
        } else if types.count == 2 {
            showEmpty(false)
            scrollView.contentSize = CGSize(width: kScreenW * 2, height: 0)
            resetChartsFrameAndShow()
            setChartFrameAndShow(type: types[0], offsetX: 0)
            setChartFrameAndShow(type: types[1], offsetX: kScreenW)
            self.pageControl.numberOfPages = 2
        } else {
            showEmpty(false)
            scrollView.contentSize = CGSize(width: kScreenW * 3, height: 0)
            resetChartsFrameAndShow()
            setChartFrameAndShow(type: types[0], offsetX: 0)
            setChartFrameAndShow(type: types[1], offsetX: kScreenW)
            setChartFrameAndShow(type: types[2], offsetX: kScreenW * 2)
            self.pageControl.numberOfPages = 3
        }
    }
    
    required init() {
        super.init(style: .default, reuseIdentifier: "cell")
        
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        contentView.addSubview(emptyLabel)

        contentView.addSubview(titleLine)
        contentView.addSubview(titleLabel)
        titleLine.IN(contentView).LEFT.TOP(15).SIZE(2, 11).MAKE()
        titleLabel.RIGHT(titleLine).OFFSET(10).CENTER.MAKE()
        
        scrollView.IN(contentView).LEFT.RIGHT.TOP.HEIGHT(DataSummariseChartsCell.chartHeight).MAKE()
        
        pageControl.IN(contentView).BOTTOM(15).CENTER.HEIGHT(30).MAKE()
        emptyLabel.IN(contentView).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let deltaX = scrollView.contentOffset.x
        let idx = Int(deltaX / kScreenW)
        pageControl.currentPage = idx
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        roundChart.barChartView.highlightValues(nil)
        amountChart.barChartView.highlightValues(nil)
        scaleChart.pieChartView.highlightValues(nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        respondDisSelect?()
    }

}



