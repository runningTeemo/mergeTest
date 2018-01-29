//
//  NewFriendsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/21.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewFriendsViewController: RootTableViewController {
    
    var requests: [FriendRequest] = [FriendRequest]()
    
    lazy var addItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconNewsOpen", responder: { [unowned self] in
            let vc = UserSearchViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            })
        return one
    }()
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        
        UserManager.shareInstance.getFriendRequests(dateForPaging: nil, user: me, success: { [weak self] (code, msg, requests) in
            if code == 0 {
                let requests = requests!
                if requests.count > 0 {
                    done(.noMore)
                } else {
                    done(.empty)
                }
                self?.requests = requests
                self?.tableView.reloadData()
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
            self?.autoCheckHasData(models: self?.requests)
            }) { [weak self] (error) in
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                done(.err)
                self?.autoCheckHasData(models: self?.requests)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "好友请求"
        tableView.register(NewFriendCell.self, forCellReuseIdentifier: "NewFriendCell")
        setupNavBackBlackButton(nil)
        setupRightNavItems(items: addItem)
        
        emptyMsg = "没有好友请求"
        setupLoadingView()
        setupRefreshHeader()
        loadDataOnFirstWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Account.sharedOne.friendsBadge = 0
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewFriendCell") as! NewFriendCell
        cell.request = requests[indexPath.row]
        cell.showBottomLine = !(indexPath.row == requests.count - 1)
        cell.respondHanlde = { handleType, request in
            self.handleRequest(handleType: handleType, request: request)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let request = requests[indexPath.row]
        return NewFriendCell.cellHeight(request)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let request = requests[indexPath.row]
        let vc = UserDetailViewController()
        vc.user = request.user
        self.navigationController?.pushViewController(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "删除") { [weak self] (action, indexPath) in
            if let s = self {
                let request = s.requests[indexPath.row]
                s.handleDelete(request: request)
            }
        }
        return [delete]
    }
    
    func handleDelete(request: FriendRequest) {

        if !Account.sharedOne.isLogin { return }
        
        let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
        
        UserManager.shareInstance.deleteFriendRequests(request: request, success: { [weak self] (code, msg, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                QXTiper.showSuccess("已删除", inView: self?.view, cover: true)
                if let s = self {
                    s.performRefresh()
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
    func handleRequest(handleType: FriendRequestHanldeType, request: FriendRequest) {
        
        if !Account.sharedOne.isLogin { return }

        let me = Account.sharedOne.user
        
        let wait = QXTiper.showWaiting("处理中...", inView: self.view, cover: true)
        UserManager.shareInstance.handleFriendRequest(user: me, handleType: handleType, request: request, success: { [weak self] (code, msg, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                request.handleType = .accept
                self?.tableView.reloadData()
                QXTiper.showSuccess("已添加", inView: self?.view, cover: true)
            } else if code == 1017 { // 已经是好友
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                request.handleType = .accept
                self?.tableView.reloadData()
            }
            }) { [weak self] (error) in
                QXTiper.hideWaiting(wait)
               QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
}

class NewFriendCell: RootTableViewCell {
    class func cellHeight(_ request: FriendRequest) -> CGFloat {
        let maxWidth = kScreenW - (12.5 + 55 + 10 + 12.5 + 60 + 20)
        let size = StringTool.size(request.message, font: kFontSmall, maxWidth: maxWidth).size
        return 75 + size.height
    }
    var request: FriendRequest! {
        didSet {
            iconView.iconView.fullPath = request.user.avatar
            nameLabel.text = request.user.realName
            companyLabel.text = request.user.company
            messageLabel.text = request.message
            if let type = request.handleType {
                handleBtn.isHidden = false
                
                switch type {
                case .notHandle:
                    handleBtn.norBgColor = kClrBlue
                    handleBtn.dowBgColor = kClrLightGray
                    handleBtn.norTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.dowTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.norTitleColor = kClrWhite
                    handleBtn.dowTitleColor = kClrWhite
                    handleBtn.title = "接受"
                    handleBtn.forceDown(false)
                case .accept:
                    handleBtn.norBgColor = UIColor.clear
                    handleBtn.dowBgColor = UIColor.clear
                    handleBtn.norTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.dowTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.norTitleColor = kClrLightGray
                    handleBtn.dowTitleColor = kClrLightGray
                    handleBtn.title = "已添加"
                    handleBtn.forceDown(true)
                case .refuse:
                    handleBtn.norBgColor = UIColor.clear
                    handleBtn.dowBgColor = UIColor.clear
                    handleBtn.norTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.dowTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.norTitleColor = kClrLightGray
                    handleBtn.dowTitleColor = kClrLightGray
                    handleBtn.title = "已拒绝"
                    handleBtn.forceDown(true)
                case .ignore:
                    handleBtn.norBgColor = UIColor.clear
                    handleBtn.dowBgColor = UIColor.clear
                    handleBtn.norTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.dowTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.norTitleColor = kClrLightGray
                    handleBtn.dowTitleColor = kClrLightGray
                    handleBtn.title = "已忽略"
                    handleBtn.forceDown(true)
                }

            } else {
                handleBtn.isHidden = true
            }
        }
    }
    
    var respondHanlde: ((_ handleType: FriendRequestHanldeType, _ request: FriendRequest) -> ())?
    
    lazy var iconView: RoundUserIcon = {
        let one = RoundUserIcon()
        return one
    }()
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontSubTitle
        return one
    }()
    lazy var companyLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        return one
    }()
    lazy var messageLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrLightGray
        one.font = kFontSmall
        one.numberOfLines = 0
        return one
    }()
    lazy var handleBtn: TitleButton = {
        let one = TitleButton()
        one.layer.cornerRadius = 15
        one.clipsToBounds = true
        one.norBgColor = kClrBlue
        one.dowBgColor = UIColor.clear
        one.norTitlefont = UIFont.systemFont(ofSize: 16)
        one.dowTitlefont = UIFont.systemFont(ofSize: 16)
        one.norTitleColor = kClrWhite
        one.dowTitleColor = kClrWhite
        one.title = "接受"
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            if let type = self.request.handleType {
                switch type {
                case .notHandle:
                    self.respondHanlde?(.accept, self.request)
                    default:
                    break
                }
            }
        })
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(handleBtn)
        
        iconView.IN(contentView).LEFT(12.5).TOP(15).SIZE(55, 55).MAKE()
        handleBtn.IN(contentView).RIGHT(12.5).TOP(25).SIZE(60, 30).MAKE()
        nameLabel.RIGHT(iconView).OFFSET(10).TOP.MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(handleBtn).LEFT.OFFSET(-20).MAKE()
        companyLabel.BOTTOM(nameLabel).OFFSET(5).LEFT.MAKE()
        companyLabel.RIGHT.LESS_THAN_OR_EQUAL(handleBtn).LEFT.OFFSET(-20).MAKE()
        messageLabel.BOTTOM(companyLabel).OFFSET(5).LEFT.MAKE()
        messageLabel.RIGHT.LESS_THAN_OR_EQUAL(handleBtn).LEFT.OFFSET(-20).MAKE()
    
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
