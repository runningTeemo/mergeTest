//
//  GuideChooseAttentionsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class GuideChooseAttentionsViewController: StaticCellBaseViewController {
    
    var industries: [Industry] = [Industry]()
    var industriesSelectIdxes: [Int] = [Int]()
    
    weak var comeFromVc: UIViewController?

    var colums: [NewsVcItem] = [NewsVcItem]()
    var columsSelectIdxes: [Int] = [Int]()

    override func loadData(_ done: @escaping LoadingDataDone) {
        industries.removeAll()
        
        let items = NewsVcItem.loadDefaultOrderItems()
        colums = items

        industries.removeAll()
        ArticleManager.shareInstance.getIndustries({ [weak self] (code, msg, industries) in
            if code == 0 {
                self?.industries = industries!
            }
            done(.noMore)
            self?.update()
            }) { [weak self]  (error) in
                done(.noMore)
                self?.update()
        }
    }
    
    lazy var topHeaderItem: StaticCellTextItem = {
        let one = StaticCellTextItem()
        one.textFont = UIFont.systemFont(ofSize: 18)
        one.textColor = kClrSubTitle
        one.topMargin = 20
        one.bottomMargin = 20
        one.text = "为了更好的推荐符合您需要的资讯、信息，辛苦您根据喜好进行选择。"
        one.update()
        return one
    }()
    
    let headNorAttriDic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: 16), color: kClrSubTitle)
    let headAlertAttriDic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: 16), color: kClrSubTitle)
    lazy var attentionsHeaderItem: StaticCellTextItem = {
        let one = StaticCellTextItem()
        one.backColor = HEX("f2f5f9")
        one.topMargin = 10
        one.bottomMargin = 10
        one.attriText = StringTool.makeAttributeString("请选择关注的行业:", dic: self.headNorAttriDic)
        one.update()
        return one
    }()
    
    lazy var attentionsItem: StaticCellLabelsPickerItem = {
        let one = StaticCellLabelsPickerItem()
        one.mutiMode = true
        one.selectLimit = 6
        one.respondLimit = { [unowned self] in
            QXTiper.showWarning("最多选6个", inView: self.view, cover: true)
        }
        one.respondSelectChange = { [unowned self] selectIdxes, lastIdx in
            self.industriesSelectIdxes = selectIdxes
        }
        return one
    }()
    
    lazy var columnHeaderItem: StaticCellTextItem = {
        let one = StaticCellTextItem()
        one.textFont = UIFont.systemFont(ofSize: 13 * kSizeRatio)
        one.backColor = HEX("f2f5f9")
        one.topMargin = 10
        one.bottomMargin = 10
        one.attriText = StringTool.makeAttributeString("请选择栏目:", dic: self.headNorAttriDic)
        one.update()
        return one
    }()
    
    lazy var columnsItem: StaticCellLabelsPickerItem = {
        let one = StaticCellLabelsPickerItem()
        one.mutiMode = true
        one.respondSelectChange = { [unowned self] selectIdxes, lastIdx in
            self.columsSelectIdxes = selectIdxes
        }
        return one
    }()
    
    lazy var buttonItem: StaticCellLoadingButtonItem = {
        let one = StaticCellLoadingButtonItem()
        one.title = "开启畅快体验"
        one.buttonClick = { [unowned self, unowned one] in
            one.isLoading = true
            self.tableView.reloadData()
            self.handleSave()
        }
        return one
    }()
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 50
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        staticItems = [topHeaderItem, attentionsHeaderItem, attentionsItem, columnHeaderItem, columnsItem, buttonItem, spaceItem]
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
    }
    
    func update() {
        
        if industries.count > 0 {
            staticItems = [topHeaderItem, attentionsHeaderItem, attentionsItem, columnHeaderItem, columnsItem, buttonItem, spaceItem]
            attentionsItem.labels = industries.map({ $0 as labelProtocol })
            attentionsItem.update()
        } else {
            staticItems = [topHeaderItem, columnHeaderItem, columnsItem, buttonItem, spaceItem]
        }

        columnsItem.labels = colums.map({ $0 as labelProtocol })
        columnsItem.update()
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func handleSave() {
        
        if !Account.sharedOne.isLogin { return }
        
        var selectIndustries = [Industry]()

        for i in 0..<industries.count {
            let ind = industries[i]
            for idx in industriesSelectIdxes {
                if idx == i {
                    selectIndustries.append(ind)
                    break
                }
            }
        }
        
        var selectColums = [NewsVcItem]()
        for i in 0..<colums.count {
            let colum = colums[i]
            for idx in columsSelectIdxes {
                if idx == i {
                    selectColums.append(colum)
                    break
                }
            }
        }
        
        var orderColums = [NewsVcItem]()
        var pickedColums = [NewsVcItem]()
        var remainColums = [NewsVcItem]()
        for colum in colums {
            var picked = false
            for pickColum in selectColums {
                if pickColum.title == colum.title {
                    picked = true
                    break
                }
            }
            if picked {
                pickedColums.append(colum)
            } else {
                remainColums.append(colum)
            }
        }
        orderColums += pickedColums
        orderColums += remainColums
        
        
        if pickedColums.count > 0 {
            NewsVcItem.saveToLocal(items: orderColums)
        }
        
        if selectIndustries.count > 0 {
            let me = Account.sharedOne.user
            ArticleManager.shareInstance.setAttentionIndustries(me, industries: selectIndustries, success: { [weak self] (code, msg, ret) in
                self?.buttonItem.isLoading = false
                self?.tableView.reloadData()
                if let vc = self?.comeFromVc {
                    _ = self?.navigationController?.popToViewController(vc, animated: true)
                } else {
                    _ = self?.navigationController?.popToRootViewController(animated: true)
                }
                if code == 0 {
                    Account.sharedOne.user.industries = selectIndustries
                    Account.sharedOne.saveUser()
                }
            }) { [weak self] (error) in
                self?.buttonItem.isLoading = false
                self?.tableView.reloadData()
                if let vc = self?.comeFromVc {
                    _ = self?.navigationController?.popToViewController(vc, animated: true)
                } else {
                    _ = self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            buttonItem.isLoading = false
            tableView.reloadData()
            if let vc = self.comeFromVc {
                _ = self.navigationController?.popToViewController(vc, animated: true)
            } else {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}
