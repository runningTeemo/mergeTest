//
//  NewsMainViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsVcItem: labelProtocol {
    
    let title: String
    let vcClass: AnyClass
    let channel: String
    var vc: NewsContentViewController?
    
    var name: String? {
        return title
    }
    var content: String? {
        return channel
    }
    
    init(title: String, channel: String, vcClass: AnyClass) {
        self.title = title
        self.channel = channel
        self.vcClass = vcClass
    }
    
    init(dic: [String: Any]) {
        self.title = SafeUnwarp(dic.nullableString("title"), holderForNull: "")
        self.channel = SafeUnwarp(dic.nullableString("channel"), holderForNull: "")
        self.vcClass = NSClassFromString(SafeUnwarp(dic.nullableString("vcClass"), holderForNull: ""))!
    }
    
    func toDic() -> [String: Any] {
        var dic = [String: Any]()
        dic.checkOrAppend("title", value: title)
        dic.checkOrAppend("vcClass", value: NSStringFromClass(vcClass))
        dic.checkOrAppend("channel", value: channel)
        return dic
    }
    
    class func loadDefaultOrderAllItems() -> [NewsVcItem] {
        var items = self.loadDefaultOrderItems()
        let firstItem = NewsVcItem(title: "热点", channel: "-1", vcClass: NewsHotViewController.self)
        items.insert(firstItem, at: 0)
        return items
    }
    
    class func loadDefaultOrderItems() -> [NewsVcItem] {
        var items = [NewsVcItem]()
        if let path = Bundle.main.path(forResource: "newsDefaultOrder.arr", ofType: nil) {
            if let arr = NSArray(contentsOfFile: path) as? [[String: Any]] {
                for dic in arr {
                    let item = NewsVcItem(dic: dic)
                    items.append(item)
                }
            }
        }
        if items.count == 0 {
            items = [
                NewsVcItem(title: "报告", channel: "", vcClass: NewsReportViewController.self),
                NewsVcItem(title: "VC/PE", channel: "11", vcClass: NewsChannelViewController.self),
                NewsVcItem(title: "瞰三板", channel: "3", vcClass: NewsChannelViewController.self),
                NewsVcItem(title: "跨境", channel: "2", vcClass: NewsChannelViewController.self),
                NewsVcItem(title: "潮汛Hot", channel: "4", vcClass: NewsChannelViewController.self),
                NewsVcItem(title: "金融", channel: "5", vcClass: NewsChannelViewController.self),
                NewsVcItem(title: "锐公司", channel: "14", vcClass: NewsChannelViewController.self),
                NewsVcItem(title: "产业资本", channel: "20", vcClass: NewsChannelViewController.self),
                NewsVcItem(title: "人物", channel: "23", vcClass: NewsChannelViewController.self),
            ]
        }
        return items
    }
    
    class func cachePath() -> String {
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            let id = SafeUnwarp(me.id, holderForNull: "defaultUser")
            return PathTool.document + "/" + id + "_newsOrder.cache"
        }
        return PathTool.document + "/defaultUser_newsOrder.cache"
    }
    
    class func loadItems() -> [NewsVcItem] {
        if let arr = NSArray(contentsOfFile: self.cachePath()) as? [[String: Any]] {
            var items = [NewsVcItem]()
            for dic in arr {
                let item = NewsVcItem(dic: dic)
                items.append(item)
            }
            if items.count > 0 {
                let firstItem = NewsVcItem(title: "热点", channel: "-1", vcClass: NewsHotViewController.self)
                items.insert(firstItem, at: 0)
                return items
            } else {
                return self.loadDefaultOrderAllItems()
            }
        }
        return self.loadDefaultOrderAllItems()
    }
    
    class func saveToLocal(items: [NewsVcItem]) {
        var arr = [[String: Any]]()
        for item in items {
            if item.title != "热点" {
                arr.append(item.toDic())
            }
        }
        (arr as NSArray).write(toFile: self.cachePath(), atomically: true)
    }
    
}

class NewsMainViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate, LogoutProtocol {

    var popToRootIfLogout: Bool = false

    func performLogin() {
        filterVc.reset()
        clearFirstInStatus()
    }
    
    func performLogout() {
        filterVc.reset()
        clearFirstInStatus()
        
        if popToRootIfLogout {
            dismiss(animated: false, completion: nil)
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    var items: [NewsVcItem] = [NewsVcItem]()
    fileprivate(set) var idx: Int = 0
    
    
    lazy var filterVc: NewsFilterViewController = {
        let one = NewsFilterViewController()
        return one
    }()
    
    lazy var filterItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconTopFilter", responder: { [unowned self] in
            RootFilterShower.shareOne.show(onLeft: true, vc: self.filterVc, inVc: self, complete: nil)
        })
        return one
    }()
    
    lazy var searchItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconNewsSearch", responder: { [unowned self] in
            if Account.sharedOne.isLogin {
                let vc = MainSearchViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.popToRootIfLogout = true
            } else {
                self.push2ToLoginVc(comeFromVc: self)
            }
        })
        return one
    }()
    
    lazy var indexVc: NewsMainIndexViewController = {
        let one = NewsMainIndexViewController()
        one.view.backgroundColor = kClrWhite
        one.respondSelect = { [unowned self] idx in
            self.scroll(idx: idx)
            let item = self.items[idx]
            if item.title == "报告" {
                self.removeLeftNavItems()
            } else {
                self.setupLeftNavItems(items: self.filterItem)
            }
        }
        one.btnOrder.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.showOrderVc()
        })
        return one
    }()
    
    func scroll(idx: Int) {
        self.idx = idx
        let indexPath = IndexPath(item: idx, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func showOrderVc() {
        let vc = NewsOrderViewController()
        vc.items = items
        present(vc, animated: true) { 
            
        }
        vc.respondUpdate = { [unowned self] items in
            self.items = items
            self.updateHead()
            self.collectionView.reloadData()
            self.scroll(idx: 0)
        }
    }
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = CGSize(width: kScreenW, height: kScreenH - 64 - 49 - 40)
        one.minimumInteritemSpacing = 0
        one.minimumLineSpacing = 0
        one.scrollDirection = .horizontal
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = true
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(CollectionVcCell.self, forCellWithReuseIdentifier: "CollectionVcCell")
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.IN(view).LEFT.RIGHT.TOP(40).BOTTOM.MAKE()
        
        view.addSubview(indexVc.view)
        addChildViewController(indexVc)
        indexVc.view.IN(view).LEFT.RIGHT.TOP.HEIGHT(40).MAKE()
        
        setupLeftNavItems(items: filterItem)
        setupRightNavItems(items: searchItem)
    }
    
    /// collectionView必须显示后才可以滚动
    override func onFirstAppear() {
        super.onFirstAppear()
        items = NewsVcItem.loadItems()
        updateHead()
        collectionView.contentOffset = CGPoint.zero
        collectionView.reloadData()
        scroll(idx: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
        popToRootIfLogout = false
    }
    
    func updateHead() {
        var isFirst = true
        var headItems = [NewsMainIndexItem]()
        for item in items {
            let headItem = NewsMainIndexItem(title: item.title, isSelect: isFirst)
            isFirst = false
            headItems.append(headItem)
        }
        indexVc.items = headItems
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionVcCell", for: indexPath) as! CollectionVcCell
        let item = items[indexPath.item]
        if item.vc == nil {
            let vc = (item.vcClass as! NewsContentViewController.Type).init()
            self.addChildViewController(vc)
            vc.item = item
            item.vc = vc
        }
        cell.vc = item.vc
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let deltaX = scrollView.contentOffset.x
        let idx = Int(deltaX / kScreenW)
        self.idx = idx
        indexVc.selectIdx(idx)
        indexVc.scrollToIdx(idx)
        
        let item = items[idx]
        if item.title == "报告" {
            removeLeftNavItems()
        } else {
            setupLeftNavItems(items: filterItem)
        }
    }
    
}

class CollectionVcCell: UICollectionViewCell {
    var vc: UIViewController! {
        didSet {
            vcView = vc.view
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    fileprivate var vcView: UIView! {
        didSet {
            for v in contentView.subviews {
                v.removeFromSuperview()
            }
            contentView.addSubview(vcView)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        vc.view.frame = bounds
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
