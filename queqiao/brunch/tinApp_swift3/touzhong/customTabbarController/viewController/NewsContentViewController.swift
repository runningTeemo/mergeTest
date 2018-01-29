//
//  NewsContentViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsContentViewController: RootTableViewController {
    
    weak var item: NewsVcItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        setupRefreshHeader()
        setupRefreshFooter()
        loadDataOnFirstWillAppear = true
    }
    
    required init() {
        super.init(tableStyle: .grouped)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
}
