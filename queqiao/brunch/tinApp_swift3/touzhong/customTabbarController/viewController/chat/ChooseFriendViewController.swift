//
//  ChooseFriendViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ChooseFriendViewController: RootTableViewController {

    var users: [User] = [User]()
    var searchUsers: [User] = [User]()
    var isSearchMode: Bool = false
    var article:Article = Article()
    
    /// 加载数据 我的好友
    ///
    /// - Parameter done: <#done description#>
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的好友"
        setupNavBackBlackButton(nil)
        tableView.tableHeaderView = searchHeaderView
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        tableView.register(MyFriendCell.self, forCellReuseIdentifier: "MyFriendCell")
        
        emptyMsg = "暂无好友"
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
        cell.chatBtn.isHidden = true
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
        weak var ws = self
        let reaName = SafeUnwarp(user.realName, holderForNull: "")
        let alertController = UIAlertController(title: "提示",
                                                message: "是否分享给\(reaName)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            if ws?.article != nil{
                ChatManage.shareInstance.shareAticleToFriends(articleModel: (ws?.article)!, user: user)
                _ = ws?.navigationController?.popViewController(animated: true)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
     
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


}
