//
//  InstitutionChartItem.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class InstitutionChartItem {
    
    let chart: IndustryChart
    
    let investCounts: [Int]
    let labels: [String]
    let financeAmounts: [Int]
    
    let investMaxCount: Int
    let financeMaxAmount: Int
    let xCount: Int
    
    let title: String
    
    required init(chart: IndustryChart) {
        self.chart = chart
        var labels = [String]()
        var investCounts = [Int]()
        var financeAmounts = [Int]()
        for entry in chart.entries {
            let label = SafeUnwarp(entry.xAxisLabel, holderForNull: "")
            switch chart.legend {
            case .year:
                labels.append(label)
            case .industry:
                labels.append(label)
            case .round:
                let n = (label as NSString).integerValue
                let name = TinSearch(code: n, inKeys: kDataRoundKeys)?.name
                labels.append(SafeUnwarp(name, holderForNull: ""))
            case .period:
                if label == "0" {
                    labels.append("")
                } else if label == "1" {
                    labels.append("早期")
                } else if label == "2" {
                    labels.append("发展期")
                } else if label == "3" {
                    labels.append("扩张期")
                } else if label == "4" {
                    labels.append("获利期")
                } else {
                    labels.append("")
                }
            case .unknown:
                labels.append(label)
            }
            investCounts.append(entry.yLeft)
            financeAmounts.append(entry.yRight)
        }
        self.labels = labels
        self.investCounts = investCounts
        self.financeAmounts = financeAmounts
        do {
            var _max: Int = 0
            for investCount in investCounts {
                _max = max(_max, investCount)
            }
            self.investMaxCount = Int(Float(_max) * 1.1)//  (Int(_max / 100) + 1) * 100
        }
        do {
            var _max: Int = 0
            for financeAmount in financeAmounts {
                _max = max(_max, financeAmount)
            }
            self.financeMaxAmount = Int(Float(_max) * 1.1) //(Int(_max / 50000) + 2) * 50000
        }
        do {
            var m = min(investCounts.count, labels.count)
            m = min(m, financeAmounts.count)
            self.xCount = m
        }
        switch chart.legend {
        case .year:
            title = "年度分析"
        case .industry:
            title = "行业分析"
        case .round:
            title = "轮次分析"
        case .period:
            title = "阶段分析"
        case .unknown:
            title = "其他分析"
        }
        
    }
    
    var isFirstShow: Bool = true
    
}

