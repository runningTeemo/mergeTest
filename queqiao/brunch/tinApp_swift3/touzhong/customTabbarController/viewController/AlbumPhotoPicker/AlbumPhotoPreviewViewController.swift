//
//  AlbumPhotoPreviewViewController.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/7.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class AlbumPhotoPreviewViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: bussiness
    var responder: ((_ images: [UIImage]) -> ())?
    var maxSelectCount: Int = 9
    var operateType: AlbumPhotoOperateType = .mutiSelect
    var pixelLimt: CGFloat?
    var startIdx: Int = Int.max {
        didSet {
            currentIdx = startIdx
        }
    }
    
    fileprivate var currentIdx: Int = 0
    var models: [AlbumPhoto]!
    
    var hideBars: Bool = false
    func tap(_ recognizer: UITapGestureRecognizer) {
        hideBars = !hideBars
        _ = preferredStatusBarUpdateAnimation
        navigationController?.setNavigationBarHidden(hideBars, animated: true)
        bottomView.isHidden = hideBars
    }
    
    override var prefersStatusBarHidden : Bool {
        return hideBars
    }
    
    func selectBtnClick() {
        let model = models[currentIdx]
        switch operateType {
        case .mutiSelect:
            if model.select == false && bottomView.pickCount == maxSelectCount {
                QXTiper.showWarning("最多只能选择\(maxSelectCount)张", inView: view, cover: true)
            } else {
                model.select = !model.select
            }
        default:
            let lastStatus = model.select
            for model in models {
                model.select = false
            }
            model.select = !lastStatus
        }
        updateBars()
    }
    
    func cancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func confirmBtnClick() {
        view.isUserInteractionEnabled = false
        AlbumPhotoHelper.getSelectImages(models, limit: pixelLimt) { (images) in
            self.responder?(images)
            self.view.isUserInteractionEnabled = true
            self.cancelBtnClick()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBars()
        let indexPath = IndexPath(item: currentIdx, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    //MARK: setup views
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = CGSize(width: UIScreen.main.bounds.size.width + 10 * 2, height: UIScreen.main.bounds.size.height)
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
        one.register(AlbumPhotoPreviewCell.self, forCellWithReuseIdentifier: "AlbumPhotoPreviewCell")
        return one
    }()
    fileprivate lazy var cancelBtn: UIButton = {
        let attriStr = NSAttributedString(string: "取消", attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: UIColor.black
            ])
        let one = UIButton(type: .system)
        one.setAttributedTitle(attriStr, for: UIControlState())
        one.addTarget(self, action: #selector(AlbumPhotoMainViewController.cancelBtnClick), for: .touchUpInside)
        one.sizeToFit()
        return one
    }()
    fileprivate lazy var bottomView: AlbumPhotoPreviewBottomView = {
        let one = AlbumPhotoPreviewBottomView()
        one.confirmBtn.addTarget(self, action: #selector(AlbumPhotoPickerViewController.confirmBtnClick), for: .touchUpInside)
        one.selectBtn.addTarget(self, action: #selector(AlbumPhotoPreviewViewController.selectBtnClick), for: .touchUpInside)
        return one
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 这个用于取消第二个scroll的自动insert
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.isHidden = true
        
        title = "图片预览"
        view.backgroundColor = UIColor.black
        view.addSubview(collectionView)
        collectionView.WIDTH.EQUAL(UIScreen.main.bounds.size.width + 10 * 2).MAKE()
        collectionView.HEIGHT.EQUAL(UIScreen.main.bounds.size.height).MAKE()
        collectionView.CENTER_X.EQUAL(view).MAKE()
        collectionView.BOTTOM.EQUAL(view).MAKE()
        
        view.addSubview(bottomView)
        bottomView.IN(view).LEFT.RIGHT.BOTTOM.HEIGHT(44).MAKE()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelBtn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AlbumPhotoPreviewViewController.tap(_:)))
        view.addGestureRecognizer(tap)
        
        setupNavBackBlackButton(nil)
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumPhotoPreviewCell", for: indexPath) as! AlbumPhotoPreviewCell
        let model = models[indexPath.item]
        // preload thumb image and wait for orgen image
        cell.image = nil
        AlbumPhotoHelper.asycGetThumbImage(model, size: CGSize(width: 100, height: 100)) { [weak self] (image) in
            if let id = cell.id {
                if id == model.asset.localIdentifier {
                    cell.image = image
                }
            } else {
                cell.image = image
            }
            if let s = self {
                AlbumPhotoHelper.asycGetImage(model, limit: s.pixelLimt, done: { (image) in
                    if let id = cell.id {
                        if id == model.asset.localIdentifier {
                            cell.image = image
                        }
                    } else {
                        cell.image = image
                    }
                })
            }
        }
        cell.id = model.asset.localIdentifier
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let deltaX = scrollView.contentOffset.x
        let idx = Int(deltaX / (UIScreen.main.bounds.size.width + 20))
        self.currentIdx = idx
        updateBars()
    }
    
    //MARK: helper
    fileprivate func updateBars() {
        title = "图片预览(\(currentIdx + 1)/\(models.count))"
        let model = models[currentIdx]
        bottomView.select = model.select
        
        var count: Int = 0
        for model in models {
            if model.select {
                count += 1
            }
        }
        bottomView.pickCount = count
        switch operateType {
        case .mutiSelect:
            bottomView.countLabel.isHidden = false
        default:
            bottomView.countLabel.isHidden = true
        }
    }
    
}

class AlbumPhotoPreviewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var id: String?
    
    //MARK: bussiness
    var image: UIImage? {
        didSet {
            photoView.image = image
            fixImageSize()
        }
    }
    
    //MARK: setup views
    fileprivate lazy var scrollView: UIScrollView = {
        let one = UIScrollView()
        one.maximumZoomScale = 2.0
        one.minimumZoomScale = 1.0
        one.delegate = self
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.backgroundColor = UIColor.clear
        return one
    }()
    fileprivate lazy var photoView: ImageView = ImageView(type: .image)
    fileprivate lazy var selectIconView: UIImageView = {
        let one = UIImageView()
        return one
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.addSubview(photoView)
        scrollView.IN(contentView).LEFT(10).RIGHT(10).TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: fixSize
    fileprivate func fixImageSize() {
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
                y = (winSize.height - h) * 0.5
            }
            
            photoView.frame = CGRect(x: 0, y: 0, width: w, height: h)
            scrollView.contentSize = CGSize(width: w, height: h)
            scrollView.contentInset = UIEdgeInsetsMake(y, x, 0, 0)
            scrollView.maximumZoomScale = 3 * imgSize.width * imgSize.height / 1000 * 1000
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
