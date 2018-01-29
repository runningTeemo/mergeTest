//
//  IndexViewSubBannerView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndexViewSubBannerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var viewHeight: CGFloat { return 74 }
    
    var respondSelect: ((_ banner: Banner) -> ())?
    
    var banners: [Banner] = [Banner]() {
        didSet {
            collectionView.reloadData()
//            if banners.count > 1 {
//                beginTimer()
//            }
        }
    }
    fileprivate(set) var currentIdx: Int = 0
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(collectionView)
        collectionView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = CGSize(width: 236, height: self.viewHeight)
        one.minimumInteritemSpacing = 0
        one.minimumLineSpacing = 7
        one.scrollDirection = .horizontal
        one.sectionInset = UIEdgeInsetsMake(0, 12.5, 0, 0)
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = false
        one.bounces = true
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(IndexViewBannerCell.self, forCellWithReuseIdentifier: "IndexViewBannerCell")
        return one
    }()
    
//    private var timer: QXTimer?
//    func removeTimer() {
//        timer?.remove()
//        timer = nil
//    }
//    func beginTimer() {
//        let timer = QXTimer(duration: 3)
//        timer.loop = { [unowned self] t in
//            if self.banners.count > 1 {
//                if self.currentIdx < self.banners.count - 1 {
//                    self.currentIdx += 1
//                } else {
//                    self.currentIdx = 0
//                }
//                let indexPath = NSIndexPath(forItem: self.currentIdx, inSection: 0)
//                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
//            }
//        }
//        self.timer = timer
//    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexViewBannerCell", for: indexPath) as! IndexViewBannerCell
        let banner = banners[indexPath.item]
        cell.imageView.fullPath = banner.picture
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = banners[indexPath.item]
        respondSelect?(banner)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let deltaX = scrollView.contentOffset.x
        let idx = Int(deltaX / kScreenW)
        self.currentIdx = idx
    }
    
//    // 手动拖拽的时候，禁用timer
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        removeTimer()
//    }
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if banners.count > 1 {
//            beginTimer()
//        }
//    }
    
}
