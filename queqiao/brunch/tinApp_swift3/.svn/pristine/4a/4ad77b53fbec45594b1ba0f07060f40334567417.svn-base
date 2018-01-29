//
//  DataSummariseViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/4.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class DataSummariseViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var currentIdx: Int = 0
    
    lazy var items: [DataSummariseVcItem] = {
        var one = [DataSummariseVcItem]()
        one.append(DataSummariseVcItem(title: "周", vcClass: DataSummariseContentFirstViewController.self, type: .week))
        one.append(DataSummariseVcItem(title: "月", vcClass: DataSummariseContentViewController.self, type: .month))
        one.append(DataSummariseVcItem(title: "年", vcClass: DataSummariseContentViewController.self, type: .year))
        return one
    }()
    
    lazy var indexView: DataSummariseIndexView = {
        let one = DataSummariseIndexView()
        one.respondIdx = { [unowned self] idx in
            self.currentIdx = idx
            let indexPath = IndexPath(item: idx, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        return one
    }()
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = CGSize(width: kScreenW, height: kScreenH - 64 - DataSummariseIndexView.viewHeight)
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
        one.register(DataSummariseVcCell.self, forCellWithReuseIdentifier: "DataSummariseVcCell")
        one.isScrollEnabled = false
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        collectionView.IN(view).LEFT.RIGHT.TOP(DataSummariseIndexView.viewHeight).BOTTOM.MAKE()
        view.addSubview(indexView)
        indexView.IN(view).LEFT.RIGHT.TOP.HEIGHT(DataSummariseIndexView.viewHeight).MAKE()
//        NotificationCenter.default.addObserver(self, selector: #selector(DataSummariseViewController.didRecieveLoginNotification), name: kNotificationLogin, object: nil)
    }
    
//    func didRecieveLoginNotification() {
//        if let vc = items[currentIdx].vc {
//            vc.loadData()
//        }
//    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataSummariseVcCell", for: indexPath) as! DataSummariseVcCell
        let item = items[indexPath.item]
        if item.vc == nil {
            let vc = (item.vcClass as! DataSummariseContentViewController.Type).init()
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
        self.currentIdx = idx
        if idx == 0 {
            indexView.setWeek()
        } else if idx == 1 {
            indexView.setMonth()
        } else {
            indexView.setYear()
        }
    }
    
}

class DataSummariseVcItem {
    let title: String
    let vcClass: AnyClass
    var vc: DataSummariseContentViewController?
    var type: DataSummariseType
    init(title: String, vcClass: AnyClass, type: DataSummariseType) {
        self.title = title
        self.vcClass = vcClass
        self.type = type
    }
}

class DataSummariseVcCell: UICollectionViewCell {
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
