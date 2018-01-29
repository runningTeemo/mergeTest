//
//  MyCollectionContentViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/19.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

//class MyCollectionVcItem {
//    let title: String
//    let vcClass: AnyClass
//    let type: CollectionType
//    var vc: MyCollectionContentViewController?
//    init(title: String, type: CollectionType, vcClass: AnyClass) {
//        self.title = title
//        self.type = type
//        self.vcClass = vcClass
//    }
//}
//
//class MyCollectionViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    var items: [MyCollectionVcItem] = [MyCollectionVcItem]()
//    fileprivate(set) var idx: Int = 0
//
//    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
//        let one = UICollectionViewFlowLayout()
//        one.itemSize = CGSize(width: kScreenW, height: kScreenH - 64 - 44)
//        one.minimumInteritemSpacing = 0
//        one.minimumLineSpacing = 0
//        one.scrollDirection = .horizontal
//        return one
//    }()
//    fileprivate lazy var collectionView: UICollectionView = {
//        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
//        one.backgroundColor = UIColor.clear
//        one.dataSource = self
//        one.delegate = self
//        one.isPagingEnabled = true
//        one.bounces = false
//        one.showsHorizontalScrollIndicator = false
//        one.showsVerticalScrollIndicator = false
//        one.register(CollectionVcCell.self, forCellWithReuseIdentifier: "CollectionVcCell")
//        return one
//    }()
//
//    lazy var segmentView: SegmentControl = {
//        let one = SegmentControl(titles: "新闻", "报告", "会议")
//        one.respondSelect = { [unowned self] idx in
//            self.idx = idx
//            let indexPath = IndexPath(item: idx, section: 0)
//            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
//        return one
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "我的收藏"
//        setupNavBackBlackButton(nil)
//
//        view.addSubview(collectionView)
//        collectionView.IN(view).LEFT.RIGHT.TOP(44).BOTTOM.MAKE()
//
//        view.addSubview(segmentView)
//        segmentView.IN(view).LEFT.RIGHT.TOP(64).HEIGHT(44).MAKE()
//
//        items = [
//            MyCollectionVcItem(title: "新闻", type: .news, vcClass: FirstCollectionContentViewController.self),
//            MyCollectionVcItem(title: "报告", type: .report, vcClass: MyCollectionContentViewController.self),
//            MyCollectionVcItem(title: "会议", type: .conference, vcClass: MyCollectionContentViewController.self)
//        ]
//
//        //updateHead()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        showNav()
//    }
//
//    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionVcCell", for: indexPath) as! CollectionVcCell
//        let item = items[indexPath.item]
//        if item.vc == nil {
//            let vc = (item.vcClass as! MyCollectionContentViewController.Type).init()
//            self.addChildViewController(vc)
//            vc.item = item
//            item.vc = vc
//        }
//        cell.vc = item.vc
//        return cell
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let deltaX = scrollView.contentOffset.x
//        let idx = Int(deltaX / kScreenW)
//        self.idx = idx
//        segmentView.selectIdx = idx
//        segmentView.update()
//    }
//}


//class FirstCollectionContentViewController: MyCollectionContentViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadData()
//    }
//}
//
//class MyCollectionContentViewController: RootTableViewController {
//    
//    weak var item: MyCollectionVcItem!
//    
//    var collections: [Collection] = [Collection]()
//    var nextPage: Int = 1
//
//    override func loadData(_ done: @escaping LoadingDataDone) {
//        resetFooter()
//        nextPage = 1
//        loadMore(done)
//    }
//    
//    override func loadMore(_ done: @escaping LoadingDataDone) {
//        
//        let me = Account.sharedOne.user
//        let type = item.type
//        
//        MyselfManager.shareInstance.getCollects(user: me, type: type, page: nextPage, success: { [weak self] (code, msg, collections) in
//            //1001
//            if code == 0 {
//                if let s = self {
//                    let collections = collections!
//                    if s.nextPage == 1 {
//                        s.collections = collections
//                    } else {
//                        s.collections += collections
//                    }
//                    s.nextPage += 1
//                    s.tableView.reloadData()
//                    done(s.checkOutLoadDataType(allModels: s.collections, newModels: collections))
//                }
//            } else {
//                QXTiper.showWarning(msg + "(\(code))", inView: self?.view, cover: true)
//                done(.err)
//            }
//            }) { [weak self] (error) in
//            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
//            done(.err)
//            
//        }
//
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupLoadingView()
//        setupRefreshHeader()
//        setupRefreshFooter()
//        loadDataOnFirstWillAppear = true
//        
//        tableView.register(MyCollectionCell.self, forCellReuseIdentifier: "MyCollectionCell")
//    }
//    
//    required init() {
//        super.init(tableStyle: .grouped)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return collections.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCollectionCell") as! MyCollectionCell
//        cell.collection = collections[indexPath.row]
//        cell.showBottomLine = !(indexPath.row == collections.count - 1)
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return MyCollectionCell.cellHeight()
//    }
//    
//}

