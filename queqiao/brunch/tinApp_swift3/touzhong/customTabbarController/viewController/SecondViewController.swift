//
//  SecondViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/8/15.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SecondViewController: RootTableViewController {
    var dataArr:[Int] = [Int]();
    override func viewDidLoad() {
        self.navigationItem.title = "测试2"
        super.viewDidLoad()
        initData()
        // Do any additional setup after loading the view.
    }
    
    func initData(){
        
        for i in 20...40{
            dataArr.append(i)
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identityId = "cellId"
        let cell = CommonCell(style: UITableViewCellStyle.Default, reuseIdentifier: identityId)
        cell.textLabel?.text = "\(self.dataArr[indexPath.row])"
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
