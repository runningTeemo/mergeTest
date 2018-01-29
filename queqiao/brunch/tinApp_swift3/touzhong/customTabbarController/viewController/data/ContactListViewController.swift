//
//  ContactListViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/23.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ContactListViewController: QXYRootTableViewController,UITableViewDataSource,UITableViewDelegate {

    var contactArr:[ContactViewModel] = [ContactViewModel](){
        didSet{
            tableView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "联系方式"
        setupNavBackBlackButton(nil)
        loadingTableView.isHidden = true
        tableView.removeFromSuperview()
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = mainBgGray
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - NaviHeight)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)

    }
    override func viewWillAppear(_ animated: Bool) {
        showNav()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(indexPath.section)
        print(contactArr[indexPath.section].cellHeight!)
        return contactArr[indexPath.section].cellHeight!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "contactId"
        var cell: ContactCell?
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ContactCell
        if cell == nil {
            cell = ContactCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        cell?.viewController = self
        cell!.cellWidth = self.view.frame.width
        cell!.viewModel = contactArr[indexPath.section]
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
