//
//  DataSummariseChartViews.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/4.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit
import Charts

let kDataSummariseChartSelectNotification = "kDataSummariseChartSelectNotification"

class DataSummariseMoneyValueFormatter: NSObject, IAxisValueFormatter {
    static let sharedOne = DataSummariseMoneyValueFormatter()
    let formatter = NumberFormatter()
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        formatter.numberStyle = .decimal
        if let s = formatter.string(from: NSNumber(value: value)) {
            return s
        }
        return ""
    }
}

let kDataSummariseColorsA = [
    HEX("#d52930"),
    HEX("#ffaee1"),
    HEX("#f17052"),
    HEX("#d1d977"),
    HEX("#60c3ab"),
    HEX("#6375c5"),
    HEX("#b67ae3"),
    HEX("#7ecadd"),
    HEX("#1c8cb9"),
    HEX("#53c3f1"),
]
let kDataSummariseColorsB = [
    HEX("#f16852"),
    HEX("#ebf234"),
    HEX("#ffc047"),
    HEX("#785479"),
    HEX("#f08af4"),
    HEX("#39c3e5"),
    HEX("#491fa7"),
    HEX("#3988e2"),
    HEX("#8e29b4"),
    HEX("#94fff9"),
]
let kDataSummariseColorsC = [
    HEX("#865cc6"),
    HEX("#81fff8"),
    HEX("#70c1ff"),
    HEX("#356f9b"),
    HEX("#1acac4"),
    HEX("#f7cf65"),
    HEX("#4ac489"),
    HEX("#4b3f64"),
    HEX("#ffac8b"),
    HEX("#d97ebe"),
]


//MARK: 轮次
class DataSummariseRoundChartView: UIView, IAxisValueFormatter, ChartViewDelegate {
    
    var respondSelect: ((_ entry: TinRoundSummariseChartEntry, _ point: CGPoint) -> ())?
    var respondDisSelect: (() -> ())?
    
    var colors: [UIColor] = kDataSummariseColorsA
    
    var roundChartEntries: [TinRoundSummariseChartEntry]? {
        didSet {
            
            barChartView.highlightValues(nil)
            respondDisSelect?()
            
            if let roundChartEntries = roundChartEntries {
                if roundChartEntries.count > 0 {
                    barChartView.data = generateBarData(roundEntries: roundChartEntries)
                } else {
                    barChartView.data = nil
                }
            } else {
                barChartView.data = nil
            }
        }
    }
    
    func generateBarData(roundEntries: [TinRoundSummariseChartEntry]) -> BarChartData {
        
        var entries = [BarChartDataEntry]()
        for i in 0..<roundEntries.count {
            let x = Double(i)
            let y = roundEntries[i].amount / 10000
            let entry = BarChartDataEntry(x: x, y: y)
            entries.append(entry)
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "轮次金额")
        dataSet.axisDependency = .left
        
        dataSet.colors = colors
        dataSet.valueTextColor = UIColor.clear
        dataSet.valueFont = UIFont.systemFont(ofSize: 8)
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.5
        return data
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#666666")
        one.font = UIFont.systemFont(ofSize: 12)
        one.text = "轮次(单位:亿美元)"
        one.textAlignment = .center
        return one
    }()

    lazy var barChartView: BarChartView = {
        let one = BarChartView()
        one.backgroundColor = UIColor.clear
        
        one.noDataText = "暂无数据"
        one.noDataFont = UIFont.systemFont(ofSize: 12)
        one.noDataTextColor = UIColor.lightGray
        
        one.drawBarShadowEnabled = false
        one.drawGridBackgroundEnabled = false
        one.highlightFullBarEnabled = false
        
        let descri = Charts.Description()
        descri.text = ""
        descri.font = UIFont.systemFont(ofSize: 8)
        descri.textColor = UIColor.lightGray
        one.chartDescription = descri
        
        one.legend.enabled = false

        one.leftAxis.drawGridLinesEnabled = true
        one.leftAxis.gridColor = HEX("#bfbfbf")
        one.leftAxis.gridLineWidth = 0.5
        one.leftAxis.axisMinimum = 0
        //one.leftAxis.axisMaximum = 600
        one.leftAxis.labelCount = 4
        one.leftAxis.labelTextColor = HEX("#333333")
        one.leftAxis.labelFont = UIFont.systemFont(ofSize: 9)
        one.leftAxis.valueFormatter = DataSummariseMoneyValueFormatter()
        
        one.rightAxis.enabled = false
        
        one.xAxis.drawGridLinesEnabled = false
        one.xAxis.gridColor = HEX("#bfbfbf")
        one.xAxis.gridLineWidth = 0.5
        one.xAxis.labelPosition = .bottom
        one.xAxis.granularity = 1
        one.xAxis.valueFormatter = self
        
        one.delegate = self
        
        one.scaleYEnabled = false
        one.scaleXEnabled = false
        
        one.extraTopOffset = 40
        one.extraLeftOffset = 12.5
        one.extraRightOffset = 40
        
        return one
    }()
    
    lazy var sideBtnLeft: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(DataSummariseRoundChartView.sideClick), for: .touchUpInside)
        return one
    }()
    lazy var sideBtnRight: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(DataSummariseRoundChartView.sideClick), for: .touchUpInside)
        return one
    }()
    func sideClick() {
        barChartView.highlightValues(nil)
        respondDisSelect?()
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(titleLabel)
        addSubview(barChartView)
        addSubview(sideBtnLeft)
        addSubview(sideBtnRight)
        titleLabel.IN(self).TOP(30).CENTER.HEIGHT(15).MAKE()
        barChartView.IN(self).LEFT.RIGHT.TOP(15).BOTTOM.MAKE()
        sideBtnLeft.IN(self).LEFT.TOP.BOTTOM.WIDTH(40).MAKE()
        sideBtnRight.IN(self).RIGHT.TOP.BOTTOM.WIDTH(40).MAKE()
        NotificationCenter.default.addObserver(self, selector: #selector(DataSummariseRoundChartView.selectNotification(_:)), name: NSNotification.Name(rawValue: kDataSummariseChartSelectNotification), object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func selectNotification(_ notice: Notification) {
        if !((notice.object! as AnyObject) === self) {
            barChartView.highlightValues(nil)
        }
    }
    
    //MARK: IAxisValueFormatter
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let idx = Int(value)
        let entry = roundChartEntries![idx]
        let name = TinSearch(code: entry.round, inKeys: kDataRoundShortKeys)?.name
        return SafeUnwarp(name, holderForNull: "")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let p0 = CGPoint(x: highlight.xPx, y: highlight.yPx)
        let p1 = chartView.convert(p0, to: self)
        let roundEntry = roundChartEntries![Int(entry.x)]
        respondSelect?(roundEntry, p1)
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: kDataSummariseChartSelectNotification), object: self)
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        respondDisSelect?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: 金额
class DataSummariseAmountChartView: UIView, IAxisValueFormatter, ChartViewDelegate {
    
    var respondSelect: ((_ entry: TinAmountSummariseChartEntry, _ point: CGPoint) -> ())?
    var respondDisSelect: (() -> ())?
    
    var colors: [UIColor] = kDataSummariseColorsA

    var ammountChartEntries: [TinAmountSummariseChartEntry]? {
        didSet {
            
            barChartView.highlightValues(nil)
            respondDisSelect?()
            
            if let ammountChartEntries = ammountChartEntries {
                if ammountChartEntries.count > 0 {
                    barChartView.data = generateBarData(amountEntries: ammountChartEntries)
                } else {
                    barChartView.data = nil
                }
            } else {
                barChartView.data = nil
            }
        }
    }
    
    func generateBarData(amountEntries: [TinAmountSummariseChartEntry]) -> BarChartData {
        
        var entries = [BarChartDataEntry]()
        
        var amount: Double = 0
        for amountEntry in amountEntries {
            amount = max(amountEntry.amount, amount)
        }
        if amount > 100000 {
            titleLabel.text = "金额(单位:亿美元)"
        } else {
            titleLabel.text = "金额(单位:万美元)"
        }
        for i in 0..<amountEntries.count {
            let x = Double(i)
            var y = amountEntries[i].amount
            if amount > 100000 {
                y = y / 10000
            }
            let entry = BarChartDataEntry(x: x, y: y)
            entries.append(entry)
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "机构金额")
        dataSet.axisDependency = .right
        
        dataSet.colors = colors
        dataSet.valueTextColor = UIColor.clear
        dataSet.valueFont = UIFont.systemFont(ofSize: 8)

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.5
        return data
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#666666")
        one.font = UIFont.systemFont(ofSize: 12)
        one.text = "金额(单位:万元)"
        one.textAlignment = .center
        return one
    }()
    
    lazy var barChartView: HorizontalBarChartView = {
        let one = HorizontalBarChartView()
        one.backgroundColor = UIColor.clear
        
        one.noDataText = "暂无数据"
        one.noDataFont = UIFont.systemFont(ofSize: 12)
        one.noDataTextColor = UIColor.lightGray
        
        one.drawBarShadowEnabled = false
        one.drawGridBackgroundEnabled = false
        one.highlightFullBarEnabled = false
        
        let descri = Charts.Description()
        descri.text = ""
        descri.font = UIFont.systemFont(ofSize: 8)
        descri.textColor = UIColor.lightGray
        one.chartDescription = descri
        
        one.legend.enabled = false
        
        one.rightAxis.drawGridLinesEnabled = true
        one.rightAxis.gridColor = HEX("#bfbfbf")
        one.rightAxis.gridLineWidth = 0.5
        one.rightAxis.axisMinimum = 0
        one.rightAxis.labelTextColor = HEX("#333333")
        one.rightAxis.labelFont = UIFont.systemFont(ofSize: 9)
        one.rightAxis.valueFormatter = DataSummariseMoneyValueFormatter()

        one.leftAxis.enabled = false
        
        one.xAxis.drawGridLinesEnabled = false
        one.xAxis.gridColor = HEX("#bfbfbf")
        one.xAxis.gridLineWidth = 0.5
        one.xAxis.labelPosition = .bottom
        one.xAxis.granularity = 1
        one.xAxis.valueFormatter = self
        one.xAxis.labelTextColor = HEX("#333333")
        one.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        
        one.delegate = self
        
        one.scaleYEnabled = false
        one.scaleXEnabled = false
        
        one.extraBottomOffset = 3
        one.extraTopOffset = 40
        one.extraLeftOffset = 10
        one.extraRightOffset = 40
        
        return one
    }()
    
    lazy var sideBtnLeft: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(DataSummariseAmountChartView.sideClick), for: .touchUpInside)
        return one
    }()
    lazy var sideBtnRight: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(DataSummariseAmountChartView.sideClick), for: .touchUpInside)
        return one
    }()
    func sideClick() {
        barChartView.highlightValues(nil)
        respondDisSelect?()
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(titleLabel)
        addSubview(barChartView)
        addSubview(sideBtnLeft)
        addSubview(sideBtnRight)
        titleLabel.IN(self).TOP(30).CENTER.HEIGHT(15).MAKE()
        barChartView.IN(self).LEFT.RIGHT.TOP(15).BOTTOM.MAKE()
        sideBtnLeft.IN(self).LEFT.TOP.BOTTOM.WIDTH(40).MAKE()
        sideBtnRight.IN(self).RIGHT.TOP.BOTTOM.WIDTH(40).MAKE()
        NotificationCenter.default.addObserver(self, selector: #selector(DataSummariseAmountChartView.selectNotification(_:)), name: NSNotification.Name(rawValue: kDataSummariseChartSelectNotification), object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func selectNotification(_ notice: Notification) {
        if !((notice.object! as AnyObject) === self) {
            barChartView.highlightValues(nil)
        }
    }
    
    //MARK: IAxisValueFormatter
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let idx = Int(value)
        let entry = ammountChartEntries![idx]
        let name = SafeUnwarp(entry.institution.shortName, holderForNull: "")
        return NSAttributedString(string: name, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 12)
            ]).qx_shortAttributedString(width: 65, dots: NSAttributedString(string: "...", attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12)
                ])).string
//        let _name = StringTool.short(entry.institution.shortName, toLength: 5)
//        return SafeUnwarp(_name, holderForNull: "")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let p0 = CGPoint(x: highlight.xPx, y: highlight.yPx)
        let p1 = chartView.convert(p0, to: self)
        let ammountEntry = ammountChartEntries![Int(entry.x)]
        respondSelect?(ammountEntry, p1)
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: kDataSummariseChartSelectNotification), object: self)
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        respondDisSelect?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


//MARK: 比例
class DataSummariseScaleChartView: UIView, ChartViewDelegate, IValueFormatter {
    
    var respondSelect: ((_ entry: TinIndustrySummariseChartEntry, _ point: CGPoint) -> ())?
    var respondDisSelect: (() -> ())?
    
    var colors: [UIColor] = kDataSummariseColorsA

    var totalCount: Int = 0
    
    var industryChartEntries: [TinIndustrySummariseChartEntry]? {
        didSet {
            
            pieChartView.highlightValues(nil)
            respondDisSelect?()
            
            if let industryChartEntries = industryChartEntries {
                if industryChartEntries.count > 0 {
                    totalCount = 0
                    for industryChartEntry in industryChartEntries {
                        totalCount += industryChartEntry.count
                    }
                    pieChartView.data = generatePieData(industryEntries: industryChartEntries)
                } else {
                    pieChartView.data = nil
                }
            } else {
                pieChartView.data = nil
            }
        }
    }
    
    func generatePieData(industryEntries: [TinIndustrySummariseChartEntry]) -> PieChartData {
        
        var entries = [PieChartDataEntry]()
    
        for i in 0..<industryEntries.count {
            let industryEntry = industryEntries[i]
            let value = Double(industryEntry.count)
            let name = SafeUnwarp(industryEntry.name, holderForNull: "")
            let entry = PieChartDataEntry(value: value, label: name)
            entries.append(entry)
        }
   
        let dataSet = PieChartDataSet(values: entries, label: nil)
        dataSet.colors = colors
        dataSet.valueTextColor = UIColor.clear
        dataSet.valueFont = UIFont.systemFont(ofSize: 8)
        
        dataSet.selectionShift = 10
        
        dataSet.sliceSpace = 1
        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .outsideSlice
        dataSet.valueLinePart1Length = 0.5
        dataSet.valueLinePart2Length = 0.4
        dataSet.valueLineWidth = 1
        dataSet.valueLineColor = kClrGray
        
        dataSet.valueLinePart1OffsetPercentage = 0.85
        
        dataSet.valueFormatter = self
        
        dataSet.drawValuesEnabled = true
        
        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(kClrDeepGray)
        data.setValueFont(UIFont.systemFont(ofSize: 8))
        
        return data
    }
    
    lazy var pieChartView: PieChartView = {
        let one = PieChartView()
        one.backgroundColor = UIColor.clear
        
        one.noDataText = "暂无数据"
        one.noDataFont = UIFont.systemFont(ofSize: 12)
        one.noDataTextColor = UIColor.lightGray
        one.centerAttributedText = NSAttributedString(string: "行业", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 16),
            NSForegroundColorAttributeName: kClrGray
            ])
        
        let descri = Charts.Description()
        descri.text = ""
        descri.font = UIFont.systemFont(ofSize: 8)
        descri.textColor = UIColor.lightGray
        one.chartDescription = descri
        
        one.legend.orientation = .vertical
        one.legend.horizontalAlignment = .right
        one.legend.verticalAlignment = .center
        one.legend.font = UIFont.systemFont(ofSize: 11)
        one.legend.textColor = kClrGray
        one.legend.yEntrySpace = 5
        
        one.delegate = self
        
        one.drawEntryLabelsEnabled = false
        one.usePercentValuesEnabled = false
        
        one.rotationEnabled = true
        
        one.extraRightOffset = 30
        one.extraTopOffset = 20
        one.extraLeftOffset = 20

        return one
    }()
    
    lazy var sideBtnLeft: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(DataSummariseScaleChartView.sideClick), for: .touchUpInside)
        return one
    }()
    lazy var sideBtnRight: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(DataSummariseScaleChartView.sideClick), for: .touchUpInside)
        return one
    }()
    func sideClick() {
        pieChartView.highlightValues(nil)
        respondDisSelect?()
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(pieChartView)
        addSubview(sideBtnLeft)
        addSubview(sideBtnLeft)
        addSubview(sideBtnRight)

        pieChartView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        sideBtnLeft.IN(self).LEFT.TOP.BOTTOM.WIDTH(50).MAKE()
        sideBtnRight.IN(self).RIGHT.TOP.BOTTOM.WIDTH(50).MAKE()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataSummariseScaleChartView.selectNotification(_:)), name: NSNotification.Name(rawValue: kDataSummariseChartSelectNotification), object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func selectNotification(_ notice: Notification) {
        if !((notice.object! as AnyObject) === self) {
            pieChartView.highlightValues(nil)
        }
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.1f%%", entry.y / Double(totalCount) * 100)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let p0 = CGPoint(x: highlight.xPx, y: highlight.yPx)
        let p1 = chartView.convert(p0, to: self)
        let label = SafeUnwarp((entry as! PieChartDataEntry).label, holderForNull: "")
        
        var theIndustryChartEntry: TinIndustrySummariseChartEntry?
        for industryChartEntry in industryChartEntries! {
            if industryChartEntry.name == label {
                theIndustryChartEntry = industryChartEntry
                break
            }
        }
        if let industryChartEntry = theIndustryChartEntry {
            respondSelect?(industryChartEntry, p1)
        }
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: kDataSummariseChartSelectNotification), object: self)
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        respondDisSelect?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
