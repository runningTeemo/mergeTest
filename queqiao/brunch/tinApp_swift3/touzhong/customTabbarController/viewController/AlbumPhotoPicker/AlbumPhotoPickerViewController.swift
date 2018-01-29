//
//  AlbumPhotoPickerViewController.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/7.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

private let kMargin: CGFloat = 5
private let kItemSize: CGSize = {
    let rowCount: Int = 4
    let itemWidth = (UIScreen.main.bounds.size.width - kMargin * CGFloat(rowCount + 1)) / CGFloat(rowCount)
    return CGSize(width: itemWidth, height: itemWidth)
}()

class AlbumPhotoPickerViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: bussiness
    var albumResult: AlbumReslut!
    var responder: ((_ images: [UIImage]) -> ())?
    var maxSelectCount: Int = 9
    var operateType: AlbumPhotoOperateType = .mutiSelect
    var pixelLimt: CGFloat?
    var startIdx: Int = Int.max
    
    fileprivate lazy var models: [AlbumPhoto] = {
        var one = [AlbumPhoto]()
        if let fetchResults = self.albumResult.album {
            fetchResults.enumerateObjects({ (result, idx, stop) in
                let model = AlbumPhoto()
                model.asset = result as! PHAsset
                one.append(model)
            })
        }
        return one.reversed() // 倒序
    }()
    
    func cancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func previewBtnClick() {
        let vc = AlbumPhotoPreviewViewController()
        vc.responder = responder
        vc.maxSelectCount = maxSelectCount
        vc.pixelLimt = pixelLimt
        vc.models = models
        vc.operateType = operateType
        vc.startIdx = startIdx
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func confirmBtnClick() {
        view.isUserInteractionEnabled = false
        AlbumPhotoHelper.getSelectImages(models, limit: pixelLimt) { (images) in
            self.responder?(images)
            self.view.isUserInteractionEnabled = true
            self.cancelBtnClick()
        }
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        collectionView.reloadData()
        updateBottomView()
    }
    
    //MARK: setup views
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
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.itemSize = kItemSize
        one.minimumLineSpacing = kMargin
        one.minimumInteritemSpacing = kMargin
        one.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin + 44, kMargin)
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
       let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.dataSource = self
        one.delegate = self
        one.backgroundColor = UIColor.black
        one.register(AlbumPhotoPickerCell.self, forCellWithReuseIdentifier: "AlbumPhotoPickerCell")
        return one
    }()
    fileprivate lazy var bottomView: AlbumPhotoPickerBottomView = {
        let one = AlbumPhotoPickerBottomView()
        one.previewBtn.addTarget(self, action: #selector(AlbumPhotoPickerViewController.previewBtnClick), for: .touchUpInside)
        one.confirmBtn.addTarget(self, action: #selector(AlbumPhotoPickerViewController.confirmBtnClick), for: .touchUpInside)
        return one
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        collectionView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        bottomView.IN(view).LEFT.RIGHT.BOTTOM.HEIGHT(44).MAKE()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelBtn)
        setupNavBackBlackButton(nil)
    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumPhotoPickerCell", for: indexPath) as! AlbumPhotoPickerCell
        let model = models[indexPath.item]
        cell.model = model
        cell.icon = nil
        cell.isSingleModel = !(self.operateType == .mutiSelect)
        AlbumPhotoHelper.asycGetThumbImage(model, size: kItemSize) { (image) in
            if let id = cell.id {
                if id == model.asset.localIdentifier {
                    cell.icon = image
                }
            } else {
                cell.icon = image
            }
        }
        cell.id = model.asset.localIdentifier
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = models[indexPath.item]
        
        switch operateType {
        case .mutiSelect:
            if !model.select && bottomView.pickCount == maxSelectCount {
                QXTiper.showWarning("最多只能选择\(maxSelectCount)张", inView: view, cover: true)
            } else {
                model.select = !model.select
                collectionView.reloadItems(at: [indexPath])
                updateBottomView()
            }
            
        case .singleSelect:
            for model in models {
                model.select = false
            }
            model.select = true
            updateBottomView()
            let vc = AlbumPhotoPreviewViewController()
            vc.responder = responder
            vc.models = models
            vc.operateType = operateType
            vc.pixelLimt = pixelLimt
            vc.startIdx = indexPath.item
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .singleSelectAndEdit:
            let vc = AlbumPhotoEditViewController()
            vc.model = model
            vc.pixelLimt = pixelLimt
            vc.responder = responder
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: helper

    fileprivate func updateBottomView() {
        var count: Int = 0
        var idx: Int = 0
        startIdx = Int.max
        for model in models {
            if model.select {
                startIdx = min(idx, startIdx)
                count += 1
            }
            idx += 1
        }
        bottomView.pickCount = count
        switch operateType {
        case .mutiSelect:
            bottomView.isHidden = false
        default:
            bottomView.isHidden = true
        }
    }
    
}

class AlbumPhotoPickerCell: UICollectionViewCell {
    
    var id: String?
    
    //MARK: bussiness
    var model: AlbumPhoto? {
        didSet {
            if let model = model {
                if model.select {
                    selectView.image = UIImage(named: "photo_select")
                    coverView.isHidden = false
                } else {
                    selectView.image = UIImage(named: "photo_select_dis")
                    coverView.isHidden = true
                }
            }
        }
    }
    var icon: UIImage? {
        didSet {
            iconView.image = icon
        }
    }
    
    var isSingleModel: Bool = false {
        didSet {
            selectView.isHidden = isSingleModel
        }
    }

    //MARK: setup views
    fileprivate lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        one.backgroundColor = UIColor.gray
        one.clipsToBounds = true
        one.contentMode = .scaleAspectFill
        return one
    }()
    fileprivate lazy var coverView: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor.white
        one.alpha = 0.3
        one.isHidden = true
        one.isUserInteractionEnabled = false
        return one
    }()
    fileprivate lazy var selectView: ImageView = {
        let one = ImageView(type: .image)
        return one
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconView)
        contentView.addSubview(coverView)
        contentView.addSubview(selectView)
        iconView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        coverView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        selectView.IN(contentView).TOP(5).RIGHT(5).SIZE(20, 20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

