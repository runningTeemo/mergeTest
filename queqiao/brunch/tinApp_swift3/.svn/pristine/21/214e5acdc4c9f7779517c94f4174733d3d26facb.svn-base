//
//  FundsListViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FundsListViewController: RootTableViewController {
    
    var models = [Funds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "管理基金"
        tableView.register(InstitutionManageFundCell.self, forCellReuseIdentifier: "InstitutionManageFundCell")
        setupNavBackBlackButton(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstitutionManageFundCell") as! InstitutionManageFundCell
        cell.indexPath = indexPath
        cell.cellWidth = self.view.frame.size.width
        cell.titleStr = SafeUnwarp(models[indexPath.row].cnName, holderForNull: "")
        cell.selectionStyle = .none
        cell.cellLine.isHidden = (indexPath.row == models.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
}
