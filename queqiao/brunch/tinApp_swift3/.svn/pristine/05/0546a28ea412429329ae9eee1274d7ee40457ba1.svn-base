//
//  LocationPickerMainViewController.swift
//  QXChinaLoactionPickerDemo
//
//  Created by Richard.q.x on 2016/11/28.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class LocationPickerMainViewController: RootTableViewController {
    
    var respondCity: ((_ name: String?) -> ())?
    
    private lazy var countryGroups: [LocationPinYinGroupModel] = [LocationPinYinGroupModel]()
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        DispatchQueue.global().async { [weak self] in
            let arr = LocationDataEntry.sharedOne.modelsWithoutChinaGroups
            self?.countryGroups = arr
            var idxs = [String]()
            for countryGroup in arr {
                idxs.append(countryGroup.pinYinFirstChar)
            }
            self?.indexTitles = idxs
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                done(.noMore)
            }
        }
    }
    
    var indexTitles: [String] = [String]()
    
    lazy var headView: LocationPickerMainHeadView = {
        let one = LocationPickerMainHeadView()
        one.respondCountries = { [unowned self] in
            let vc = LocationPickerCountriesViewController()
            vc.countryGroups = self.countryGroups
            vc.indexTitles = self.indexTitles
            vc.respondCity = self.respondCity
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondCity = { [unowned self] name in
            self.dismiss(animated: true, completion: nil)
            self.respondCity?(name)
        }
        return one
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = kClrBlue

        tableView.register(LocationPickerCell.self, forCellReuseIdentifier: "LocationPickerCell")
        tableView.register(LocationPickerHeaderView.self, forHeaderFooterViewReuseIdentifier: "LocationPickerHeaderView")
        
        headView.update()
        tableView.tableHeaderView = headView
        
        title = "选择地点"
        setupLoadingView()
        //setupRefreshHeader()
        loadDataOnFirstWillAppear = true
        
        setupNavBackBlackButton { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        
        if LocationDataEntry.sharedOne.currentCity == nil {
            LocationGetter.shareOne.getLocation(done: { [weak self] (_, _, _) in
                self?.tableView.tableHeaderView = nil
                self?.headView.update()
                self?.tableView.tableHeaderView = self?.headView
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let childrens = LocationDataEntry.sharedOne.chinaModel.childrens {
            return childrens.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationPickerCell") as! LocationPickerCell

        let model = LocationDataEntry.sharedOne.chinaModel.childrens![indexPath.row]
        cell.titleLabel.text = model.name
        cell.rightArrow.isHidden = true
        if let childrens = model.childrens {
            if childrens.count > 0 {
                cell.rightArrow.isHidden = false
            }
        }
        cell.showBottomLine = !(LocationDataEntry.sharedOne.chinaModel.childrens!.count - 1 == indexPath.row)
        cell.respondCity = { [unowned self] name in
            if let childrens = model.childrens {
                if childrens.count > 0 {
                    let vc = LocationPickerChinaViewController()
                    vc.model = model
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
        return LocationPickerHeaderView.viewHeight()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
}

class LocationPickerCell: RootTableViewCell {
    
    var respondCity: ((_ name: String?) -> ())?
    
    lazy var bgBtn: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrSlightGray
        one.addTarget(self, action: #selector(LocationPickerCell.bgBtnClick), for: .touchUpInside)
        return one
    }()
    func bgBtnClick() {
        respondCity?(titleLabel.text)
    }
    
    override class func cellHeight() -> CGFloat {
        return 40
    }
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 14)
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgBtn)
        bgBtn.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        contentView.addSubview(titleLabel)
        setupRightArrow()
        titleLabel.IN(contentView).LEFT(12.5).TOP.BOTTOM.RIGHT(rightMargin + 20).MAKE()
        bottomLineLeftCons?.constant = 12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LocationPickerHeaderView: RootTableViewHeaderFooterView {
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

class LocationPickerMainHeadView: UIView {
    
    var respondCountries: (() -> ())?
    var respondCity: ((_ name: String?) -> ())?
    
    func update() {

        LocationDataEntry.sharedOne.tryGetCurrentCity()
        
        let currentItem = RectSelectsFixSizeItem()
        currentItem.mutiMode = false
        do {
            if let city = LocationDataEntry.sharedOne.currentCity {
                let maxWidth = kScreenW - 12.5 - 30
                currentItem.maxWidth = maxWidth
                currentItem.itemXMargin = 10
                currentItem.itemYMargin = 10
                var subItems = [RectSelectFixSizeItem]()
                for name in [city.name] {
                    let subItem = RectSelectFixSizeItem()
                    subItem.showCornerImage = false
                    subItem.title = name
                    let w = (maxWidth - 10 * 2) / 3
                    subItem.size = CGSize(width: w, height: 30)
                    subItem.update()
                    subItems.append(subItem)
                }
                currentItem.models = subItems
            }
            currentItem.update()
        }
        
        let hotItem = RectSelectsFixSizeItem()
        hotItem.mutiMode = false
        do {
            let maxWidth = kScreenW - 12.5 - 30
            hotItem.maxWidth = maxWidth
            hotItem.itemXMargin = 10
            hotItem.itemYMargin = 10
            
            var subItems = [RectSelectFixSizeItem]()
            for name in LocationDataEntry.hotCityNames {
                let subItem = RectSelectFixSizeItem()
                subItem.showCornerImage = false
                subItem.title = name
                let w = (maxWidth - 10 * 2) / 3
                subItem.size = CGSize(width: w, height: 30)
                subItem.update()
                subItems.append(subItem)
            }
            hotItem.models = subItems
            hotItem.update()
        }
        
        currentView.item = currentItem
        hotView.item = hotItem
        
        let h: CGFloat
        if let _ = LocationDataEntry.sharedOne.currentCity {
            h = 10 + 10 + 20 + 10 + currentItem.viewHeight + 20 + 20 + 10 + hotItem.viewHeight + 20 + 40
            currentViewTopCons.constant = CGFloat(10 + 10 + 20 + 10)
            currentViewHeightCons.constant = currentItem.viewHeight
            hotLabelTopCons.constant = CGFloat(10 + 10 + 20 + 10 + currentItem.viewHeight + 20)
            currentView.isHidden = false
            currentLabel.isHidden = false
        } else {
            h = 10 + 10 + 20 + 10 + hotItem.viewHeight + 20 + 40
            currentViewTopCons.constant = 0
            currentViewHeightCons.constant = 0
            hotLabelTopCons.constant = CGFloat(10 + 10)
            currentView.isHidden = true
            currentLabel.isHidden = true
        }
        
        self.frame = CGRect(x: 0, y: 0, width: kScreenW, height: h)
        
    }
    
    lazy var whiteBack: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor.white
        return one
    }()
    
    lazy var countryBtn: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrSlightGray
        one.addTarget(self, action: #selector(LocationPickerMainHeadView.countryBtnClick), for: .touchUpInside)
        return one
    }()
    func countryBtnClick() {
        respondCountries?()
    }
    
    lazy var currentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 14)
        one.text = "当前位置(仅供参考)"
        return one
    }()
    lazy var currentView: RectSelectsFixSizeView = {
        let one = RectSelectsFixSizeView()
        one.respondSelectChange = { [unowned self] selectIdxes, _ in
            if let first = selectIdxes.first {
                self.respondCity?(LocationDataEntry.sharedOne.currentCity?.name)
            }
        }
        return one
    }()
    
    lazy var hotLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 14)
        one.text = "热门城市"
        return one
    }()
    lazy var hotView: RectSelectsFixSizeView = {
        let one = RectSelectsFixSizeView()
        one.respondSelectChange = { [unowned self] selectIdxes, _ in
            if let first = selectIdxes.first {
                let name = LocationDataEntry.hotCityNames[first]
                self.respondCity?(name)
            }
        }
        return one
    }()
    
    let line1 = NewBreakLine
    
    lazy var countryLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 14)
        one.text = "国外"
        return one
    }()
    lazy var arrow: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconListMore")
        return one
    }()
    
    var currentViewTopCons: NSLayoutConstraint!
    var currentViewHeightCons: NSLayoutConstraint!
    
    var hotLabelTopCons: NSLayoutConstraint!

    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        backgroundColor = kClrBackGray
        
        addSubview(whiteBack)
        whiteBack.IN(self).LEFT.TOP(10).BOTTOM.WIDTH(kScreenW).MAKE()
        
        addSubview(currentLabel)
        currentLabel.IN(self).LEFT(12.5).TOP(10 + 10).WIDTH(kScreenW - 12.5 - 30).HEIGHT(20).MAKE()
        
        addSubview(currentView)
        currentView.IN(self).LEFT(12.5).WIDTH(kScreenW).MAKE()
        currentViewTopCons = currentView.TOP.EQUAL(self).OFFSET(10 + 10 + 20 + 10).MAKE()
        currentViewHeightCons = currentView.HEIGHT.EQUAL(30).MAKE()

        addSubview(hotLabel)
        hotLabel.IN(self).LEFT(12.5).HEIGHT(20).WIDTH(kScreenW - 12.5 - 30).MAKE()
        hotLabelTopCons = hotLabel.TOP.EQUAL(self).OFFSET(10 + 10 + 20 + 10 + 30 + 20).MAKE()

        addSubview(hotView)
        hotView.IN(self).LEFT(12.5).WIDTH(kScreenW).BOTTOM(40 + 20).MAKE()
        hotView.TOP.EQUAL(hotLabel).BOTTOM.OFFSET(10).MAKE()

        addSubview(countryBtn)
        countryBtn.IN(self).LEFT.BOTTOM.WIDTH(kScreenW).HEIGHT(40).MAKE()
        
        addSubview(countryLabel)
        addSubview(line1)
        addSubview(arrow)
        countryLabel.IN(countryBtn).LEFT(12.5).TOP.BOTTOM.WIDTH(kScreenW - 12.5 - 50).MAKE()
        line1.IN(countryBtn).LEFT.RIGHT(15).TOP.HEIGHT(0.5).MAKE()
        arrow.IN(countryBtn).RIGHT(12.5).CENTER.SIZE(15, 15).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
