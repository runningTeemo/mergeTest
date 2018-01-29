//
//  StaticCellImagesPicker.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/23.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellImagesPickerItem: StaticCellBaseItem {
    
    var itemSize: CGSize = CGSize(width: 80, height: 80)
    var itemMarginX: CGFloat = 10
    var itemMarginY: CGFloat = 10
    
    var respondAdd: ((_ maxCount: Int) -> ())?
    var respondSelectImage: ((_ idx: Int) -> ())?
    
    var images: [UIImage] = [UIImage]()
    
    var title: String?
    
    var tip: String?
    
    override init() {
        super.init()
        cellHeight = 80
    }
}

class StaticCellImagesImagesModel {
    var image: UIImage?
    var isAddType: Bool
    init(isAddType: Bool) {
        self.isAddType = isAddType
    }
}

class StaticCellImagesPickerCell: StaticCellBaseCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellImagesPickerItem {

            flowLayout.minimumLineSpacing = item.itemMarginY
            flowLayout.minimumInteritemSpacing = item.itemMarginX
            flowLayout.itemSize = item.itemSize
            tipLabel.text = item.tip
            
            var models = [StaticCellImagesImagesModel]()
            for image in item.images {
                let model = StaticCellImagesImagesModel(isAddType: false)
                model.image = image
                models.append(model)
            }
            self.models = models
            
            item.cellHeight = flowLayout.collectionViewContentSize.height
            tipLabel.isHidden = models.count > 0
            collectionView.reloadData()

        }
    }
    
    func getImages() -> [UIImage] {
        var imgs = [UIImage]()
        for model in models {
            if model.isAddType == false {
                if let img = model.image {
                    imgs.append(img)
                }
            }
        }
        return imgs
    }
    
    var models: [StaticCellImagesImagesModel] = [StaticCellImagesImagesModel]()
    lazy var addModel: StaticCellImagesImagesModel = {
        let one = StaticCellImagesImagesModel(isAddType: true)
        return one
    }()

    lazy var tipLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrLightGray
        one.font = UIFont.systemFont(ofSize: 14)
        one.text = "添加图片"
        return one
    }()
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.minimumInteritemSpacing = 10
        one.minimumLineSpacing = 10
        one.itemSize = CGSize(width: 80, height: 80)
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect(x: 0, y: 0, width: 999, height: 999), collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = false
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(StaticCellImagesPickerCellInnerCell.self, forCellWithReuseIdentifier: "StaticCellImagesPickerCellInnerCell")
        return one
    }()
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if models.count < 9 {
            return models.count + 1
        }
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StaticCellImagesPickerCellInnerCell", for: indexPath) as! StaticCellImagesPickerCellInnerCell
        if models.count < 9 {
            if indexPath.item < models.count {
                cell.model = models[indexPath.item]
            } else {
                cell.model = addModel
            }
        } else {
            cell.model = models[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var model: StaticCellImagesImagesModel
        if models.count < 9 {
            if indexPath.item < models.count {
                model = models[indexPath.item]
            } else {
                model = addModel
            }
        } else {
            model = models[indexPath.item]
        }
        if model.isAddType {
            let maxCount = 9 - self.models.count
            (item as? StaticCellImagesPickerItem)?.respondAdd?(maxCount)
        } else {
            (item as? StaticCellImagesPickerItem)?.respondSelectImage?(indexPath.item)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.addSubview(tipLabel)
        collectionView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP.BOTTOM.MAKE()
        tipLabel.IN(contentView).LEFT(100).TOP(30).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StaticCellImagesPickerCellInnerCell: UICollectionViewCell {
    var model: StaticCellImagesImagesModel! {
        didSet {
            if model.isAddType {
                iconView.image = UIImage(named: "iconImageUpload")
            } else {
                iconView.image = model.image
            }
        }
    }
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.contentMode = .scaleAspectFill
        return one
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconView)
        iconView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

