//
//  MeMainViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeMainViewController: StaticCellBaseViewController, LogoutProtocol {
    
    private var _needsUpdate = false
    func setNeedsUpdate() {
        _needsUpdate = true
    }
    
    func performLogin() {
        update()
    }
    func performLogout() {
        dismiss(animated: false, completion: nil)
        _ = navigationController?.popToRootViewController(animated: true)
        update()
    }

    lazy var settingsBlackBtn: BarIconButton = {
        let one = BarIconButton(iconName: "iconTopSetBlack")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            let vc = SettingsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            })
        return one
    }()
    lazy var settingsWhiteBtn: BarIconButton = {
        let one = BarIconButton(iconName: "iconTopSet")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            let vc = SettingsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        return one
    }()
    
    lazy var loginView: ToLoginView = {
        let one = ToLoginView()
        one.respondLogin = {
            let vc = LoginViewController()
            vc.showRegistOnAppear = false
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondRegist = {
            let vc = LoginViewController()
            vc.showRegistOnAppear = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var headView: MeMainHeadView = {
        let one = MeMainHeadView()
        one.frame = CGRect(x: 0, y: 0, width: 0, height: one.viewHeight)
        one.user = nil
        one.respondInfo = { [unowned self] in
            let vc = MeInformationViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondAuthor = { [unowned self] in
            if self.getCompleteDegree().toInfo {
                let vc = MeInformationViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.handleAuthor()
            }
        }
        one.respondIndustry = { [unowned self] in
            let vc = SetIndustryViewController()
            vc.isAttentionMode = false
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var companyItem: MeCompanyItem = {
        let one = MeCompanyItem()
        one.responder = { [unowned self] in
            let vc = MyCareerInfoViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var warningItem: StaticCellWarningItem = {
        let one = StaticCellWarningItem()
        one.text = "您的资料完善度0%，去完善"
        return one
    }()
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var myFriendsItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleColor = HEX("#333333")
        one.subTitleColor = HEX("#999999")
        one.titleFont = UIFont.systemFont(ofSize: 15)
        one.subTitleFont = UIFont.systemFont(ofSize: 13)
        one.cellHeight = 60
        one.title = "我的好友"
        one.subTitle = "共0个"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = MyFriendsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var myCollectsItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleColor = HEX("#333333")
        one.subTitleColor = HEX("#999999")
        one.titleFont = UIFont.systemFont(ofSize: 15)
        one.subTitleFont = UIFont.systemFont(ofSize: 13)
        one.cellHeight = 60
        one.title = "我的收藏"
        one.subTitle = "共0条"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = MyCollectionViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var myCircleItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleColor = HEX("#333333")
        one.subTitleColor = HEX("#999999")
        one.titleFont = UIFont.systemFont(ofSize: 15)
        one.subTitleFont = UIFont.systemFont(ofSize: 13)
        one.cellHeight = 60
        one.title = "我的行业"
        one.subTitle = "共0个"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = MyCircleViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)            
        }
        return one
    }()
    
    lazy var myAttentionsItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleColor = HEX("#333333")
        one.subTitleColor = HEX("#999999")
        one.titleFont = UIFont.systemFont(ofSize: 15)
        one.subTitleFont = UIFont.systemFont(ofSize: 13)
        one.cellHeight = 60
        one.title = "关注项目"
        one.subTitle = "共0个"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = MyAttentionsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var myNewsItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleColor = HEX("#333333")
        one.subTitleColor = HEX("#999999")
        one.titleFont = UIFont.systemFont(ofSize: 15)
        one.subTitleFont = UIFont.systemFont(ofSize: 13)
        one.cellHeight = 60
        one.title = "我的动态"
        one.subTitle = "共0条"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            if Account.sharedOne.isLogin {
                let vc = UserDetailViewController()
                vc.user = Account.sharedOne.user
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var authorItem: MeMainAuthorItem = {
        let one = MeMainAuthorItem()
        one.titleColor = HEX("#333333")
        one.subTitleColor = kClrOrange
        one.titleFont = UIFont.systemFont(ofSize: 15)
        one.subTitleFont = UIFont.systemFont(ofSize: 13)
        one.cellHeight = 60
        one.title = "成为认证用户"
        one.subTitle = "去认证"
        one.responder = { [unowned self] in
            self.handleAuthor()
        }
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        one.color = kClrBackGray
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewTopCons.constant = -kScreenH
        
        tableView.tableHeaderView = headView
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = kClrBackGray
        tableView.register(MeCompanyCell.self, forCellReuseIdentifier: "MeCompanyCell")
        tableView.register(MeMainAuthorCell.self, forCellReuseIdentifier: "MeMainAuthorCell")

        view.addSubview(loginView)
        loginView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        staticItems = [companyItem, spaceItem, myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, bottomSpaceItem]
        myFriendsItem.subTitle = nil
        myCollectsItem.subTitle = nil
        myCircleItem.subTitle = nil
        myAttentionsItem.subTitle = nil
        myNewsItem.subTitle = nil
        
        setupCustomNav()
        customNavView.changeAlpha(0)
        customNavView.addSubview(settingsBlackBtn)
        customNavView.addSubview(settingsWhiteBtn)
        settingsWhiteBtn.IN(customNavView).RIGHT.BOTTOM.SIZE(40, 40).MAKE()
        settingsBlackBtn.IN(customNavView).RIGHT.BOTTOM.SIZE(40, 40).MAKE()
        settingsBlackBtn.isHidden = true
        
        self.statusBarStyle = .lightContent
        customNavView.respondWhite = { [unowned self] in
            self.statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
        }
        customNavView.respondTransparent = { [unowned self] in
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        setupRefreshHeader()
        
        self.statusBarStyle = .lightContent
        customNavView.respondWhite = { [unowned self] in
            self.settingsWhiteBtn.isHidden = true
            self.settingsBlackBtn.isHidden = false
            self.statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
        }
        customNavView.respondTransparent = { [unowned self] in
            self.settingsWhiteBtn.isHidden = false
            self.settingsBlackBtn.isHidden = true
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            MyselfManager.shareInstance.getInfo(user: me, success: { [weak self] (code, msg, user) in
                if code == 0 {
                    if Account.sharedOne.isLogin {
                        Account.sharedOne.saveUser(user: user!)
                    }
                    self?.update()
                } else {
                    QXTiper.showFailed(msg, inView: self?.view, cover: true)
                }
                done(.noMore)
            }) { [weak self] (error) in
                done(.noMore)
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        customNavView.title = "我的"
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
        update()
        
        if _needsUpdate {
            tableView.mj_header.beginRefreshing()
            _needsUpdate = false
        } else {
            // 这个用来检测掉线
            if Account.sharedOne.isLogin {
                let me = Account.sharedOne.user
                MyselfManager.shareInstance.getInfo(user: me, success: { [weak self] (code, msg, user) in
                    if code == 0 {
                        if Account.sharedOne.isLogin {
                            Account.sharedOne.saveUser(user: user!)
                        }
                        self?.update()
                    }
                }) { (error) in
                }
            }
        }
    }
    
    func update() {
        
        if Account.sharedOne.isLogin {
            loginView.isHidden = true
        } else {
            loginView.isHidden = false
        }
        if Account.sharedOne.isLogin {
            
            let me = Account.sharedOne.user
            headView.isProfileComplete = !self.getCompleteDegree().toInfo
            headView.user = me
            
            if showCompany() && showAuthor() {
                staticItems = [companyItem, spaceItem, myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, spaceItem1, authorItem, bottomSpaceItem]
            } else if showCompany() && !showAuthor() {
                staticItems = [companyItem, spaceItem, myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, bottomSpaceItem]
            } else if showAuthor() && !showCompany() {
                staticItems = [myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, spaceItem1, authorItem, bottomSpaceItem]
            } else {
                staticItems = [myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, bottomSpaceItem]
            }
            if let company = me.company {
                companyItem.name = company
            }
            tableView.reloadData()
        }
    }
    
    func showAuthor() -> Bool {
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            if let author = me.author {
                if author == .not || author == .failed {
                    return true
                }
            }
        }
        return false
    }
    
    func showCompany() -> Bool {
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            if let _ = me.company {
                return true
            }
        }
        return false
    }
    
    func handleAuthor() {
        let completion = getCompleteDegree()
        warningItem.text = completion.msg
        if completion.toInfo {
            warningItem.responder = { [unowned self] in
                let vc = MeInformationViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if Account.sharedOne.isLogin {
                let user = Account.sharedOne.user
                headView.user = user
                if showCompany() && showAuthor() {
                    staticItems = [companyItem, warningItem, myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, spaceItem1, authorItem, bottomSpaceItem]
                } else if showCompany() && !showAuthor() {
                    staticItems = [companyItem, warningItem, myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, bottomSpaceItem]
                } else if showAuthor() && !showCompany() {
                    staticItems = [warningItem, myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, spaceItem1, authorItem, bottomSpaceItem]
                } else {
                    staticItems = [warningItem, myFriendsItem, myCollectsItem, myCircleItem, myAttentionsItem, myNewsItem, bottomSpaceItem]
                }
                tableView.reloadData()
            }
        } else {
            if Account.sharedOne.isLogin {
                let user = Account.sharedOne.user
                
                let wait = QXTiper.showWaiting("", inView: self.view, cover: true)
                
                MyselfManager.shareInstance.getCareers(user: user, success: { [weak self] (code, msg, careers) in
                    QXTiper.hideWaiting(wait)
                    if code == 0 {
                        let careers = careers!
                        if careers.count > 0 {
                            let vc = AuthorViewController()
                            vc.careers = careers
                            vc.hidesBottomBarWhenPushed = true
                            _ = self?.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            Confirmer.show("提示", message: "您需要先创建至少一条职业生涯，才可开始认证。", confirm: "去添加", confirmHandler: { [weak self] in
                                let vc = MyCareerInfoViewController()
                                vc.hidesBottomBarWhenPushed = true
                                _ = self?.navigationController?.pushViewController(vc, animated: true)
                                }, cancel: "取消", cancelHandler: { 
                                }, inVc: self)
                        }
                    } else {
                        QXTiper.showWarning(msg + "\(code)", inView: self?.view, cover: true)
                    }
                    }, failed: { [weak self] (error) in
                        QXTiper.hideWaiting(wait)
                        QXTiper.showFailed(kWebErrMsg + "\(error.code)", inView: self?.view, cover: true)
                })
            }
        }
        
    }
    
    /// msg 表示资料完善程度，toInfo表示跳转到个人信息页面，为no表示跳转到认证
    func getCompleteDegree() -> (perc: Int, msg: String, toInfo: Bool) {
        if Account.sharedOne.isLogin {
            let user = Account.sharedOne.user
            
            var score: CGFloat = 0
            var total: CGFloat = 0
            
            var infoCount: Int = 3
            var authorCount: Int = 4

            if NotNullText(user.avatar)     {  score += 1; infoCount -= 1 }
            total += 1
            if NotNullText(user.realName)   {  score += 1; infoCount -= 1 }
            total += 1
            if NotNull(user.gender)         {  score += 1; infoCount -= 1 }
            total += 1
            
            if NotNullText(user.company)    {  score += 1; authorCount -= 1 }
            total += 1
            if NotNullText(user.position)   {  score += 1; authorCount -= 1 }
            total += 1
            if NotNull(user.roleType)   {  score += 1; authorCount -= 1 }
            total += 1
            if NotNullText(user.exmail)      {  score += 1; authorCount -= 1 }
            total += 1
            
            if let author = user.author {
                switch author {
                case .progressing, .isAuthed:
                    score += 5
                default:
                    break
                }
            }

            total += 5
            let percent = Int(score / total * 100)
            if authorCount != 0 {
                return (percent, "您的资料完善度\(percent)%，去完善", true)
            } else {
                return (percent, "您的资料完善度\(percent)%，去完善", false)
            }
            
        } else {
            return (0, "用户未登录", true)
        }
    }
    
}

class MeCompanyItem: StaticCellBaseItem {
    var name: String?
    override init() {
        super.init()
        cellHeight = 60
    }
}

class MeCompanyCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? MeCompanyItem {
            nameLabel.text = item.name
        } else {
            nameLabel.text = "匿名公司"
        }
    }
    
    lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconMyCompany")
        return one
    }()
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.black
        one.font = UIFont.systemFont(ofSize: 14)
        return one
    }()
    
    lazy var rightArrow: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconListMore")
        return one
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rightArrow)

        iconView.IN(contentView).LEFT(15).CENTER.SIZE(18, 18).MAKE()
        nameLabel.RIGHT(iconView).OFFSET(10).CENTER.MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(rightArrow).OFFSET(-20).MAKE()
        rightArrow.IN(contentView).RIGHT(10).SIZE(15, 15).CENTER.MAKE()

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class MeMainAuthorItem: StaticCellArrowItem {
    
}
class MeMainAuthorCell: StaticCellArrowCell {
    lazy var icon: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconMyWRZ")
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(icon)
        icon.LEFT(subTitleLabel).OFFSET(5).CENTER.SIZE(15, 15).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

