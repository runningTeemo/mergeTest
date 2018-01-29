//
//  PublishActivityViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PublishActivityViewController: StaticCellBaseViewController {

    weak var vcBefore: ArticleMainViewControler?
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var nameItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "活动名称(必填项)"
        one.title = "活动名称"
        return one
    }()
    
    lazy var peopleCountItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "参加人数(必填项)"
        one.title = "人数"
        one.units = "人"
        one.keyboardTyle = .numberPad
        return one
    }()
    
    lazy var beginTimeItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.showBottomLine = true
        one.title = "开始时间"
        one.placeHolder = "活动开始时间(必填项)"
        one.maxCharCount = 99
        let datePicker = DateTimePickerView()
        datePicker.type = .dateAndTime
        datePicker.responder = { [unowned one] date in
            one.text = DateTool.getDateTimeShortString(date)
            one.updateCell?()
        }
        one.customKeyboard = datePicker
        return one
    }()
    
    lazy var endTimeItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.title = "结束时间"
        one.placeHolder = "活动结束时间(必填项)"
        one.maxCharCount = 99
        let datePicker = DateTimePickerView()
        datePicker.type = .dateAndTime
        datePicker.responder = { [unowned one] date in
            one.text = DateTool.getDateTimeShortString(date)
            one.updateCell?()
        }
        one.customKeyboard = datePicker
        return one
    }()
    
    lazy var venuesItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "活动场馆(必填项)"
        one.title = "场馆"
        return one
    }()

    lazy var cityItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 14)
        one.subTitleColor = HEX("#333333")
        one.showBottomLine = true
        one.title = "城市"
        one.responder = { [unowned self] in
            let vc = LocationPickerMainViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.respondCity = { [unowned self, unowned vc, unowned one] name in
                one.subTitle = name
                self.tableView.reloadData()
            }
            let nav = RootNavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        return one
    }()
    
    lazy var adressItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "详细地址(必填项)"
        one.title = "地址"
        return one
    }()
    
    lazy var linkItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrBlue
        one.maxCharCount = 99
        one.showBottomLine = false
        one.placeHolder = "活动相关网址(完整)"
        one.title = "报名链接"
        one.text = "http://"
        one.keyboardTyle = .asciiCapable
        one.disableAutoCorect = true
        return one
    }()

    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var textItem: StaticCellTextViewItem = {
        let one = StaticCellTextViewItem()
        one.title = "活动简介"
        one.holderText = "活动简介"
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
        one.tip = "添加活动图片"
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
        return one
    }()
    
    lazy var whiteSpaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 20
        one.color = UIColor.white
        return one
    }()
    
    lazy var spaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var hornItem: StaticHornItem = {
        let one = StaticHornItem()
        one.responder = { [unowned self] in
            let vc = UseHornViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            vc.respondHorn = { [unowned self, unowned one] horn in
                one.horn = horn
                self.tableView.reloadData()
            }
        }
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "发布", responder: { [unowned self] in
            self.handleSave()
        })
        return one
    }()
    lazy var loadingNavItem: BarButtonItem = {
        let one = BarButtonItem(indicatorStyle: .gray)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StaticHornCell.self, forCellReuseIdentifier: "StaticHornCell")

        title = "发布活动"
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
        
        staticItems = [topSpaceItem, nameItem, peopleCountItem, beginTimeItem, endTimeItem, venuesItem, cityItem, adressItem, linkItem, spaceItem1, textItem, whiteSpaceItem1, imagesItem, whiteSpaceItem2, spaceItem2, hornItem, bottomSpaceItem]

        setupRightNavItems(items: saveNavItem)
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if let city = LocationDataEntry.sharedOne.currentCity {
            cityItem.subTitle = city.name
        }
        tableView.reloadData()
        
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            MyselfManager.shareInstance.getHornCount(me, success: { [weak self] code, msg, data in
                if code == 0 {
                    let n = data
                    self?.hornItem.hornCount = n
                    self?.tableView.reloadData()
                }
            }, failed: { err in
            })
        }

    }
    
    func handleBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func handleSave() {
        view.endEditing(true)

        if NullText(nameItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(nameItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(peopleCountItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(peopleCountItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(beginTimeItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(beginTimeItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(endTimeItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(endTimeItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(venuesItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(venuesItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(cityItem.subTitle) {
            QXTiper.showWarning("请选择\(SafeUnwarp(cityItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(adressItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(adressItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(linkItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(linkItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.setupRightNavItems(items: self?.loadingNavItem)

            let wait = QXTiper.showWaiting("发布中...", inView: self?.view, cover: true)
            self?.sendRequest({ [weak self] in
                QXTiper.hideWaiting(wait)
                self?.setupRightNavItems(items: self?.saveNavItem)
            })
        }
        
    }
    
    
    func sendRequest(_ done: @escaping (() -> ())) {
        
        if !Account.sharedOne.isLogin {
            done()
            return
        }
        let me = Account.sharedOne.user
        let imgs = imagesItem.images

        let attachment = ArticleActivityAttachments()
        attachment.name = nameItem.text
        attachment.peopleCount = (peopleCountItem.text as NSString?)?.integerValue
        attachment.startTime = DateTool.dateTimeShort(beginTimeItem.text)
        attachment.endTime = DateTool.dateTimeShort(endTimeItem.text)
        attachment.venue = venuesItem.text
        attachment.city = cityItem.subTitle
        attachment.address = adressItem.text
        attachment.registrationLink = linkItem.text
        attachment.descri = textItem.text
                
        if imgs.count > 0 {
            
            ArticleManager.shareInstance.uploadImages(me, images: imgs, success: { [weak self] (code, msg, pictures) in
                if code == 0 {
                    ArticleManager.shareInstance.publishActivity(me, attachments: attachment, pics: pictures, horn: self?.hornItem.horn, success: { [weak self] (code, message, ret) in
                        if code == 0 {
                            QXTiper.showSuccess("发布成功", inView: self?.view, cover: true)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                                _ = self?.navigationController?.popViewController(animated: true)
                                self?.vcBefore?.performRefresh()
                            }
                        } else {
                            QXTiper.showWarning(message, inView: self?.view, cover: true)
                        }
                        done()
                    }) { [weak self] (error) in
                        done()
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                    }
                } else {
                    done()
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
            }) { [weak self] (error) in
                done()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
            
        } else {
            ArticleManager.shareInstance.publishActivity(me, attachments: attachment, pics: nil, horn: self.hornItem.horn, success: { [weak self] (code, message, ret) in
                if code == 0 {
                    QXTiper.showSuccess("发布成功", inView: self?.view, cover: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                        _ = self?.navigationController?.popViewController(animated: true)
                        self?.vcBefore?.performRefresh()
                    }
                } else {
                    QXTiper.showWarning(message, inView: self?.view, cover: true)
                }
                done()
            }) { [weak self] (error) in
                done()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
        }
        
    }

}
