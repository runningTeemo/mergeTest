//
//  MyCareerEditViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyCareerEditViewController: StaticCellBaseViewController {
    
    var career: Career?
    weak var vcBefore: MyCareerInfoViewController?
    var respondCareer: ((_ career: Career) -> ())?
    var respondDelete: ((_ career: Career) -> ())?
    
    var canDelete: Bool = true

    var organization: Organization?
    lazy var companyItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 16)
        one.subTitleColor = HEX("#333333")
        one.showBottomLine = true
        one.title = "公司"
        one.responder = { [unowned self, unowned one] in
            let vc = OrganizationPickerViewController()
            vc.type = .combine
            vc.initText = one.subTitle
            vc.hidesBottomBarWhenPushed = true
            vc.responder = { [unowned self, unowned vc, unowned one] organization in
                one.subTitle = organization.name
                self.organization = organization
                self.tableView.reloadData()
                self.editChanged = true
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var possitonItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.showBottomLine = true
        one.title = "职位"
        one.placeHolder = "职位(必填项)"
        one.maxCharCount = 99
        return one
    }()
    
    lazy var roleItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 16)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "身份(必填项)"
        one.title = "身份"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kUserRoleTypeKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var beginTimeItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.showBottomLine = true
        one.title = "开始时间"
        one.placeHolder = "入职时间(必填项)"
        one.maxCharCount = 99
        let datePicker = DateTimePickerView()
        datePicker.type = .date
        datePicker.responder = { [unowned one] date in
            one.text = DateTool.getCareerString(date)
            one.updateCell?()
        }
        one.customKeyboard = datePicker
        return one
    }()
    
    lazy var endTimeItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.title = "结束时间"
        one.text = "至今"
        one.placeHolder = "离职时间"
        one.maxCharCount = 99
        let datePicker = DateTimePickerView()
        datePicker.type = .date
        datePicker.responder = { [unowned one] date in
            one.text = DateTool.getCareerString(date)
            if let date = date {
                one.text = DateTool.getCareerString(date)
            } else {
                one.text = "至今"
            }
            one.updateCell?()
        }
        one.customKeyboard = datePicker
        return one
    }()
    
    lazy var cardTipItem: StaticCellTextItem = {
        let one = StaticCellTextItem()
        one.backColor = kClrBackGray
        one.textFont = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrNormalTxt
        one.topMargin = 17
        one.bottomMargin = 8
        one.text = "上传名片"
        one.update()
        return one
    }()
    lazy var cardAuthItem: MyCareerAuthorCardItem = {
        let one = MyCareerAuthorCardItem()
        one.respondPickImage = { [unowned self] in
            ActionSheet.show("选择图片", actions: [
                ("拍照", {
                    MediaTool.sharedOne.showCamera(edit: false, inVc: self)
                    MediaTool.sharedOne.pixelLimt = 1000 * 1000
                    MediaTool.sharedOne.respondImage = { [unowned self] image in
                        self.handleImage(image: image)
                    }
                    
                }),
                ("图片库选择", {
                    let vc = AlbumPhotoMainViewController()
                    vc.operateType = .singleSelect
                    vc.pixelLimt = 1000 * 1000
                    let nav = RootNavigationController(rootViewController: vc)
                    self.present(nav, animated: true) {
                        
                    }
                    vc.responder = { [unowned self] images in
                        if images.count > 0 {
                            self.handleImage(image: images.first!)
                        }
                    }
                })
                ], inVc: self)
        }
        return one
    }()
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 20
        one.color = kClrBackGray
        return one
    }()
    
    lazy var deleteItem: StaticCellTextButtonItem = {
        let one = StaticCellTextButtonItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "删除"
        one.responder = { [unowned self] in
            self.handleDelete()
        }
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "保存", responder: { [unowned self] in
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
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
        setupRightNavItems(items: saveNavItem)

        tableView.register(MyCareerAuthorCardCell.self, forCellReuseIdentifier: "MyCareerAuthorCardCell")
        staticItems = [companyItem, possitonItem, roleItem, beginTimeItem, endTimeItem, cardTipItem, cardAuthItem, bottomSpaceItem]
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        /// 编辑模式
        if let career = career {
            title = "编辑工作经历"
            
            if let company = career.company {
                companyItem.subTitle = company
                let organization = Organization()
                organization.name = company
                organization.id = career.companyId
                organization.type = career.companyType
                self.organization = organization
            }
            
            possitonItem.text = career.possition
            roleItem.text = TinSearch(code: career.userRoleType, inKeys: kUserRoleTypeKeys)?.name
            beginTimeItem.text = DateTool.getCareerString(career.startDate)
            if let date = career.endDate {
                endTimeItem.text = DateTool.getCareerString(date)
            } else {
                endTimeItem.text = "至今"
            }
            
            cardAuthItem.url = career.cardImage
            cardAuthItem.thumbUrl = career.thumbCardImage
            cardAuthItem.authorStatus = career.authorStatus
            
            staticItems = [companyItem, possitonItem, roleItem, beginTimeItem, endTimeItem, cardTipItem, cardAuthItem, spaceItem, deleteItem, bottomSpaceItem]
            if canDelete {
                if let s = career.authorStatus {
                    if s == .progressing || s == .isAuthed {
                        staticItems = [companyItem, possitonItem, roleItem, beginTimeItem, endTimeItem, cardTipItem, cardAuthItem, bottomSpaceItem]
                    }
                }
            }
            tableView.reloadData()
        } else {
            title = "新增工作经历"
            staticItems = [companyItem, possitonItem, roleItem, beginTimeItem, endTimeItem, cardTipItem, cardAuthItem, bottomSpaceItem]
            tableView.reloadData()
        }
        
        showNav()
    }
    
    func handleSave() {
        let career: Career = self.career != nil ? self.career! : Career()
        career.company = organization?.name
        career.companyId = organization?.id
        career.companyType = organization?.type
        
        career.possition = possitonItem.text
        career.userRoleType = TinSearch(name: roleItem.text, inKeys: kUserRoleTypeKeys)?.code
        career.cardImage = cardAuthItem.url
        career.startDate = DateTool.carreerDate(beginTimeItem.text)
        career.endDate = nil
        if let str = endTimeItem.text {
            if str != "至今" {
                career.endDate = DateTool.carreerDate(str)
            }
        }
        
        career.cardImage = cardAuthItem.url
        career.thumbCardImage = cardAuthItem.thumbUrl
        
        view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            
            if NullText(career.company) {
                QXTiper.showWarning("公司不能为空", inView: self?.view, cover: true)
                return
            }
            if NullText(career.possition) {
                QXTiper.showWarning("职位不能为空", inView: self?.view, cover: true)
                return
            }
            if career.userRoleType == nil {
                QXTiper.showWarning("身份不能为空", inView: self?.view, cover: true)
                return
            }
            if career.startDate == nil {
                QXTiper.showWarning("起始时间不能为空", inView: self?.view, cover: true)
                return
            }
//            if endDate.characters.count == 0 {
//                QXTiper.showWarning("结束时间不能为空", inView: self?.view, cover: true)
//                return
//            }
            self?.saveCareer(career)

        }
        
    }
    
    func handleDelete() {
        if let career = career {
            Confirmer.show("删除确认", message: "你确定要删除该条记录？", confirm: "删除", confirmHandler: { [weak self] in
                self?.deleteCareer(career)
                }, cancel: "取消", cancelHandler: nil, inVc: self)
        }
    }
    
    func deleteCareer(_ career: Career) {
        let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
        MyselfManager.shareInstance.deleteCareer(SafeUnwarp(career.id, holderForNull: ""), success: { [weak self] (code, msg, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                QXTiper.showSuccess("删除成功", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                    self?.vcBefore?.clearFirstInStatus()
                    self?.respondDelete?(career)
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func saveCareer(_ career: Career) {
        
        if !editChanged {
            _ = navigationController?.popViewController(animated: true)
            return
        }

        view.isUserInteractionEnabled = false
        setupRightNavItems(items: loadingNavItem)

        MyselfManager.shareInstance.saveCareer(career, success: { [weak self] (code, msg, ret) in
            self?.view.isUserInteractionEnabled = true
            self?.setupRightNavItems(items: self?.saveNavItem)

            if code == 0 {
                QXTiper.showSuccess("保存成功", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    self?.editChanged = false
                    _ = self?.navigationController?.popViewController(animated: true)
                    self?.vcBefore?.clearFirstInStatus()
                    self?.respondCareer?(career)
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
            }) { [weak self] (error) in
                self?.setupRightNavItems(items: self?.saveNavItem)
                self?.view.isUserInteractionEnabled = true
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
    func handleImage(image: UIImage) {
        
        if !Account.sharedOne.isLogin { return }
        
        let user = Account.sharedOne.user
        MyselfManager.shareInstance.uploadCard(user, image: image, success: { [weak self] (code, msg, pic) in
            if code == 0 {
                let pic = pic!
                self?.cardAuthItem.url = pic.url
                self?.cardAuthItem.thumbUrl = pic.thumbUrl
                self?.tableView.reloadData()
                self?.editChanged = true
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.showWarning(kWebErrMsg + "(\(error.code))" , inView: self?.view, cover: true)
        }
    }
    
    func handleBack() {
        if editChanged {
            Confirmer.show("退出编辑", message: "退出界面将不会保存修改的内容，是否继续？", confirm: "取消编辑", confirmHandler: { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
                }, cancel: "继续编辑", cancelHandler: {
                }, inVc: self)
            
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}



class MyCareerAuthorCardItem: StaticCellBaseItem {
    
    var url: String?
    var thumbUrl: String?
    var authorStatus: Author?
    
    var respondPickImage: (() -> ())?
    
    override init() {
        super.init()
        cellHeight = 155
    }
}

class MyCareerAuthorCardCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? MyCareerAuthorCardItem {
            cardView.fullPath = item.thumbUrl
            
            addView.forceDown(false)
            if let author = item.authorStatus {
                switch author {
                case .progressing:
                    //addView.forceDown(true)
                    authImageView.isHidden = false
                    authImageView.image = UIImage(named: "workCheckPending")
                case .isAuthed:
                    authImageView.isHidden = false
                    authImageView.image = UIImage(named: "workChecked")
                case .failed:
                    authImageView.isHidden = false
                    authImageView.image = UIImage(named: "workCheckFail")
                default:
                    authImageView.isHidden = true
                    authImageView.image = nil
                }
            } else {
                authImageView.isHidden = true
            }
        }
    }
    
    lazy var indicator: UIActivityIndicatorView = {
        let one = UIActivityIndicatorView(activityIndicatorStyle: .white)
        one.hidesWhenStopped = true
        return one
    }()
    lazy var cardView: ImageView = {
        let one = ImageView(type: .card)
        one.contentMode = .scaleAspectFill
        return one
    }()
    lazy var authImageView: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "workCheckPending")
        return one
    }()
    lazy var addView: ImageButton = {
        let one = ImageButton()
        one.iconView.image = UIImage(named: "iconImageUpload")
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            if let item = self.item as? MyCareerAuthorCardItem {
                item.respondPickImage?()
            }
            })
        return one
    }()
    lazy var tipLabel: UILabel = {
        let one = UILabel()
        one.font = kFontTip
        one.textColor = kClrTip
        one.text = "上传"
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cardView)
        contentView.addSubview(authImageView)
        contentView.addSubview(addView)
        contentView.addSubview(tipLabel)
        contentView.addSubview(indicator)
        cardView.IN(contentView).LEFT(35).CENTER.SIZE(165, 95).MAKE()
        authImageView.RIGHT.EQUAL(cardView).OFFSET(10).MAKE()
        authImageView.TOP.EQUAL(cardView).OFFSET(-10).MAKE()
        authImageView.WIDTH.EQUAL(60).MAKE()
        authImageView.HEIGHT.EQUAL(60).MAKE()
        indicator.IN(cardView).RIGHT(5).TOP(5).MAKE()
        let addRightMargin = (kScreenW - 35 - 165) / 2 - 70 / 2
        addView.IN(contentView).RIGHT(addRightMargin).TOP(35).SIZE(70, 70).MAKE()
        tipLabel.BOTTOM(addView).OFFSET(10).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
