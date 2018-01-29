//
//  DataSummariseContentViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/4.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class DataSummariseContentFirstViewController: DataSummariseContentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(true)
        viewDidAppear(true)
    }
}

class DataSummariseContentViewController: RootTableViewController {
    
    /// 是否是第一个界面
    var isFrist: Bool = false
    var summarise: TinDataSummarise? {
        didSet {
            if let summarise = summarise {
                
                hotView.summarise = summarise
                
                var investChartTypes = [DataSummariseChartType]()
                if summarise.financeRoundChartEntries.count > 0 {
                    investChartTypes.append(.round)
                    investCell.roundChartEntries = summarise.financeRoundChartEntries
                }
                if summarise.financeAmmountChartEntries.count > 0 {
                    investChartTypes.append(.amount)
                    investCell.ammountChartEntries = summarise.financeAmmountChartEntries
                }
                if summarise.financeIndustryChartEntries.count > 0 {
                    investChartTypes.append(.scale)
                    investCell.industryChartEntries = summarise.financeIndustryChartEntries
                }
                investCell.setupOrder(types: investChartTypes)
                
                var mergeChartTypes = [DataSummariseChartType]()
                if summarise.mergeIndustryChartEntries.count > 0 {
                    mergeChartTypes.append(.scale)
                    mergeCell.industryChartEntries = summarise.mergeIndustryChartEntries
                }
                if summarise.mergeAmmountChartEntries.count > 0 {
                    mergeChartTypes.append(.amount)
                    mergeCell.ammountChartEntries = summarise.mergeAmmountChartEntries
                }
                mergeCell.setupOrder(types: mergeChartTypes)
                
                var exitChartTypes = [DataSummariseChartType]()
                if summarise.exitAmmountChartEntries.count > 0 {
                    exitChartTypes.append(.amount)
                    exitCell.ammountChartEntries = summarise.exitAmmountChartEntries
                }
                if summarise.exitIndustryChartEntries.count > 0 {
                    exitChartTypes.append(.scale)
                    exitCell.industryChartEntries = summarise.exitIndustryChartEntries
                }
                exitCell.setupOrder(types: exitChartTypes)
                
            }
        }
    }
    
    lazy var hotView: DataSummariseHotView = {
        let one = DataSummariseHotView()
        one.frame = CGRect(x: 0, y: 0, width: 0, height: DataSummariseHotView.viewHeight)
        one.respondInstitution = { [unowned self] institution in
            if institution.type == .institution {
                let vc = InstitutionDetailViewController()
                vc.id = "\(SafeUnwarp(institution.id, holderForNull: 0))"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc = EnterpriseDetailViewController()
                vc.id = "\(SafeUnwarp(institution.id, holderForNull: 0))"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return one
    }()
    
    lazy var investCell: DataSummariseChartsCell = {
        let one = DataSummariseChartsCell()
        one.titleLabel.text = "融资"
        
        one.roundChart.colors = [HEX("#6375c5")]
        one.amountChart.colors = [HEX("#d61f26")]
        one.scaleChart.colors = kDataSummariseColorsA

        one.respondSelectRound = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "融资"
            self.markView.bubbleSurfix = TinSearch(code: entry.round, inKeys: kDataRoundKeys)?.name
            self.markView.isHidden = false
            self.markView.update(roundEntry: entry, atPoint: _p)
        }
        one.respondSelectAmount = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "融资"
            self.markView.bubbleSurfix = nil
            self.markView.isHidden = false
            self.markView.update(amountEntry: entry, atPoint: _p)
        }
        one.respondSelectIndustry = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "融资"
            self.markView.bubbleSurfix = entry.name
            self.markView.isHidden = false
            self.markView.update(industryEntry: entry, atPoint: _p)
        }
        one.respondDisSelect = { [unowned self] in
            self.markView.isHidden = true
        }
        one.setupOrder(types: [])
        return one
    }()
    
    lazy var mergeCell: DataSummariseChartsCell = {
        let one = DataSummariseChartsCell()
        one.titleLabel.text = "并购"
        
        one.amountChart.colors = [HEX("#f7d849")]
        one.scaleChart.colors = kDataSummariseColorsB
        
        one.respondSelectRound = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "并购"
            self.markView.bubbleSurfix = TinSearch(code: entry.round, inKeys: kDataRoundKeys)?.name
            self.markView.isHidden = false
            self.markView.update(roundEntry: entry, atPoint: _p)
        }
        one.respondSelectAmount = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "并购"
            self.markView.bubbleSurfix = nil
            self.markView.isHidden = false
            self.markView.update(amountEntry: entry, atPoint: _p)
        }
        one.respondSelectIndustry = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "并购"
            self.markView.bubbleSurfix = entry.name
            self.markView.isHidden = false
            self.markView.update(industryEntry: entry, atPoint: _p)
        }
        one.respondDisSelect = { [unowned self] in
            self.markView.isHidden = true
        }
        one.setupOrder(types: [])
        return one
    }()
    
    lazy var exitCell: DataSummariseChartsCell = {
        let one = DataSummariseChartsCell()
        one.titleLabel.text = "退出"
        
        one.amountChart.colors = [HEX("#f78649")]
        one.scaleChart.colors = kDataSummariseColorsC
        
        one.respondSelectRound = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "退出"
            self.markView.bubbleSurfix = TinSearch(code: entry.round, inKeys: kDataRoundKeys)?.name
            self.markView.isHidden = false
            self.markView.update(roundEntry: entry, atPoint: _p)
        }
        one.respondSelectAmount = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "退出"
            self.markView.bubbleSurfix = nil
            self.markView.isHidden = false
            self.markView.update(amountEntry: entry, atPoint: _p)
        }
        one.respondSelectIndustry = { [unowned self, unowned one] entry, p in
            let _p = one.convert(p, to: self.tableView)
            self.markView.bubblePrefix = "退出"
            self.markView.bubbleSurfix = entry.name
            self.markView.isHidden = false
            self.markView.update(industryEntry: entry, atPoint: _p)
        }
        one.respondDisSelect = { [unowned self] in
            self.markView.isHidden = true
        }
        one.setupOrder(types: [])
        return one
    }()
    
    lazy var markView: DataSummariseMarkView = {
        let one = DataSummariseMarkView()
        one.respondInstitutions = { [unowned self, unowned one] institutions in
//            let point = self.markView.convert(self.markView.center, to: UIApplication.shared.keyWindow!)
            let vc = DataSummariseBubbleViewController()
            vc.titlePrefix = one.bubblePrefix
            vc.titleSurfix = one.bubbleSurfix
            vc.institutions = institutions
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        one.respondInstitution = { [unowned self] institution in
            if institution.type == .institution {
                let vc = InstitutionDetailViewController()
                vc.id = "\(SafeUnwarp(institution.id, holderForNull: 0))"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc = EnterpriseDetailViewController()
                vc.id = "\(SafeUnwarp(institution.id, holderForNull: 0))"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return one
    }()

    var item: DataSummariseVcItem!
    
    private var isLoading: Bool = false
    override func loadData(_ done: @escaping LoadingDataDone) {
        isLoading = true
        DataListManager.shareInstance.getDataSummariseCharts(type: self.item.type, success: { [weak self] (code, msg, summarise) in
            self?.isLoading = false
            if code == 0 {
                self?.summarise = summarise
                done(.noMore)
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
        }) { [weak self] (error) in
            self?.isLoading = false
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        setupRefreshHeader()
        loadDataOnFirstWillAppear = true
        tableView.backgroundColor = kClrWhite
        tableView.backgroundColor = kClrWhite
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 49))
        
        tableView.tableHeaderView = hotView
        tableView.showsVerticalScrollIndicator = false
        
        tableView.addSubview(markView)
        markView.isHidden = true
        
        loadingTableView.backgroundColor = kClrWhite
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isLoading {
            if summarise == nil {
                loadData()
            }
        }
    }
        
    required init() {
        super.init(tableStyle: .grouped)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataSummariseChartsCell.cellHeight()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return investCell
        } else if indexPath.row == 1 {
            return mergeCell
        } else if indexPath.row == 2 {
            return exitCell
        }
        return UITableViewCell()
    }
    
}
