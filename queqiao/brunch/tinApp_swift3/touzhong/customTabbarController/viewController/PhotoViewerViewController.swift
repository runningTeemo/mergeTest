//
//  PhotoViewerViewController.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/6.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class PhotoViewerViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var isTapBackMode: Bool = false
    
    var isSelectModel: Bool = true
    var currentIndex:Int = 0
    var respondImages: ((_ images: [Image]) -> ())?
    var items: [PhotoViewerItem] = [PhotoViewerItem]() {
        didSet {
            collectionView.reloadData()
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: true)
        }
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = CGSize(width: UIScreen.main.bounds.size.width + 10 * 2, height: UIScreen.main.bounds.size.height)
        one.minimumInteritemSpacing = 0
        one.minimumLineSpacing = 0
        one.scrollDirection = .horizontal
        return one
    }()
    lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = true
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(PhotoViewerCell.self, forCellWithReuseIdentifier: "PhotoViewerCell")
        return one
    }()
    
    lazy var selectItem: BarButtonItem = BarButtonItem(iconName: "photo_select", responder: { [weak self] in
        self?.changeCurrentSelectStatus()
    })
    lazy var disSelectItem: BarButtonItem = BarButtonItem(iconName: "photo_select_dis", responder: { [weak self] in
        self?.changeCurrentSelectStatus()
    })
    func changeCurrentSelectStatus() {
        let item = items[currentIndex]
        item.select = !item.select
        updatePage()
    }
    
//    lazy var pageLabel: UILabel = {
//        let one = UILabel()
//        one.textColor = UIColor.white
//        one.font = UIFont.systemFont(ofSize: 16)
//        return one
//    }()
    lazy var pageControl: UIPageControl = {
        let one = UIPageControl()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 这个用于取消第二个scroll的自动insert
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.isHidden = true
        
        view.backgroundColor = UIColor.black
        view.addSubview(collectionView)
        collectionView.WIDTH.EQUAL(UIScreen.main.bounds.size.width + 10 * 2).MAKE()
        collectionView.HEIGHT.EQUAL(UIScreen.main.bounds.size.height).MAKE()
        collectionView.CENTER_X.EQUAL(view).MAKE()
        collectionView.BOTTOM.EQUAL(view).MAKE()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoViewerViewController.tap(_:)))
        view.addGestureRecognizer(tap)
        
        view.addSubview(pageControl)
        pageControl.isHidden = true
        pageControl.IN(view).BOTTOM(50).CENTER.MAKE()
        
        setupNavBackBlackButton(nil)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePage()
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isTapBackMode {
            hideBars = true
            _ = preferredStatusBarUpdateAnimation
            navigationController?.setNavigationBarHidden(hideBars, animated: true)
        }
    }
    
    func updatePage() {
        let item = items[currentIndex]
        title = "(\(currentIndex + 1)/\(items.count))"
        pageControl.numberOfPages = items.count
        pageControl.currentPage = currentIndex
        //pageLabel.text = "(\(currentIndex + 1)/\(items.count))"
        pageControl.isHidden = !isTapBackMode
        if items.count == 1 {
            pageControl.isHidden = true
        }
        
        if isSelectModel {
            if item.select {
                setupRightNavItems(items: selectItem)
            } else {
                setupRightNavItems(items: disSelectItem)
            }
        } else {
            removeRightNavItems()
        }
        var arr = [Image]()
        for item in items {
            if item.select {
                arr.append(item.image)
            }
        }
        respondImages?(arr)
    }
    
    var hideBars: Bool = false
    func tap(_ recognizer: UITapGestureRecognizer) {
        
        if isTapBackMode {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        hideBars = !hideBars
        _ = preferredStatusBarUpdateAnimation
        navigationController?.setNavigationBarHidden(hideBars, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return hideBars
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewerCell", for: indexPath) as! PhotoViewerCell
        cell.item = items[indexPath.item]
        cell.respondSaveImage = { [weak self] image in
            Confirmer.show("保存图片", message: "保存图片？", confirm: "保存", confirmHandler: { [weak self] in
                self?.saveImage(image)
            }, cancel: "取消", cancelHandler: nil, inVc: self)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let deltaX = scrollView.contentOffset.x
        let idx = Int(deltaX / (UIScreen.main.bounds.size.width + 20))
        currentIndex = idx
        updatePage()
    }
    
    func saveImage(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if success {
                QXTiper.showSuccess("保存成功", inView: self.view, cover: true)
            } else {
                QXTiper.showFailed("保存失败", inView: self.view, cover: true)
            }
        })
    }
    
}

class PhotoViewerItem: NSObject {
    var image: Image
    var select: Bool
    required init(image: Image, select: Bool) {
        self.image = image
        self.select = select
    }
    
    var progress: CGFloat = 0
}

class PhotoViewerCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var respondSaveImage: ((_ image: UIImage) -> ())?
    
    lazy var percentageLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 15)
        return one
    }()
    
    var item: PhotoViewerItem? {
        didSet {
            if let item = item {
                
                if let icon = item.image.localThumbName {
                    let image = UIImage(named: icon)
                    photoView.image = image
                    fixImageSize()
                }
                if let image = item.image.image {
                    photoView.image = image
                    fixImageSize()
                }
                
                // 获取缩略图
                if let thumbUrl = item.image.thumUrl {
                    photoView.setFullPath(thumbUrl, done: { [weak self] in
                        self?.fixImageSize()
                        
                        // 获取原图
                        if let url = self?.item?.image.url {
                            if let url = URL(string: url) {
                                SDWebImageManager.shared().downloadImage(with: url, options: .highPriority, progress: { [weak self] (rec, total) in
                                    if total > 0 {
                                        item.progress = CGFloat(rec) / CGFloat(total)
                                    } else {
                                        item.progress = 1
                                    }
                                    self?.updateProgress()
                                    
                                }, completed: { [weak self] (image, _, _, _, _) in
                                    if let image = image {
                                        self?.photoView.image = image
                                        self?.fixImageSize()
                                        item.progress = 1
                                        self?.updateProgress()
                                    }
                                })
                            }
                        }
                    })
                }
                
            }
            
            self.updateProgress()
            
        }
    }
    
    func updateProgress() {
        
        if let item = self.item {
            percentageLabel.isHidden = item.progress >= 1
            percentageLabel.text = "\(Int(item.progress * 100))%"
        } else {
            percentageLabel.isHidden = true
        }
        
    }
    
    func fixImageSize() {
        
        if let image = photoView.image {
            var w: CGFloat = 0
            var h: CGFloat = 0
            var x: CGFloat = 0
            var y: CGFloat = 0
            
            let winSize = UIScreen.main.bounds.size
            let imgSize = image.size
            
            if imgSize.width <= 0 || imgSize.height <= 0 {
                photoView.frame = CGRect.zero
                scrollView.contentSize = CGSize.zero
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                scrollView.maximumZoomScale = 0
                return
            }
            
            let k = winSize.width / winSize.height
            let k1 = imgSize.width / imgSize.height
            
            if (k > k1) {
                h = winSize.height
                w = h * k1
                x = (winSize.width - w) / 2
                y = 0
            } else {
                w = winSize.width
                h = w / k1
                x = 0
                y = (winSize.height - h) / 2
            }
            
            photoView.frame = CGRect(x: 0, y: 0, width: w, height: h)
            scrollView.contentSize = CGSize(width: w, height: h)
            scrollView.contentInset = UIEdgeInsetsMake(y, x, 0, 0)
            scrollView.maximumZoomScale = 3 * imgSize.width * imgSize.height / 1000 * 1000
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let one = UIScrollView()
        one.maximumZoomScale = 2.0
        one.minimumZoomScale = 1.0
        one.delegate = self
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.backgroundColor = UIColor.clear
        return one
    }()
    lazy var photoView: ImageView = ImageView(type: .none)
    
    lazy var selectIconView: UIImageView = {
        let one = UIImageView()
        return one
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.addSubview(photoView)
        scrollView.IN(contentView).LEFT(10).RIGHT(10).TOP.BOTTOM.MAKE()
        photoView.addSubview(percentageLabel)
        percentageLabel.IN(photoView).CENTER.MAKE()
        
//        let lng = UILongPressGestureRecognizer(target: self, action: #selector(PhotoViewerCell.long(_:)))
//        scrollView.addGestureRecognizer(lng)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func long(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .ended {
            if let image = photoView.image {
                self.respondSaveImage?(image)
            }
        }
    }
    
    //MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let view = view {
            var offsetX = (scrollView.bounds.size.width - view.frame.size.width) * 0.5
            if (offsetX < 0) {
                offsetX = 0;
            }
            var offsetY = (scrollView.bounds.size.height - view.frame.size.height) * 0.5
            if (offsetY < 0) {
                offsetY = 0;
            }
            scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
        }
    }
    
}
