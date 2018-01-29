//
//  OrganizationPickerViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class OrganizationPickerViewController: RootViewController {
    
    var responder: ((_ organization: Organization) -> ())?
    
    var type: OrganizationType! = .company
    var keyword: String!
    var initText: String?
    
    lazy var searchHeadView: SearchHeaderView = {
        let one = SearchHeaderView()
        one.respondChange = { [unowned self] text in
            self.keyword = SafeUnwarp(text, holderForNull: "")
            self.handleSearch()
        }
        return one
    }()

    lazy var tipVc: OrganizationTipCellViewController = {
        let one = OrganizationTipCellViewController()
        one.respondSelect = { [unowned self] organization in
            self.responder?(organization)
            _ = self.navigationController?.popViewController(animated: true)
        }
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "确定", responder: { [unowned self] in
            self.handleSave()
        })
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchHeadView)
        searchHeadView.IN(view).LEFT.RIGHT.TOP.HEIGHT(55).MAKE()
        
        view.addSubview(tipVc.view)
        addChildViewController(tipVc)
        tipVc.view.IN(view).LEFT.RIGHT.TOP(46).BOTTOM.MAKE()
        tipVc.type = type
        
        title = "公司设置"
        setupNavBackBlackButton(nil)
        setupRightNavItems(items: saveNavItem)
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        searchHeadView.searchView.textField.text = initText
        self.keyword = initText
        searchHeadView.searchView.textField.becomeFirstResponder()
        if initText != nil {
            handleSearch()
        }
    }
    
    func handleSearch() {
        tipVc.handleText(self.keyword)
    }
    
    func handleSave() {
        let text = searchHeadView.searchView.textField.text
        let organization = Organization()
        organization.name = text
        responder?(organization)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}


class OrganizationTipCellViewController: RootTableViewController {
    
    var respondSelect: ((_ organization: Organization) -> ())?
    
    var respondEndEdit: (() -> ())?
    var key: String?
    
    var tips: [Organization] = [Organization]()
    var type: OrganizationType = .combine

    /// 这个标示用于保证频繁访问网络只取最后一条数据
    var changeFlag: Int = 0
    func handleText(_ text: String) {
        key = text
        changeFlag += 1
        search(text, flag: changeFlag) { [weak self] (flag, tips) in
            if let s = self {
                if s.changeFlag == flag {
                    s.tips = tips
                    s.tableView.reloadData()
                }
            }
        }
    }
    
    /// 只有成功才返回数据
    func search(_ text: String, flag: Int, done: @escaping ((_ flag: Int, _ tips: [Organization]) -> ())) {
        CommonSearchManager.shareInstance.searchOrganisationTips(key: text, type: type, success: { (code, msg, tips, totalCount) in
            if code == 0 {
                done(flag, tips!)
            }
        }, failed: { (error) in
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(OrganizationTipCell.self, forCellReuseIdentifier: "OrganizationTipCell")
    }
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationTipCell") as! OrganizationTipCell
        cell.tip = tips[indexPath.row]
        cell.showType = type == .combine
        cell.showBottomLine = !(indexPath.row == tips.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrganizationTipCell.cellHeight()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        respondEndEdit?()
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let tip = tips[indexPath.row]
        respondSelect?(tip)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}


class OrganizationTipCell: RootTableViewCell {
    var tip: Organization! {
        didSet {
            contentLabel.attributedText = tip.attriStr
            typeLabel.text = tip.type?.toString()
        }
    }
    
    var showType: Bool = true {
        didSet {
            if showType {
                typeLabel.isHidden = false
                typeLabelWidthCons.constant = 36
                contentLabelRightCons.constant = -20
            } else {
                typeLabel.isHidden = true
                typeLabelWidthCons.constant = 0
                contentLabelRightCons.constant = 0
            }
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return 44
    }
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 15)
        return one
    }()
    lazy var typeLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 10)
        one.textAlignment = .center
        one.backgroundColor = HEX("#b5b5b5")
        one.layer.cornerRadius = 3
        one.clipsToBounds = true
        return one
    }()
    
    var typeLabelWidthCons: NSLayoutConstraint!
    var contentLabelRightCons: NSLayoutConstraint!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentLabel)
        contentView.addSubview(typeLabel)
        typeLabel.IN(contentView).RIGHT(12.5).CENTER.HEIGHT(18).MAKE()
        typeLabelWidthCons = typeLabel.WIDTH.EQUAL(36).MAKE()
        contentLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        contentLabelRightCons = contentLabel.RIGHT.LESS_THAN_OR_EQUAL(typeLabel).LEFT.OFFSET(-20).MAKE()
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
