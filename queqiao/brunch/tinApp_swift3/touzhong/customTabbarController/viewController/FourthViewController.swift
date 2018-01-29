//
//  FourthViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/8/15.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FourthViewController: RootTableViewController {

    var control:UISwitch! = nil
    var dataArr:[Int] = [Int]();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "测试4"
        initData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
        
        //for i in 0...1{
            dataArr.append(1)
        //}
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identityId = "cellId"
        let cell = CommonCell(style: UITableViewCellStyle.Default, reuseIdentifier: identityId)
//        cell.textLabel?.text = "\(self.dataArr[indexPath.row])"
        control = UISwitch(frame: CGRectMake(20,6,20,20))
        control.addTarget(self, action: #selector(FourthViewController.changeModelAction), forControlEvents: UIControlEvents.ValueChanged)
        cell.contentView.addSubview(control)
        return cell
        
    }
    func changeModelAction(){
       let model = control.on
       DataManager.shareInstance.nightModel = model;
       let notice = NSNotification(name: "changeModel", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notice)
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
