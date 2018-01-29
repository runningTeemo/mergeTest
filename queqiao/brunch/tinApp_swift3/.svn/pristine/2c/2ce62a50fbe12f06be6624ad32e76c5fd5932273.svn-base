//
//  LocationPickerChinaViewController.swift
//  QXChinaLoactionPickerDemo
//
//  Created by Richard.q.x on 2016/11/28.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class LocationPickerChinaViewController: RootTableViewController {
    
    var respondCity: ((_ name: String?) -> ())?

    var model: LocationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(LocationPickerCell.self, forCellReuseIdentifier: "LocationPickerCell")
        tableView.register(LocationPickerHeaderView.self, forHeaderFooterViewReuseIdentifier: "LocationPickerHeaderView")
            
        title = "选择地点"
        setupNavBackBlackButton(nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let childrens = model.childrens {
            return childrens.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationPickerCell") as! LocationPickerCell
        let subModel = model.childrens![indexPath.row]
        cell.titleLabel.text = subModel.name
        cell.rightArrow.isHidden = true
        if let childrens = subModel.childrens {
            if childrens.count > 0 {
                cell.rightArrow.isHidden = false
            }
        }
        cell.showBottomLine = !(model.childrens!.count - 1 == indexPath.row)
        cell.respondCity = { [unowned self] name in
            if let childrens = subModel.childrens {
                if childrens.count > 0 {
                    let vc = LocationPickerChinaViewController()
                    vc.model = subModel
                    vc.respondCity = self.respondCity
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.respondCity?(name)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.respondCity?(name)
                self.dismiss(animated: true, completion: nil)
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationPickerCell.cellHeight()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
  
}
