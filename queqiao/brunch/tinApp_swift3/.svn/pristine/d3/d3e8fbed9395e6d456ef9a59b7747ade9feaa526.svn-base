//
//  PublishBaGuaViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/24.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PublishBaGuaViewController: StaticCellBaseViewController {
    
    weak var vcBefore: ArticleMainViewControler?
    var currentIndustry: Industry?
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var textItem: StaticCellTextViewItem = {
        let one = StaticCellTextViewItem()
        one.holderText = "说点什么吧..."
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
    
    lazy var industryItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 14)
        one.subTitleColor = HEX("#333333")
        one.showBottomLine = false
        one.title = "发布到行业"
        one.responder = { [unowned self] in
            let vc = IndustryPickerViewController()
            vc.mutiMode = false
            vc.hidesBottomBarWhenPushed = true
            if let industry = self.currentIndustry {
                vc.pickOnesOnInit = [industry]
            }
            vc.respondIndustries = { [unowned self, unowned vc, unowned one] industries in
                self.currentIndustry = nil
                if let industry = industries.first {
                    one.subTitle = industry.name
                    self.currentIndustry = industry
                }
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        return one
    }()
    
    lazy var middleSpaceItem: StaticCellSpaceItem = {
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

        title = "发布八卦"
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
//        staticItems = [topSpaceItem, textItem, whiteSpaceItem1, imagesItem, whiteSpaceItem2, industryItem, middleSpaceItem, hornItem, bottomSpaceItem]
        staticItems = [topSpaceItem, textItem, whiteSpaceItem1, imagesItem, whiteSpaceItem2, industryItem, bottomSpaceItem]

        setupRightNavItems(items: saveNavItem)
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if !Account.sharedOne.isLogin { return }
        currentIndustry = Account.sharedOne.user.industry
        if let t = currentIndustry?.name {
            industryItem.subTitle = t
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
        if NotNull(textItem.text) || imagesItem.images.count > 0 {
            Confirmer.show("返回确认", message: "返回将不会保存，确认返回？", confirm: "返回", confirmHandler: { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
                }, cancel: "继续修改", cancelHandler: {
            }, inVc: self)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }

    func handleSave() {
        view.endEditing(true)
        
        if currentIndustry == nil {
            QXTiper.showWarning("请选择发布行业", inView: self.view, cover: true)
            return;
        }
        if NullText(textItem.text) && imagesItem.images.count == 0 {
            QXTiper.showWarning("内容不能为空", inView: self.view, cover: true)
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
        let industry = currentIndustry!
        let imgs = imagesItem.images
        let content = textItem.text
        
        if imgs.count > 0 {
            
            ArticleManager.shareInstance.uploadImages(me, images: imgs, success: { [weak self] (code, msg, pictures) in
                if code == 0 {
                    ArticleManager.shareInstance.publishBaGua(me, indusrty: industry, content: content, pics: pictures, horn: self?.hornItem.horn, success: { [weak self] (code, message, ret) in
                        if code == 0 {
                            QXTiper.showSuccess("发布成功", inView: self?.view, cover: true)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                                _ = self?.navigationController?.popViewController(animated: true)
                                self?.vcBefore?.performRefresh()
                            }
                        } else {
                            QXTiper.showWarning(msg, inView: self?.view, cover: true)
                        }
                        done()
                    }) { [weak self] (error) in
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        done()
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
            ArticleManager.shareInstance.publishBaGua(me, indusrty: industry, content: content, pics: nil, horn: self.hornItem.horn, success: { [weak self] (code, message, ret) in
                if ret {
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
