//
//  InstitutionChartViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionChartViewController: RootTableViewController {
    
    var id: String?
    
    var items: [InstitutionChartItem] = [InstitutionChartItem]()
    var cells: [InstitutionChartCell] = [InstitutionChartCell]()
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        DataListManager.shareInstance.getInstitutionChart(id: id, success: { [weak self] (code, msg, charts) in
            if code == 0 {
                let charts = charts!
                var items = [InstitutionChartItem]()
                var cells = [InstitutionChartCell]()
                for chart in charts {
                    let item = InstitutionChartItem(chart: chart)
                    items.append(item)
                    let cell = InstitutionChartCell()
                    cells.append(cell)
                }
                self?.items = items
                self?.cells = cells
                self?.tableView.reloadData()
                if charts.count > 0 {
                    done(.noMore)
                } else {
                    done(.empty)
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
        }, failed: { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "投资分析"
        setupNavBackBlackButton(nil)
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        tableView.register(InstitutionChartCell.self, forCellReuseIdentifier: "InstitutionChartCell")
        
        emptyMsg = "暂无分析数据"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        cell.item = items[indexPath.row]
        cell.showBottomLine = !(indexPath.row == cells.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InstitutionChartCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}
