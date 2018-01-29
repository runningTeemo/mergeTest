//
//  LocationPickerCountriesViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/10.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class LocationPickerCountriesViewController: RootTableViewController {
    
    var respondCity: ((_ name: String?) -> ())?
    
    var countryGroups: [LocationPinYinGroupModel] = [LocationPinYinGroupModel]()
    var indexTitles: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = kClrBlue
        
        tableView.register(LocationPickerCell.self, forCellReuseIdentifier: "LocationPickerCell")
        tableView.register(LocationPickerCountriesHeaderView.self, forHeaderFooterViewReuseIdentifier: "LocationPickerCountriesHeaderView")
        
        title = "选择地点"
        setupNavBackBlackButton(nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countryGroups.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryGroups[section].arr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationPickerCell") as! LocationPickerCell
        let arr = countryGroups[indexPath.section].arr
        let model = arr[indexPath.row]
        cell.titleLabel.text = model.name
        cell.rightArrow.isHidden = true
        cell.showBottomLine = !(arr.count - 1 == indexPath.row)
        cell.respondCity = { [unowned self] name in
            self.dismiss(animated: true, completion: nil)
            self.respondCity?(name)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocationPickerCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LocationPickerHeaderView.viewHeight()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LocationPickerCountriesHeaderView") as! LocationPickerCountriesHeaderView
        view.titleLabel.text = countryGroups[section].pinYinFirstChar
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
}

class LocationPickerCountriesHeaderView: RootTableViewHeaderFooterView {
    override class func viewHeight() -> CGFloat {
        return 20
    }
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 14)
        return one
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kClrBackGray
        contentView.addSubview(titleLabel)
        titleLabel.IN(contentView).LEFT(12.5).TOP.BOTTOM.RIGHT(12.5).MAKE()
        contentView.clipsToBounds = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
