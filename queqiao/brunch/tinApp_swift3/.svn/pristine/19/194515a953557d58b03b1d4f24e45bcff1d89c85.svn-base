//
//  InstitutionChartCell.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
import Charts

class InstitutionChartMoneyValueFormatter: NSObject, IAxisValueFormatter {
    static let sharedOne = InstitutionChartMoneyValueFormatter()
    let formatter = NumberFormatter()
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        formatter.numberStyle = .decimal
        if let s = formatter.string(from: NSNumber(value: value)) {
            return s
        }
        return ""
    }
}

class InstitutionChartMarker: MarkerView {
    
    var item: InstitutionChartItem?
    
    lazy var label: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 9)
        one.textColor = UIColor.white
        one.numberOfLines = 0
        one.textAlignment = .left
        return one
    }()
    lazy var labelBack: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#696969")
        one.layer.cornerRadius = 2
        one.clipsToBounds = true
        return one
    }()
    
    lazy var arrow: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconTZSJ")
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(labelBack)
        labelBack.addSubview(label)
        addSubview(arrow)
        backgroundColor = UIColor.blue
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
        if let item = item {
            
            var title = ""
            switch item.chart.legend {
            case .industry:
                title = "行业"
            case .period:
                title = "阶段"
            case .round:
                title = "轮次"
            case .year:
                title = "年份"
            case .unknown:
                title = "标签"
            }
            
            let idx = Int(entry.x)
            
            var text = ""
            let mAttri = NSMutableAttributedString()
            let norDic = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 9),
                NSForegroundColorAttributeName: UIColor.lightGray
            ]
            let higDic = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 9),
                NSForegroundColorAttributeName: UIColor.white
            ]
            text = ""
            text += title + "：" + item.labels[idx]
            text += "\n"
            mAttri.append(NSAttributedString(string: text, attributes: norDic))
            
            if entry.isKind(of: BarChartDataEntry.self) {
                text = ""
                text += "次数：" + "\(item.investCounts[idx]) 次"
                text += "\n"
                mAttri.append(NSAttributedString(string: text, attributes: higDic))
                
                text = ""
                text += "金额："
                let c = item.financeAmounts[idx]
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                if let s = formatter.string(from: NSNumber(value: c)) {
                    text += "\(s) 万美元"
                } else {
                    text += "0 万美元"
                }
                mAttri.append(NSAttributedString(string: text, attributes: norDic))
                
            } else {
                text = ""
                text += "次数：" + "\(item.investCounts[idx]) 次"
                text += "\n"
                mAttri.append(NSAttributedString(string: text, attributes: norDic))
                
                text = ""
                text += "金额："
                let c = item.financeAmounts[idx]
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                if let s = formatter.string(from: NSNumber(value: c)) {
                    text += "\(s) 万美元"
                } else {
                    text += "0 万美元"
                }
                mAttri.append(NSAttributedString(string: text, attributes: higDic))
            }
            
            let size = mAttri.boundingRect(with: CGSize(width: 9999, height: 9999), options: .usesLineFragmentOrigin, context: nil).size
            let w = max(size.width, 60) + 10 * 2
            let h = max(size.height, 10) + 5 * 2
            label.attributedText = mAttri
            labelBack.frame = CGRect(x: -w / 2, y: -h - 5, width: w, height: h)
            arrow.frame = CGRect(x: labelBack.frame.midX - 5, y: labelBack.frame.maxY - 1, width: 10, height: 5)
            label.frame = CGRect(x: 10, y: 0, width: w - 10 * 2, height: h)
            
        }
        super.refreshContent(entry: entry, highlight: highlight)
    }
    
}

class InstitutionChartCell: RootTableViewCell, IAxisValueFormatter, ChartViewDelegate  {
    
    var item: InstitutionChartItem! {
        didSet {
            
            chartView.leftAxis.axisMaximum = Double(item.investMaxCount)
            chartView.rightAxis.axisMaximum = Double(item.financeMaxAmount)
            
            chartView.xAxis.axisMinimum = -0.5
            chartView.xAxis.axisMaximum = Double(item.xCount) - 0.5
            
            chartView.clear()
            let data = CombinedChartData()
            data.barData = generateBarData(item: item)
            data.lineData = generateLineData(item: item)
            chartView.data = data
            
            if item.isFirstShow {
                chartView.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeInCubic)
                item.isFirstShow = false
                if item.chart.legend == .year {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                        let p = CGPoint(x: kScreenW - 12.5 * 2 - 10, y: 0)
                        if let h = self?.chartView.getHighlightByTouchPoint(p) {
                            self?.chartView.highlightValue(h, callDelegate: true)
                        }
                    }
                }
            }
            
            titleLabel.text = item.title
            
            (chartView.marker as? InstitutionChartMarker)?.item = item
            
        }
    }
    override class func cellHeight() -> CGFloat {
        return kChartH + 20 * 2 + 20
    }
    
    static let kChartW = UIScreen.main.bounds.size.width - 12.5 * 2
    static let kChartH = (UIScreen.main.bounds.size.width - 12.5 * 2) * 4 / 5
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let idx = Int(value) % item.xCount
        return item.labels[idx]
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }
    
    lazy var chartView: CombinedChartView = {
        let one = CombinedChartView()
        one.backgroundColor = UIColor.clear
        
        one.noDataText = "暂无数据"
        one.noDataFont = UIFont.systemFont(ofSize: 20)
        one.noDataTextColor = UIColor.lightGray
        
        one.drawBarShadowEnabled = false
        one.drawGridBackgroundEnabled = false
        one.highlightFullBarEnabled = false
        
        let descri = Charts.Description()
        descri.text = ""
        descri.font = UIFont.systemFont(ofSize: 8)
        descri.textColor = UIColor.lightGray
        one.chartDescription = descri
        
        one.legend.xOffset = 9999
        one.legend.wordWrapEnabled = true
        one.legend.horizontalAlignment = .left
        one.legend.verticalAlignment = .bottom
        
        one.leftAxis.drawGridLinesEnabled = true
        one.leftAxis.gridColor = HEX("#bfbfbf")
        one.leftAxis.gridLineWidth = 0.5
        one.leftAxis.axisMinimum = 0
        one.leftAxis.axisMaximum = 600
        one.leftAxis.labelCount = 7
        one.leftAxis.labelTextColor = HEX("#333333")
        one.leftAxis.labelFont = UIFont.systemFont(ofSize: 9)
        
        one.rightAxis.drawGridLinesEnabled = false
        one.rightAxis.axisMinimum = 0
        one.rightAxis.axisMaximum = 350000
        one.rightAxis.labelCount = 7
        one.rightAxis.labelTextColor = HEX("#333333")
        one.rightAxis.labelFont = UIFont.systemFont(ofSize: 9)
        one.rightAxis.valueFormatter = InstitutionChartMoneyValueFormatter.sharedOne
        
        one.xAxis.drawGridLinesEnabled = false
        one.xAxis.gridColor = HEX("#bfbfbf")
        one.xAxis.gridLineWidth = 0.5
        one.xAxis.labelPosition = .bottom
        one.xAxis.granularity = 1
        one.xAxis.valueFormatter = self
        
        one.delegate = self
        one.marker = InstitutionChartMarker()
        
        one.scaleYEnabled = false
        one.scaleXEnabled = true
        
        return one
    }()
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#333333")
        one.font = UIFont.systemFont(ofSize: 12)
        one.text = "阶段分析"
        one.textAlignment = .center
        return one
    }()
    
    lazy var countLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#666666")
        one.font = UIFont.systemFont(ofSize: 9)
        one.text = "投资次数"
        one.textAlignment = .left
        return one
    }()
    
    lazy var financeLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#666666")
        one.font = UIFont.systemFont(ofSize: 9)
        one.text = "金额（万美元）"
        one.textAlignment = .right
        return one
    }()
    
    lazy var countIcon: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconTZCS")
        return one
    }()
    lazy var financeIcon: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconTZJE")
        return one
    }()
    lazy var countTipLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#666666")
        one.font = UIFont.systemFont(ofSize: 9)
        one.text = "投资次数"
        one.textAlignment = .left
        return one
    }()
    lazy var financeTipLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#666666")
        one.font = UIFont.systemFont(ofSize: 9)
        one.text = "投资金额"
        one.textAlignment = .left
        return one
    }()
    
    lazy var sideBtnLeft: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(InstitutionChartCell.sideClick), for: .touchUpInside)
        return one
    }()
    lazy var sideBtnRight: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(InstitutionChartCell.sideClick), for: .touchUpInside)
        return one
    }()
    
    func sideClick() {
        chartView.highlightValues(nil)
    }
    
    required init() {
        super.init(style: .default, reuseIdentifier: "")
        
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(financeLabel)
        contentView.addSubview(countIcon)
        contentView.addSubview(countTipLabel)
        contentView.addSubview(financeIcon)
        contentView.addSubview(financeTipLabel)
        
        contentView.addSubview(chartView)

        contentView.addSubview(sideBtnLeft)
        contentView.addSubview(sideBtnRight)
        
        titleLabel.IN(contentView).TOP(20).CENTER.MAKE()
        countLabel.IN(contentView).LEFT(12.5).TOP(25).MAKE()
        financeLabel.IN(contentView).RIGHT(12.5).TOP(25).MAKE()
        
        chartView.extraLeftOffset = 12.5
        chartView.extraRightOffset = 12.5
        chartView.extraTopOffset = 20 + 20
        chartView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM(20).MAKE()
        
        countIcon.IN(contentView).LEFT(12.5 + 25).BOTTOM(12.5 + 10).SIZE(10, 10).MAKE()
        countTipLabel.RIGHT(countIcon).OFFSET(8).CENTER.MAKE()
        
        financeIcon.RIGHT(countTipLabel).OFFSET(20).CENTER.MAKE()
        financeTipLabel.RIGHT(financeIcon).OFFSET(8).CENTER.MAKE()
        
        sideBtnLeft.IN(contentView).LEFT.TOP.BOTTOM.WIDTH(35).MAKE()
        sideBtnRight.IN(contentView).RIGHT.TOP.BOTTOM.WIDTH(35).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateBarData(item: InstitutionChartItem) -> BarChartData {
        
        var entries = [BarChartDataEntry]()
        
        for i in 0..<item.xCount {
            let x = Double(i)
            let y = Double(item.investCounts[i])
            let entry = BarChartDataEntry(x: x, y: y)
            entries.append(entry)
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "投资次数")
        dataSet.axisDependency = .left
        dataSet.colors = [HEX("#d61f26")]
        dataSet.valueTextColor = UIColor.clear
        dataSet.valueFont = UIFont.systemFont(ofSize: 8)
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.5
        return data
    }
    
    func generateLineData(item: InstitutionChartItem) -> LineChartData {
        
        var entries = [ChartDataEntry]()
        
        for i in 0..<item.xCount {
            let x = Double(i)
            let y = Double(item.financeAmounts[i])
            let entry = ChartDataEntry(x: x, y: y)
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(values: entries, label: "投资金额")
        dataSet.axisDependency = .right
        dataSet.colors = [HEX("#3ae6f1")]
        dataSet.circleRadius = 3
        dataSet.circleHoleRadius = 0
        dataSet.circleColors = [HEX("#3ae6f1")]
        dataSet.circleHoleColor = HEX("#3ae6f1")
        dataSet.lineCapType = .round
        dataSet.lineWidth = 1.5
        dataSet.valueTextColor = UIColor.clear
        dataSet.valueFont = UIFont.systemFont(ofSize: 8)
        return LineChartData(dataSet: dataSet)
    }
    
}
