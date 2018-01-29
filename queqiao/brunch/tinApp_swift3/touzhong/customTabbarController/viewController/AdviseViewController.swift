//
//  AdviseViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/7.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class AdviseViewController: StaticCellBaseViewController {
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var textItem: StaticCellTextViewItem = {
        let one = StaticCellTextViewItem()
        one.holderText = "请描述具体问题或建议"
        one.showBottomLine = false
        return one
    }()
    
    lazy var whiteSpaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 20
        one.color = UIColor.white
        return one
    }()
    
    lazy var imagesItem: StaticCellImagesPickerItem = {
        let one = StaticCellImagesPickerItem()
        one.tip = "添加图片"
        one.respondAdd = { [unowned self, unowned one] maxCount in
            ActionSheet.show(nil, actions: [
                ("拍照", { [unowned self, unowned one] in
                    MediaTool.sharedOne.showCamera(edit: false, inVc: self)
                    MediaTool.sharedOne.pixelLimt = 1000 * 1000
                    MediaTool.sharedOne.respondImage = { image in
                        one.images.append(image)
                        one.updateCell?()
                        self.tableView.reloadData()
                    }
                }),
                ("图片库", { [unowned self, unowned one] in
                    AlbumPhotoShowMutiSelect(self, maxCount: maxCount, responder: { [unowned self, unowned one] (images) in
                        one.images += images
                        one.updateCell?()
                        self.tableView.reloadData()
                    })
                }),
                ], inVc: self)
        }
        one.respondSelectImage = { [unowned self, unowned one] idx in
            let vc = PhotoViewerViewController()
            var items: [PhotoViewerItem] = [PhotoViewerItem]()
            for image in one.images {
                let img = Image()
                img.image = image
                let item = PhotoViewerItem(image: img, select: true)
                items.append(item)
            }
            vc.items = items
            vc.currentIndex = idx
            vc.isSelectModel = true
            vc.respondImages = { [unowned self, unowned one] images in
                var imgs = [UIImage]()
                for image in images {
                    if let i = image.image {
                        imgs.append(i)
                    }
                }
                one.images = imgs
                one.updateCell?()
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.showBottomLine = false
        return one
    }()
    
    lazy var whiteSpaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 20
        one.color = UIColor.white
        one.showBottomLine = true
        return one
    }()
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var contactItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.placeHolder = "选填，便于我们与您联系"
        one.title = "联系方式"
        return one
    }()

    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    
    lazy var summitNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "提交", responder: { [unowned self] in
            self.handleSave()
        })
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StaticHornCell.self, forCellReuseIdentifier: "StaticHornCell")
        
        title = "意见反馈"
        setupNavBackBlackButton(nil)
        
        staticItems = [topSpaceItem, textItem, whiteSpaceItem1, imagesItem, whiteSpaceItem2, spaceItem, contactItem, bottomSpaceItem]
        
        setupRightNavItems(items: summitNavItem)
    }
    
    func handleSave() {
        QXTiper.showWarning("暂未开通", inView: view, cover: true)
    }
    
}
