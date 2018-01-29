//
//  AuthorViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class AuthorViewController: StaticCellBaseViewController {
    
    var careers: [Career]!
    
    lazy var spaceItem0: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var chooseCareerItem: ChooseCareerItem = {
        let one = ChooseCareerItem()
        one.careers = self.careers
        one.respondFold = { [unowned self, unowned one] in
            one.isFold = !one.isFold
            one.update()
            one.updateCell?()
            self.update()
            self.tableView.reloadData()
        }
        one.respondReload = { [unowned self] in
            self.update()
            self.tableView.reloadData()
        }
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var nameItem: StaticCellSubTitleItem = {
        let one = StaticCellSubTitleItem()
        one.subTitleColor = kClrDeepGray
        one.subTitleFont = kFontNormal
        one.title = "姓名"
        one.showBottomLine = true
        return one
    }()
    
    lazy var companyItem: StaticCellSubTitleItem = {
        let one = StaticCellSubTitleItem()
        one.subTitleColor = kClrDeepGray
        one.subTitleFont = kFontNormal
        one.title = "公司"
        one.showBottomLine = true
        return one
    }()
    
    lazy var posstionItem: StaticCellSubTitleItem = {
        let one = StaticCellSubTitleItem()
        one.subTitleColor = kClrDeepGray
        one.subTitleFont = kFontNormal
        one.title = "职务"
        one.showBottomLine = true
        return one
    }()
    
    lazy var roleItem: StaticCellSubTitleItem = {
        let one = StaticCellSubTitleItem()
        one.subTitleColor = kClrDeepGray
        one.subTitleFont = kFontNormal
        one.title = "身份"
        return one
    }()
    
//    lazy var emailTipItem: StaticCellTextItem = {
//        let one = StaticCellTextItem()
//        one.backColor = kClrBackGray
//        one.textFont = UIFont.systemFont(ofSize: 16)
//        one.textColor = kClrNormalTxt
//        one.topMargin = 17
//        one.bottomMargin = 8
//        one.text = "方式A（快捷）"
//        one.update()
//        return one
//    }()
//    
//    lazy var emailAuthorItem: AuthorEmailItem = {
//        let one = AuthorEmailItem()
//        return one
//    }()
//    
    lazy var cardTipItem: StaticCellTextItem = {
        let one = StaticCellTextItem()
        one.backColor = kClrBackGray
        one.textFont = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrNormalTxt
        one.topMargin = 17
        one.bottomMargin = 8
        one.text = "名片"
        one.update()
        return one
    }()
    lazy var cardAuthItem: AuthorCardItem = {
        let one = AuthorCardItem()
        return one
    }()
    
    lazy var spaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "认证", responder: { [unowned self] in
            self.handleAuthor()
            })
        return one
    }()
    lazy var loadingNavItem: BarButtonItem = {
        let one = BarButtonItem(indicatorStyle: .gray)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "身份认证"
        setupNavBackBlackButton(nil)
        
        tableView.register(ChooseCareerCell.self, forCellReuseIdentifier: "ChooseCareerCell")
        tableView.register(AuthorEmailCell.self, forCellReuseIdentifier: "AuthorEmailCell")
        tableView.register(AuthorCardCell.self, forCellReuseIdentifier: "AuthorCardCell")

        staticItems = [spaceItem0, chooseCareerItem, spaceItem1, nameItem, companyItem, posstionItem, roleItem, cardTipItem, cardAuthItem, spaceItem2]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        for career in careers {
            if let b = career.isUsedForUserAuthor {
                if b {
                    chooseCareerItem.chosenOne = career
                    chooseCareerItem.update()
                }
            }
        }
        if chooseCareerItem.chosenOne == nil {
            chooseCareerItem.chosenOne = careers.first
        }
        self.update()
    }
    
    func update() {
        
        if !Account.sharedOne.isLogin { return }
        
        let me = Account.sharedOne.user
        nameItem.subTitle = me.realName
        if let career = chooseCareerItem.chosenOne {
            companyItem.subTitle = career.company
            posstionItem.subTitle = career.possition
            roleItem.subTitle = TinSearch(code: career.userRoleType, inKeys: kUserRoleTypeKeys)?.name
            
            cardAuthItem.url = career.cardImage
            cardAuthItem.thumbUrl = career.thumbCardImage
            
            cardAuthItem.authorStatus = me.author
            //emailAuthorItem.email = user.exmail
            
            if let author = me.author {
                switch author {
                case .isAuthed:
                    removeRightNavItems()
                default:
                    if let s = career.authorStatus {
                        switch s {
                        case .not:
                            setupRightNavItems(items: saveNavItem)
                        default:
                            removeRightNavItems()
                        }
                    }
                }
            }
            
        }
    }
    
    func handleAuthor() {
        
        if !Account.sharedOne.isLogin { return }
        
        let career = chooseCareerItem.chosenOne!

        if career.cardImage == nil || career.thumbCardImage == nil {
            
            Confirmer.show("提示", message: "需要提交名片才能进行审核。", confirm: "去提交", confirmHandler: { [weak self] in
                if let nav = self?.navigationController {
                    nav.popToRootViewController(animated: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak nav] in
                        let vc = MyCareerInfoViewController()
                        vc.hidesBottomBarWhenPushed = true
                        nav?.pushViewController(vc, animated: true)
                    }
                }               
                }, cancel: "取消", cancelHandler: {
                }, inVc: self)
            return
        }
        
        let me = Account.sharedOne.user
        
        let pic = Picture()
        pic.url = career.cardImage
        pic.thumbUrl = career.thumbCardImage
        
        setupRightNavItems(items: loadingNavItem)
        
        let wait = QXTiper.showWaiting("提交认证...", inView: self.view, cover: true)
        
        MyselfManager.shareInstance.author(me, career: career, pic: pic, success: { [weak self] (code, msg, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                self?.cardAuthItem.url = pic.url
                self?.cardAuthItem.thumbUrl = pic.thumbUrl
                self?.cardAuthItem.authorStatus = .progressing
                self?.chooseCareerItem.chosenOne?.cardImage = pic.url
                self?.chooseCareerItem.chosenOne?.thumbCardImage = pic.thumbUrl
                self?.tableView.reloadData()
                me.author = .progressing
                career.authorStatus = .progressing
                QXTiper.showSuccess("提交成功", inView: self?.view, cover: true)
                
                self?.removeRightNavItems()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                }

            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                self?.setupRightNavItems(items: self?.saveNavItem)
            }
            self?.update()
        }) { [weak self] (error) in
            self?.update()
            QXTiper.hideWaiting(wait)
            self?.setupRightNavItems(items: self?.saveNavItem)
            QXTiper.showWarning(kWebErrMsg + "(\(error.code))" , inView: self?.view, cover: true)
        }
        
    }
    
//    func handleAuth(image: UIImage) {
    //          if !Account.sharedOne.isLogin { return }
      
    
//        let me = Account.sharedOne.user
//        let career = chooseCareerItem.chosenOne!
//        
//        MyselfManager.shareInstance.uploadCard(me, image: image, success: { [weak self] (code, msg, pic) in
//            if code == 0 {
//                let pic = pic!
//                MyselfManager.shareInstance.author(me, career: career, pic: pic, success: { [weak self] (code, msg, ret) in
//                    if code == 0 {
//                        self?.cardAuthItem.url = pic.url
//                        self?.cardAuthItem.thumbUrl = pic.thumbUrl
//                        self?.chooseCareerItem.chosenOne?.cardImage = pic.url
//                        self?.chooseCareerItem.chosenOne?.thumbCardImage = pic.thumbUrl
//                        self?.tableView.reloadData()
//                        me.author = .progressing
//                    } else {
//                        QXTiper.showWarning(msg + "(\(code))", inView: self?.view, cover: true)
//                    }
//                }) { [weak self] (error) in
//                    QXTiper.showWarning(kWebErrMsg + "(\(error.code))" , inView: self?.view, cover: true)
//                }
//            } else {
//                QXTiper.showWarning(msg + "(\(code))", inView: self?.view, cover: true)
//            }
//            
//        }) { [weak self] (error) in
//            QXTiper.showWarning(kWebErrMsg + "(\(error.code))" , inView: self?.view, cover: true)
//        }
//    }
    
}


class ChooseCareerItem: StaticCellBaseItem {
    
    var isFold: Bool = true
    var careers: [Career] = [Career]()
    var chosenOne: Career?
    
    var respondFold: (() -> ())?
    var respondReload: (() -> ())?
    
    func update() {
        if isFold {
            cellHeight = 50
        } else {
            cellHeight = 50 + 50 * CGFloat(careers.count)
        }
    }
    
    override init() {
        super.init()
        cellHeight = 50
    }
}

class ChooseCareerCell: StaticCellBaseCell, UITableViewDelegate, UITableViewDataSource {
    override func update() {
        super.update()
        if let item = item as? ChooseCareerItem {
            self.titleLabel.text = item.chosenOne?.company
            self.innerTableView.reloadData()
            if item.isFold {
                arrowView.transform = CGAffineTransform.identity
            } else {
                arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            }
            item.updateCell = { [unowned self] in
                self.titleLabel.text = item.chosenOne?.company
                self.innerTableView.reloadData()
                if item.isFold {
                    self.arrowView.transform = CGAffineTransform.identity
                } else {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                }
            }
        }
    }
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "radioBoxSelect")
        return one
    }()
    lazy var arrowView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconScreenMore")
        return one
    }()
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = kFontSubTitle
        one.textColor = kClrDeepGray
        return one
    }()
    lazy var bgBtn: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrWhite
        one.dowBgColor = kClrSlightGray
        
        return one
    }()
    lazy var breakLine = NewBreakLine
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgBtn)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(innerTableView)
        contentView.addSubview(breakLine)
        bgBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ChooseCareerItem)?.respondFold?()
        }
        bgBtn.IN(contentView).LEFT.RIGHT.TOP.HEIGHT(50).MAKE()
        iconView.IN(contentView).LEFT(12.5).TOP(15).SIZE(20, 20).MAKE()
        titleLabel.IN(contentView).LEFT(50).RIGHT(50).MAKE()
        titleLabel.CENTER_Y.EQUAL(iconView).MAKE()
        breakLine.IN(contentView).LEFT.RIGHT.TOP(50).HEIGHT(0.5).MAKE()
        arrowView.IN(contentView).RIGHT(12.5).TOP(17.5).SIZE(15, 15).MAKE()
        innerTableView.IN(contentView).LEFT.RIGHT.TOP(50).BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var innerTableView: UITableView = {
        let one = UITableView(frame: CGRect.zero, style: .grouped)
        one.delegate = self
        one.dataSource = self
        one.separatorEffect = nil
        one.separatorStyle = .none
        one.backgroundColor = kClrBackGray
        one.showsVerticalScrollIndicator = false
        one.isScrollEnabled = false
        one.register(InnnerCell.self, forCellReuseIdentifier: "InnnerCell")
        return one
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SafeUnwarp((item as? ChooseCareerItem)?.careers.count, holderForNull: 0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InnnerCell") as! InnnerCell
        let careers = (item as! ChooseCareerItem).careers
        cell.career = careers[indexPath.row]
        cell.showBottomLine = !(indexPath.row == careers.count - 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InnnerCell.cellHeight()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = item as? ChooseCareerItem {
            let career = item.careers[indexPath.row]
            item.chosenOne = career
            item.isFold = true
            item.update()
            item.respondReload?()
        }
    }
    
    class InnnerCell: RootTableViewCell {
        override class func cellHeight() -> CGFloat {
            return 50
        }
        var career: Career! {
            didSet {
                titleLabel.text = career.company
            }
        }
        lazy var titleLabel: UILabel = {
            let one = UILabel()
            one.font = kFontSubTitle
            one.textColor = kClrDeepGray
            return one
        }()
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(titleLabel)
            titleLabel.IN(contentView).LEFT(50).CENTER.RIGHT(50).MAKE()
            bottomLineLeftCons?.constant = 50
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}



//MARK: 邮箱验证

class AuthorEmailItem: StaticCellBaseItem {
    
    var isSending: Bool = false
    
    var email: String?
    
    override init() {
        super.init()
        cellHeight = 155
    }
}

class AuthorEmailCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? AuthorEmailItem {
            emailLabel.text = item.email
            if item.isSending {
                verifyBtn.startLoading()
            } else {
                verifyBtn.stopLoading()
            }
        }
    }
    
    lazy var iconView: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconMyEmail")
        return one
    }()
    lazy var emailLabel: UILabel = {
        let one = UILabel()
        one.font = kFontTip
        one.numberOfLines = 0
        return one
    }()
    lazy var verifyBtn: LoadingButton = {
        let one = LoadingButton()
        one.titleColor = kClrWhite
        one.norBgColor = kClrBlue
        one.dowBgColor = kClrBtnDown
        one.cornerRadius = 15
        one.titlefont = UIFont.systemFont(ofSize: 13)
        one.title = "邮箱认证"
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(emailLabel)
        contentView.addSubview(verifyBtn)
        iconView.IN(contentView).LEFT(15).CENTER.SIZE(20, 20).MAKE()
        emailLabel.IN(contentView).LEFT(15 + 20 + 5).TOP(20).BOTTOM(20).RIGHT(100 + 15 + 30).MAKE()
        verifyBtn.IN(contentView).RIGHT(15).CENTER.SIZE(100, 30).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AuthorCardItem: StaticCellBaseItem {
    
    var url: String?
    var thumbUrl: String?
    var authorStatus: Author?
    
    override init() {
        super.init()
        cellHeight = 155
    }
}

class AuthorCardCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        
        if let item = item as? AuthorCardItem {
            
            cardView.fullPath = item.thumbUrl

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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cardView)
        contentView.addSubview(authImageView)
        cardView.IN(contentView).CENTER.SIZE(165, 95).MAKE()
        authImageView.RIGHT.EQUAL(cardView).OFFSET(10).MAKE()
        authImageView.TOP.EQUAL(cardView).OFFSET(-10).MAKE()
        authImageView.WIDTH.EQUAL(60).MAKE()
        authImageView.HEIGHT.EQUAL(60).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
