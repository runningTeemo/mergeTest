//
//  TestScrollViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TestScrollViewController: QXYRootTableViewController,UITableViewDelegate,UITableViewDataSource {

    var searchView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    var oldOffSet:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        view.addSubview(searchView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header.backgroundColor = mainBgGray
        tableView.backgroundColor = mainBgGray
        tableView.frame = CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height - 40)
        getData(false)
        // Do any additional setup after loading the view.
    }
    override func getData(_ isFooterRefresh: Bool) {
        super.getData(isFooterRefresh)
        self.endRefresh(.done, view: nil, message: nil)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "id")
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y<0 {
            return
        }
        if scrollView.contentOffset.y > oldOffSet {
            print("上滑")
            let c = scrollView.contentOffset.y - oldOffSet
            searchView.frame = CGRect(x: 0, y: searchView.frame.origin.y-c, width: view.frame.width, height: 40)
            if searchView.frame.origin.y <= -40 {
                searchView.frame = CGRect(x: 0, y: -40, width: view.frame.width, height: 40)
            }
            tableView.frame = CGRect(x: 0, y: searchView.frame.maxY, width: view.frame.width, height: tableView.frame.height)
            
        }else{
            let c = scrollView.contentOffset.y - oldOffSet
            searchView.frame = CGRect(x: 0, y: searchView.frame.origin.y-c, width: view.frame.width, height: 40)
            if searchView.frame.origin.y > 0 {
                searchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
            }
            tableView.frame = CGRect(x: 0, y: searchView.frame.maxY, width: view.frame.width, height: tableView.frame.height)
        }
        oldOffSet = scrollView.contentOffset.y
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
