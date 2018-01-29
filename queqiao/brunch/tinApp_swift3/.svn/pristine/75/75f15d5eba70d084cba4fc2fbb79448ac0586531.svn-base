//
//  NewsMainIndexViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/3.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class NewsMainIndexViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var respondSelect: ((_ idx: Int) -> ())?
    
    fileprivate(set) var idx: Int = 0
    func scrollToIdx(_ idx: Int) {
        let indexPath = IndexPath(item: idx, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func selectIdx(_ idx: Int) {
        self.idx = idx
        for item in items {
            item.isSelect = false
        }
        print("点击啦啦拉拉啊")
        print(idx)
        print(items)
        items[idx].isSelect = true
        collectionView.reloadData()
    }
    
    var items: [NewsMainIndexItem] = [NewsMainIndexItem]() {
        didSet {
            collectionView.contentOffset = CGPoint.zero
            collectionView.reloadData()
        }
    }
    
    lazy var btnOrder: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 18, height: 18)
        one.iconView.image = UIImage(named: "iconNewsOpen")
        return one
    }()
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
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
        one.isPagingEnabled = false
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(NewsMainIndexCell.self, forCellWithReuseIdentifier: "NewsMainIndexCell")
        return one
    }()
    lazy var breakLine = NewBreakLine
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(breakLine)
        breakLine.IN(view).LEFT.BOTTOM.RIGHT.HEIGHT(0.5).MAKE()
        
        view.addSubview(collectionView)
        view.addSubview(btnOrder)
        collectionView.IN(view).LEFT(12.5).RIGHT(45).TOP.BOTTOM.MAKE()
        btnOrder.IN(view).RIGHT.TOP.BOTTOM.WIDTH(40).MAKE()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }

    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsMainIndexCell", for: indexPath) as! NewsMainIndexCell
        cell.item = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != idx {
            idx = indexPath.item
            selectIdx(idx)
            scrollToIdx(idx)
            respondSelect?(idx)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return items[indexPath.item].itemSize
    }
    
    //    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    //        let deltaX = scrollView.contentOffset.x
    //        let idx = Int(deltaX / kScreenW)
    //        //self.currentIdx = idx
    //    }
    //
    
}

class NewsMainIndexItem {
    var title: String
    var isSelect: Bool = true
    fileprivate var itemSize: CGSize
    init(title: String, isSelect: Bool) {
        self.title = title
        self.isSelect = isSelect
        let size = StringTool.size(title, font: UIFont.systemFont(ofSize: 18)).size
        itemSize = CGSize(width: size.width + 10, height: 40)
    }
}

class NewsMainIndexCell: UICollectionViewCell {
    
    var item: NewsMainIndexItem! {
        didSet {
            if item.isSelect {
                label.font = UIFont.systemFont(ofSize: 18)
                label.textColor = kClrBlack
            } else {
                label.font = UIFont.systemFont(ofSize: 16)
                label.textColor = HEX("#666666")
            }
            label.text = item.title
            line.isHidden = !item.isSelect
        }
    }
    
    lazy var label: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 18)
        one.textColor = HEX("#666666")
        return one
    }()
    lazy var line: UIView = {
        let one = UIView()
        one.backgroundColor = kClrOrange
        return one
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(line)
        label.LEFT.EQUAL(contentView).MAKE()
        label.CENTER_Y.EQUAL(contentView).MAKE()
        line.LEFT.EQUAL(label).MAKE()
        line.RIGHT.EQUAL(label).MAKE()
        line.BOTTOM.EQUAL(contentView).MAKE()
        line.HEIGHT.EQUAL(2).MAKE()
        contentView.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
