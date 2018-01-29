//
//  ProjectBriefEditViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/9.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class ProjectBriefEditViewController: StaticCellBaseViewController {
    
    var placeHolder: String?
    var text: String?
    var images: [UIImage] = [UIImage]()
    var respondTextOrImages: ((_ text: String?, _ images: [UIImage]) -> ())?
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var textItem: StaticCellCountTextViewItem = {
        let one = StaticCellCountTextViewItem()
        one.holderText = "项目的特点"
        one.maxCharCount = 300
        one.cellHeight = 200
        return one
    }()
    
    lazy var imagesItem: StaticCellImagesPickerItem = {
        let one = StaticCellImagesPickerItem()
        one.tip = "添加项目图片"
        one.respondAdd = { [unowned self, unowned one] maxCount in
            ActionSheet.show(nil, actions: [
                ("拍照", { [unowned self, unowned one] in
                    MediaTool.sharedOne.showCamera(edit: false, inVc: self)
                    MediaTool.sharedOne.pixelLimt = 1000 * 1000
                    MediaTool.sharedOne.respondImage = { image in
                        one.images.append(image)
                        one.updateCell?()
                        self.images = one.images
                        self.tableView.reloadData()
                    }
                }),
                ("图片库", { [unowned self, unowned one] in
                    AlbumPhotoShowMutiSelect(self, maxCount: maxCount, responder: { [unowned self, unowned one] (images) in
                        one.images += images
                        one.updateCell?()
                        self.images = one.images
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
                self.images = one.images
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var whiteSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 20
        one.color = UIColor.white
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "确定", responder: { [unowned self] in
            self.handleSave()
        })
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StaticHornCell.self, forCellReuseIdentifier: "StaticHornCell")
        tableView.register(StaticCellImagesPickerCell.self, forCellReuseIdentifier: "StaticCellImagesPickerCell")

        staticItems = [topSpaceItem, textItem, imagesItem, whiteSpaceItem, bottomSpaceItem]
        setupRightNavItems(items: saveNavItem)
        
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        textItem.holderText = placeHolder
        textItem.text = text
        imagesItem.images = images
        imagesItem.updateCell?()
        tableView.reloadData()
    }
    
    override func onFirstAppear() {
        super.onFirstAppear()
        textItem.holderText = placeHolder
        textItem.text = text
        imagesItem.images = images
        imagesItem.updateCell?()
        tableView.reloadData()
    }

    func handleBack() {
        if self.editChanged {
            Confirmer.show("返回确认", message: "返回将不会保存，确认返回？", confirm: "返回", confirmHandler: { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
                }, cancel: "继续修改", cancelHandler: {
            }, inVc: self)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleSave() {
        if NotNullText(textItem.text) {
            _ = self.navigationController?.popViewController(animated: true)
            self.respondTextOrImages?(textItem.text, images)
        } else {
            QXTiper.showWarning(SafeUnwarp(title, holderForNull: "") + "不能为空", inView: self.view, cover: true)
        }
    }
    
}
