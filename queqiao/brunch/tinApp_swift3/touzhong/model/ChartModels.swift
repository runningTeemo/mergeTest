//
//  ChartModels.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class TinSummariseChartLabelEntry {
    var amount: Double = 0
    var count: Int = 0
    var cnName: String?
    var shortName: String?
    var id: String?
    func update(_ dic: [String: Any]) {
        amount = SafeUnwarp(dic.nullableDouble("amount"), holderForNull: 0)
        count = SafeUnwarp(dic.nullableInt("finCount"), holderForNull: 0)
        cnName = dic.nullableString("cnName")
        shortName = dic.nullableString("shortName")
        id = dic.nullableString("id")
    }
}

enum TinSummariseInstitutionType {
    case enterPrise // 企业
    case institution // 机构
}

class TinSummariseInstitution {
    var amount: Double = 0
    var count: Int = 0
    var cnName: String?
    var shortName: String?
    var type: TinSummariseInstitutionType = .institution
    var id: Int?
    func update(_ dic: [String: Any]) {
        amount = SafeUnwarp(dic.nullableDouble("amount"), holderForNull: 0)
        count = SafeUnwarp(dic.nullableInt("finCount"), holderForNull: 0)
        cnName = dic.nullableString("cnName")
        shortName = dic.nullableString("shortName")
        id = dic.nullableInt("id")
    }
}

class TinAmountSummariseChartEntry {
    var amount: Double = 0
    var count: Int = 0
    var amountUS: Double = 0
    var institution: TinSummariseInstitution = TinSummariseInstitution()
    //var detail: TinSummariseChartDetailEntry = TinSummariseChartDetailEntry()
    func update(_ dic: [String: Any], _ type: TinSummariseInstitutionType) {
        amount = SafeUnwarp(dic.nullableDouble("amount"), holderForNull: 0)
        amountUS = SafeUnwarp(dic.nullableDouble("amountUs"), holderForNull: 0)
        count = SafeUnwarp(dic.nullableInt("finCount"), holderForNull: 0)
        if let dic = dic["inst"] as? [String: Any] {
            institution.update(dic)
            institution.type = type
        }
    }
}
class TinIndustrySummariseChartEntry: Industry {
    var amount: Double = 0
    var amountUS: Double = 0
    var count: Int = 0
    var institutions: [TinSummariseInstitution] = [TinSummariseInstitution]()
    func update(_ dic: [String: Any], _ type: TinSummariseInstitutionType) {
        id = dic.nullableString("industryId")
        name = dic.nullableString("industryName")
        amount = SafeUnwarp(dic.nullableDouble("amount"), holderForNull: 0)
        amountUS = SafeUnwarp(dic.nullableDouble("amountUs"), holderForNull: 0)
        count = SafeUnwarp(dic.nullableInt("indFreq"), holderForNull: 0)
        institutions.removeAll()
        if let arr = dic["detail"] as? [[String: Any]] {
            for dic in arr {
                let institution = TinSummariseInstitution()
                institution.update(dic)
                institution.type = type
                institutions.append(institution)
            }
        }
    }
}
class TinRoundSummariseChartEntry {
    var amount: Double = 0
    var amountUS: Double = 0
    var count: Int = 0
    var round: Int?
    var institutions: [TinSummariseInstitution] = [TinSummariseInstitution]()
    func update(_ dic: [String: Any], _ type: TinSummariseInstitutionType) {
        amount = SafeUnwarp(dic.nullableDouble("amount"), holderForNull: 0)
        amountUS = SafeUnwarp(dic.nullableDouble("amountUs"), holderForNull: 0)
        count = SafeUnwarp(dic.nullableInt("finCount"), holderForNull: 0)
        round = dic.nullableInt("round")
        institutions.removeAll()
        if let arr = dic["detail"] as? [[String: Any]] {
            for dic in arr {
                let institution = TinSummariseInstitution()
                institution.update(dic)
                institution.type = type
                institutions.append(institution)
            }
        }
    }
}

class TinDataSummarise {
    
    var hotEnterpises: [TinSummariseInstitution] = [TinSummariseInstitution]()
    var hotInstitutions: [TinSummariseInstitution] = [TinSummariseInstitution]()

    var financeAmmountChartEntries = [TinAmountSummariseChartEntry]()
    var financeIndustryChartEntries = [TinIndustrySummariseChartEntry]()
    var financeRoundChartEntries = [TinRoundSummariseChartEntry]()

    var mergeAmmountChartEntries = [TinAmountSummariseChartEntry]()
    var mergeIndustryChartEntries = [TinIndustrySummariseChartEntry]()
    
    var exitAmmountChartEntries = [TinAmountSummariseChartEntry]()
    var exitIndustryChartEntries = [TinIndustrySummariseChartEntry]()
    
    func update(_ dic: [String: Any]) {
        
        hotEnterpises.removeAll()
        if let arr = dic["hotEnt"] as? [[String: Any]] {
            for dic in arr {
                let institution = TinSummariseInstitution()
                institution.update(dic)
                institution.type = .enterPrise
                hotEnterpises.append(institution)
            }
        }
        hotInstitutions.removeAll()
        if let arr = dic["hotInst"] as? [[String: Any]] {
            for dic in arr {
                let institution = TinSummariseInstitution()
                institution.update(dic)
                institution.type = .institution
                hotInstitutions.append(institution)
            }
        }
        
        financeAmmountChartEntries.removeAll()
        if let arr = dic["finAmount"] as? [[String: Any]] {
            for dic in arr {
                let entry = TinAmountSummariseChartEntry()
                entry.update(dic, .institution)
                financeAmmountChartEntries.append(entry)
            }
        }
        financeIndustryChartEntries.removeAll()
        if let arr = dic["finIndustry"] as? [[String: Any]] {
            for dic in arr {
                let entry = TinIndustrySummariseChartEntry()
                entry.update(dic, .institution)
                financeIndustryChartEntries.append(entry)
            }
        }
        financeRoundChartEntries.removeAll()
        if let arr = dic["finRound"] as? [[String: Any]] {
            for dic in arr {
                let entry = TinRoundSummariseChartEntry()
                entry.update(dic, .institution)
                financeRoundChartEntries.append(entry)
            }
        }
        
        mergeAmmountChartEntries.removeAll()
        if let arr = dic["mergerAmount"] as? [[String: Any]] {
            for dic in arr {
                let entry = TinAmountSummariseChartEntry()
                entry.update(dic, .enterPrise)
                mergeAmmountChartEntries.append(entry)
            }
        }
        mergeIndustryChartEntries.removeAll()
        if let arr = dic["mergerIndustry"] as? [[String: Any]] {
            for dic in arr {
                let entry = TinIndustrySummariseChartEntry()
                entry.update(dic, .enterPrise)
                mergeIndustryChartEntries.append(entry)
            }
        }
        
        exitAmmountChartEntries.removeAll()
        if let arr = dic["exitAmount"] as? [[String: Any]] {
            for dic in arr {
                let entry = TinAmountSummariseChartEntry()
                entry.update(dic, .institution)
                exitAmmountChartEntries.append(entry)
            }
        }
        exitIndustryChartEntries.removeAll()
        if let arr = dic["exitIndustry"] as? [[String: Any]] {
            for dic in arr {
                let entry = TinIndustrySummariseChartEntry()
                entry.update(dic, .institution)
                exitIndustryChartEntries.append(entry)
            }
        }
        
    }
    
}


//MARK: - 机构分析

class TinBarLineChartEntry {
    var id: String?
    var yLeft: Int = 0
    var yRight: Int = 0
    var xAxisLabel: String?
    var xAxisId: String?
    func update(dic: [String: Any]) {
        id = dic.nullableString("id")
        yLeft = SafeUnwarp(dic.nullableInt("yLeft"), holderForNull: 0)
        yRight = SafeUnwarp(dic.nullableInt("yRight"), holderForNull: 0)
        xAxisLabel = dic.nullableString("xAxis")
        xAxisId = dic.nullableString("xAxisId")
    }
}

enum IndustryChartType: String {
    case year = "year"
    case industry = "industry"
    case round = "round"
    case period = "period"
    case unknown = "unknown"
}

class IndustryChartEntry: TinBarLineChartEntry {
    var legend: IndustryChartType = .unknown
    override func update(dic: [String : Any]) {
        super.update(dic: dic)
        if let t = dic.nullableString("legend") {
            if let t = IndustryChartType(rawValue: t) {
                legend = t
            } else {
                legend = .unknown
            }
        }
    }
}

class IndustryChart {
    var legend: IndustryChartType = .unknown
    var entries: [IndustryChartEntry] = [IndustryChartEntry]()
    func update(key: String?, arr: [[String: Any]]) {
        if let t = key {
            if let t = IndustryChartType(rawValue: t) {
                legend = t
            } else {
                legend = .unknown
            }
        }
        var entries = [IndustryChartEntry]()
        for dic in arr {
            let entry = IndustryChartEntry()
            entry.update(dic: dic)
            entries.append(entry)
        }
        self.entries = entries
    }
}

