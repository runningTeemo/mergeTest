//
//  MyFriendsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyFriendsViewController: RootTableViewController {
    
    var users: [User] = [User]()
    var searchUsers: [User] = [User]()
    var isSearchMode: Bool = false
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let user = Account.sharedOne.user
        
        UserManager.shareInstance.getFriends(dateForPaging: nil, user: user, success: { [weak self] (code, msg, users) in
            if code == 0 {
                let users = users!
                self?.users = users
                if users.count == 0 {
                    done(.empty)
                } else {
                    done(.noMore)
                }
                self?.tableView.reloadData()
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
            self?.autoCheckHasData(models: self?.users)
            }) { [weak self] (error) in
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                done(.err)
                self?.autoCheckHasData(models: self?.users)
        }
        
    }
    
    lazy var searchHeaderView: SearchHeaderView = {
        let one = SearchHeaderView()
        one.respondChange = { [unowned self] t in
            self.handleSearchChange(t)
        }
        one.respondSearch = { [unowned self] t in
            self.handleSearchChange(t)
            self.view.endEditing(true)
        }
        one.respondCancel = { [unowned self] in
            self.isSearchMode = false
            self.tableView.reloadData()
            self.hideSearchEmpty()
        }
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 55)
        return one
    }()
    
    lazy var addItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconNewsOpen", responder: { [unowned self] in
            let vc = UserSearchViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            })
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的好友"
        setupNavBackBlackButton(nil)
        setupRightNavItems(items: addItem)
        
        tableView.tableHeaderView = searchHeaderView
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        tableView.register(MyFriendCell.self, forCellReuseIdentifier: "MyFriendCell")
        
        emptyMsg = "暂无好友\n请点击添加"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    func handleSearchChange(_ text: String?) {
        if SafeUnwarp(text, holderForNull: "").characters.count <= 0 {
            isSearchMode = false
            tableView.reloadData()
            hideSearchEmpty()

        } else {
            isSearchMode = true
            tableView.reloadData()
            let key = text!
            searchUsers.removeAll()
            for user in users {
                let name = SafeUnwarp(user.realName, holderForNull: "")
                let company = SafeUnwarp(user.company, holderForNull: "")
                if name.contains(key) || company.contains(key) {
                    searchUsers.append(user)
                }
            }
            isSearchMode = true
            tableView.reloadData()
            if searchUsers.count == 0 {
                showSearchEmpty("未找到结果")
            } else {
                hideSearchEmpty()
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode {
            return searchUsers.count
        }
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendCell") as! MyFriendCell
        if isSearchMode {
            cell.user = searchUsers[indexPath.row]
            cell.showBottomLine = !(indexPath.row == searchUsers.count - 1)
        } else {
            cell.user = users[indexPath.row]
            cell.showBottomLine = !(indexPath.row == users.count - 1)
        }
        cell.respondChat = { [unowned self] user in
            let vc = ChatViewController(conversationChatter: user.huanXinId, conversationType: EMConversationTypeChat)
            vc?.userName = SafeUnwarp(user.realName, holderForNull: "")
            vc?.userImg = user.avatar
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyFriendCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let user: User
        
        if isSearchMode {
            user = searchUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        let vc = UserDetailViewController()
        vc.user = user
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
            Confirmer.show("删除确认", message: "删除后无法恢复，是否继续？", confirm: "删除好友", confirmHandler: { [weak self] in
                if let s = self {
                    var user: User
                    if s.isSearchMode {
                        user = s.searchUsers[indexPath.row]
                    } else {
                        user = s.users[indexPath.row]
                    }
                    s.handleDelete(user: user)
                }
                }, inVc: self)
        }
        return [delete]
    }
    
    
    func handleDelete(user: User) {
        
        if !Account.sharedOne.isLogin { return }
        
        let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
        let me = Account.sharedOne.user
        
        UserManager.shareInstance.deleteFriend(user: me, friend: user, success: { [weak self] (code, msg, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                QXTiper.showSuccess("已删除", inView: self?.view, cover: true)
                if let s = self {
                    s.isSearchMode = false
                    s.searchHeaderView.searchView.textField.text = nil
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
    
}


class MyFriendCell: RootTableViewCell {
    
    var respondChat: ((_ user: User) -> ())?

    var user: User! {
        didSet {
            iconView.fullPath = user.avatar
            nameLabel.text = user.realName
            companyLabel.text = user.company
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return 70
    }
    
    lazy var iconView: RoundIconView = {
        let one = RoundIconView(type: .user)
        return one
    }()
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.black
        return one
    }()
    lazy var companyLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.black
        return one
    }()
    
    lazy var chatBtn: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 30, height: 30)
        one.iconView.image = UIImage(named: "iconChat")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondChat?(self.user)
        })
        return one
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(chatBtn)
        
        let textLeft: CGFloat = 60
        iconView.IN(contentView).LEFT(12.5).CENTER.SIZE(35, 35).MAKE()
        nameLabel.IN(contentView).LEFT(textLeft).TOP(15).HEIGHT(20).RIGHT(12.5 + 40 + 10).MAKE()
        companyLabel.IN(contentView).LEFT(textLeft).RIGHT(12.5 + 40 + 10).TOP(40).MAKE()
        chatBtn.IN(contentView).RIGHT(12.5).CENTER.SIZE(40, 40).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
