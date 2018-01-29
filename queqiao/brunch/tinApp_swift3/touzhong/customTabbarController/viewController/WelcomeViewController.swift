//
//  WelcomeViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit


class WelcomeItem {
    var image: String!
    var attriString: NSAttributedString!
    var bottonBtn: Bool = true
}

class WelcomeViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var items: [WelcomeItem] = [WelcomeItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        //view.addSubview(pageControl)
        collectionView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        //pageControl.IN(view).BOTTOM(50).LEFT(20).RIGHT(20).HEIGHT(10).MAKE()
        
        let item0 = WelcomeItem()
        item0.image = "sp1"
        item0.bottonBtn = false
        
        let item1 = WelcomeItem()
        item1.image = "sp2"
        item1.bottonBtn = false
        
        let item2 = WelcomeItem()
        item2.image = "sp3"
        item2.bottonBtn = true
        
        items = [item0, item1, item2]
        //pageControl.numberOfPages = items.count
        
    }
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = kScreenSize
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
        one.bounces = true
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(WelcomeCell.self, forCellWithReuseIdentifier: "WelcomeCell")
        return one
    }()
    
//    lazy var pageControl: UIPageControl = {
//        let one = UIPageControl()
//        one.pageIndicatorTintColor = UIColor.gray
//        one.currentPageIndicatorTintColor = UIColor.orange
//        return one
//    }()
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCell", for: indexPath) as! WelcomeCell
        let item = items[indexPath.item]
        cell.item = item
        return cell
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let deltaX = scrollView.contentOffset.x
//        let idx = Int(deltaX / kScreenW)
//        pageControl.currentPage = idx
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.x
//        if offset > kScreenW * 2 {
//            pageControl.isHidden = true
//        } else {
//            pageControl.isHidden = false
//        }
//    }
    
    
    var goToMain: Bool = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if offset < 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        } else if offset > (kScreenW * 2 + 50) {
            if !goToMain {
                goToMain = true
                (UIApplication.shared.delegate as! AppDelegate).setupMainView()
            }
        }
    }
    
}

class WelcomeCell: UICollectionViewCell {
    
    var item: WelcomeItem! {
        didSet {
            imageView.image = UIImage(named: item.image)
            btn.isHidden = !item.bottonBtn
        }
    }
    
    lazy var imageView: ImageView = {
        let one = ImageView(type: .image)
        one.backgroundColor = kClrWhite
        one.image = nil
        return one
    }()
    lazy var btn: TitleButton = {
        let one = TitleButton()
        one.cornerRadius = 5
        one.title = "开启畅快体验"
        one.norTitlefont = UIFont.systemFont(ofSize: 16)
        one.dowTitlefont = UIFont.systemFont(ofSize: 16)
        one.dowTitleColor = UIColor.white
        one.norTitleColor = UIColor.white
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        
        one.layer.borderColor = kClrWhite.cgColor
        one.layer.borderWidth = 1
        
        one.signal_event_touchUpInside.head({ (signal) in
            (UIApplication.shared.delegate as! AppDelegate).setupMainView()
        })
        return one
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(btn)
        contentView.backgroundColor = kClrWhite
        imageView.IN(contentView).LEFT.RIGHT.BOTTOM.HEIGHT(kScreenW * 1772 / 1125).MAKE()
        btn.IN(contentView).CENTER.WIDTH(145).HEIGHT(44).BOTTOM(26).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


