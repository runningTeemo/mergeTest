//
//  NewsMainHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsMainHeadView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        items[idx].isSelect = true
        collectionView.reloadData()
    }
    
    var items: [NewsMainHeadItem] = [NewsMainHeadItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var btnOrder: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 18, height: 18)
        one.iconView.image = UIImage(named: "iconNewsOpen")
        return one
    }()
    
    lazy var btnSearch: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 18, height: 18)
        one.iconView.image = UIImage(named: "iconNewsSearch")
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
        one.register(NewsMainHeadCell.self, forCellWithReuseIdentifier: "NewsMainHeadCell")
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(collectionView)
        addSubview(btnOrder)
        addSubview(btnSearch)
        collectionView.IN(self).LEFT(12.5).RIGHT(85).TOP.BOTTOM.MAKE()
        btnSearch.IN(self).RIGHT(2).TOP.BOTTOM.WIDTH(40).MAKE()
        btnOrder.IN(self).RIGHT(40).TOP.BOTTOM.WIDTH(40).MAKE()
        clipsToBounds = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsMainHeadCell", for: indexPath) as! NewsMainHeadCell
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

class NewsMainHeadItem {
    var title: String
    var isSelect: Bool = true
    fileprivate var itemSize: CGSize
    init(title: String, isSelect: Bool) {
        self.title = title
        self.isSelect = isSelect
        let size = StringTool.size(title, font: UIFont.systemFont(ofSize: 18)).size
        itemSize = CGSize(width: size.width + 20, height: 44)
    }
}

class NewsMainHeadCell: UICollectionViewCell {
    
    var item: NewsMainHeadItem! {
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
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
