//
//  UserSearchViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class UserSearchViewController: RootTableViewController {
    
    var items: [SearchUserItem] = [SearchUserItem]()
    var suggestItems: [SearchUserItem] = [SearchUserItem]()
    
    var currentUser: User?
    
    var searchStatus: LoadStatus = .doneEmpty

    override func loadData(_ done: @escaping LoadingDataDone) {
        resetFooter()
        loadMore(done)
    }
    
    var keyword: String = ""
    
    func handleSearch() {
        
        if !Account.sharedOne.isLogin {
            return
        }
        
        searchStatus = .loading
        tableView.reloadData()
        
        let me = Account.sharedOne.user
        
        UserManager.shareInstance.searchUsers(user: me, keyword: self.keyword, success: { [weak self] (code, msg, users) in
            if code == 0 {
                if let s = self {
                    let users = users!
                    var items = [SearchUserItem]()
                    for user in users {
                        let item = SearchUserItem(user: user)
                        item.update()
                        items.append(item)
                    }
                    s.items = items
                    if items.count > 0 {
                        s.searchStatus = .done
                    } else {
                        s.searchStatus = .doneEmpty
                    }
                    s.tableView.reloadData()
                }
            } else {
                self?.searchStatus = .doneErr
                self?.tableView.reloadData()
            }
            self?.autoCheckHasData(models: self?.items)
            }) {  [weak self] (error) in
                self?.searchStatus = .doneErr
                self?.tableView.reloadData()
        }
        
    }
    
    
    func tryAppendSuggestUsers() {
        if !Account.sharedOne.isLogin {
            return
        }
        let me = Account.sharedOne.user
        if let industry = me.industry {
            UserManager.shareInstance.suggestUsers(user: me, industry: industry, success: { [weak self] (code, _, users) in
                if code == 0 {
                    if let s = self {
                        let users = users!
                        var items = [SearchUserItem]()
                        for user in users {
                            let item = SearchUserItem(user: user)
                            item.update()
                            items.append(item)
                        }
                        s.suggestItems = items
                        s.tableView.reloadData()
                    }
                }
                
            }) { (_) in
            }
        }
    }
    
    lazy var searchHeadView: SearchHeaderView = {
        let one = SearchHeaderView()
        one.placeHolder = "姓名/手机号"
        one.respondSearch = { [unowned self] text in
            if NotNullText(text) {
                self.keyword = SafeUnwarp(text, holderForNull: "")
                self.handleSearch()
            }
        }
        one.respondBegin = { [unowned self] in
            self.barView.isHidden = true
        }
        one.respondEnd = { [unowned self] t in
            self.barView.isHidden = false
        }
        one.respondChange = { [unowned self] t in
            if NullText(t) {
                self.items.removeAll()
                self.tableView.reloadData()
            }
        }
        return one
    }()
    
    lazy var barView: NewsCommentCommentBar = {
        let one = NewsCommentCommentBar()
        one.commentField.textField.placeholder = "填写验证信息"
        one.respondComment = { [unowned self, unowned one] text in
            let me = Account.sharedOne.user
            if let name = me.realName {
                one.commentField.textField.text = "我是" + name
            } else {
                one.commentField.textField.text = "我是"
            }
            self.handleComment(text)
        }
        return one
    }()
    
    var barViewBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加好友"
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: "SearchUserCell")
        tableView.register(SuggestHeaderView.self, forHeaderFooterViewReuseIdentifier: "SuggestHeaderView")
        setupNavBackBlackButton(nil)
        
        view.addSubview(searchHeadView)
        searchHeadView.IN(view).LEFT.RIGHT.TOP.HEIGHT(55).MAKE()
        
        tableViewTopCons.constant = 55
        loadingViewTopCons?.constant = 55
        
        view.addSubview(barView)
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).OFFSET(barView.viewHeight).MAKE()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserSearchViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UserSearchViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        tryAppendSuggestUsers()
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        if suggestItems.count > 0 {
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if searchStatus == .done {
                return items.count
            } else {
                if keyword.characters.count > 0 {
                    return 1
                } else {
                    return 0
                }
            }
        }
        return suggestItems.count
    }
    
    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            
            if searchStatus == .done {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell") as! SearchUserCell
                cell.indexPath = indexPath
                cell.respondAdd = { [unowned self] user, indexPath in
                    self.currentUser = user
                    self.barView.commentField.textField.text = nil
                    self.barView.commentField.textField.becomeFirstResponder()
                    self.keyboardNeedsShow = true
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                        self?.keyboardNeedsShow = false
                    }
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
                cell.item = items[indexPath.row]
                cell.showBottomLine = !(indexPath.row == items.count - 1)
                return cell
                
            } else {
                if searchStatus == .doneEmpty {
                    loadingCell.showEmpty("未检索到结果")
                } else if searchStatus == .doneErr {
                    loadingCell.showFailed(self.faliedMsg)
                } else {
                    loadingCell.showLoading()
                }
                loadingCell.respondReload = { [unowned self] in
                    self.handleSearch()
                }
                return loadingCell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell") as! SearchUserCell
            cell.indexPath = indexPath
            cell.respondAdd = { [unowned self] user, indexPath in
                self.currentUser = user
                self.barView.commentField.textField.text = nil
                self.barView.commentField.textField.becomeFirstResponder()
                self.keyboardNeedsShow = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    self?.keyboardNeedsShow = false
                }
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            cell.item = suggestItems[indexPath.row]
            cell.showBottomLine = !(indexPath.row == suggestItems.count - 1)
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if searchStatus == .done {
                let item = items[indexPath.row]
                return item.cellHeight
            } else {
                return 150
            }
        }
        let item = suggestItems[indexPath.row]
        return item.cellHeight
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }
        return SuggestHeaderView.viewHeight()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return super.tableView(tableView, viewForHeaderInSection: section)
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SuggestHeaderView") as! SuggestHeaderView
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            if suggestItems.count > 0 {
                return 0.0001
            }
        }
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if searchStatus == .done {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let user: User
        if indexPath.section == 0 {
            user = items[indexPath.row].user
        } else {
            user = suggestItems[indexPath.row].user
        }
        let vc = UserDetailViewController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func handleComment(_ text: String) {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.sendRequest(text)
        }
    }
    func sendRequest(_ text: String) {
        let wait = QXTiper.showWaiting("请求中...", inView: view, cover: true)
        let me = Account.sharedOne.user
        let user = currentUser!
        
        UserManager.shareInstance.sendFriendRequest(user: me, toUser: user, message: text, success: { [weak self] (code, message, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                self?.barView.commentField.textField.text = nil
                QXTiper.showSuccess("请求已发送", inView: self?.view, cover: true)
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
    fileprivate var origenFooterView: UIView?
    fileprivate var isSecondShow: Bool = false // 解决第三方键盘的多次弹出问题
    fileprivate var keyboardNeedsShow: Bool = false
    func keyboardWillShow(_ notice: Notification) {
        if (notice as NSNotification).userInfo == nil { return }
        let frame = ((notice as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant =  -frame.size.height
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            })
        
        if isSecondShow { return }
        isSecondShow = true
        // 解决第三方键盘的多次弹出问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.isSecondShow = false
        }
        // 这里有tabBar则还要-49
        let endHeight = frame.size.height
        if let footerView = tableView.tableFooterView {
            if !footerView.isKind(of: KeyboardSpaceView.self) {
                origenFooterView = footerView
            }
        }
        let footerView = KeyboardSpaceView(frame: CGRect(x: 0,y: 0,width: 0,height: endHeight))
        tableView.tableFooterView = footerView
    }
    func keyboardWillHide(_ notice: Notification) {
        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant = barView.viewHeight
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            })
        tableView.tableFooterView = origenFooterView
        origenFooterView = nil
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if keyboardNeedsShow == false {
            view.endEditing(true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}



class SearchUserItem {
    
    var user: User
    var attentionsItem: RectSelectsFixSizeItem = RectSelectsFixSizeItem()
    fileprivate(set) var cellHeight: CGFloat = 0
    init(user: User) {
        self.user = user
        update()
    }
    func update() {
        
        var items = [RectSelectFixSizeItem]()
        var f: Bool = true
        
        if let industry = user.industry {
            let item = RectSelectFixSizeItem()
            item.size = CGSize(width: 60 * kSizeRatio, height: 20 * kSizeRatio)
            item.norTitleFontSize = 9 * kSizeRatio
            item.selTitleFontSize = 9 * kSizeRatio
            item.norBorderWidth = 0.3
            item.selBorderWidth = 0.3
            item.isFillMode = false
            item.showCornerImage = false
            if f {
                item.isSelect = true
                f = false
            }
            item.title = industry.name
            item.update()
            items.append(item)
        }
        for i in user.industries {
            let item = RectSelectFixSizeItem()
            item.size = CGSize(width: 60 * kSizeRatio, height: 20 * kSizeRatio)
            item.norTitleFontSize = 9 * kSizeRatio
            item.selTitleFontSize = 9 * kSizeRatio
            item.norBorderWidth = 0.3
            item.selBorderWidth = 0.3
            item.isFillMode = false
            item.showCornerImage = false
            if f {
                item.isSelect = false
                f = false
            }
            item.title = i.name
            item.update()
            items.append(item)
        }
        attentionsItem.models = items
        attentionsItem.maxWidth = kScreenW - (12.5 + 55 + 10 + 12.5 + 60 + 20)
        attentionsItem.itemXMargin = 5
        attentionsItem.itemYMargin = 5
        attentionsItem.update()
        cellHeight = max(75 + attentionsItem.viewHeight, 85)
    }
}

class SearchUserCell: RootTableViewCell {
    
    var indexPath: IndexPath!
    var respondAdd: ((_ user: User, _ indexPath: IndexPath) -> ())?
    
    var item: SearchUserItem! {
        didSet {
            iconView.iconView.fullPath = item.user.avatar
            nameLabel.text = item.user.realName
            companyLabel.text = item.user.company
            rectsView.item = item.attentionsItem
            
            if let isFriend = item.user.isFriend {
                if isFriend {
                    handleBtn.norBgColor = UIColor.clear
                    handleBtn.dowBgColor = UIColor.clear
                    handleBtn.norTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.dowTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.norTitleColor = kClrLightGray
                    handleBtn.dowTitleColor = kClrLightGray
                    handleBtn.title = "已添加"
                    handleBtn.isHidden = false
                    handleBtn.forceDown(true)
                } else {
                    handleBtn.norBgColor = kClrBlue
                    handleBtn.dowBgColor = HEX("#9cd4f8")
                    handleBtn.norTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.dowTitlefont = UIFont.systemFont(ofSize: 16)
                    handleBtn.norTitleColor = kClrWhite
                    handleBtn.dowTitleColor = kClrWhite
                    handleBtn.title = "添加"
                    handleBtn.isHidden = false
                    handleBtn.forceDown(false)
                }
                if item.user.isMe() {
                    handleBtn.isHidden = true
                }
            } else {
                handleBtn.isHidden = true
            }
            
        }
    }
    lazy var iconView: RoundUserIcon = {
        let one = RoundUserIcon()
        one.isUserInteractionEnabled = false
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
    lazy var rectsView: RectSelectsFixSizeView = {
        let one = RectSelectsFixSizeView()
        one.isUserInteractionEnabled = false
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
        one.title = "添加"
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            let user = self.item.user
            self.respondAdd?(user, self.indexPath)
            })
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(rectsView)
        contentView.addSubview(handleBtn)
        
        iconView.IN(contentView).LEFT(12.5).TOP(15).SIZE(55, 55).MAKE()
        handleBtn.IN(contentView).RIGHT(12.5).TOP(25).SIZE(60, 30).MAKE()
        nameLabel.RIGHT(iconView).OFFSET(10).TOP.MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(handleBtn).LEFT.OFFSET(-20).MAKE()
        companyLabel.BOTTOM(nameLabel).OFFSET(5).LEFT.MAKE()
        companyLabel.RIGHT.LESS_THAN_OR_EQUAL(handleBtn).LEFT.OFFSET(-20).MAKE()
        rectsView.BOTTOM(companyLabel).OFFSET(5).LEFT.MAKE()
        rectsView.RIGHT.EQUAL(contentView).OFFSET(-12.5).MAKE()
        rectsView.BOTTOM.EQUAL(contentView).MAKE()
        
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SuggestHeaderView: RootTableViewHeaderFooterView {
    
    lazy var tipView: UILabel = {
        let one = UILabel()
        one.font = kFontNormal
        one.textColor = kClrGray
        one.text = "推荐好友"
        return one
    }()
    override class func viewHeight() -> CGFloat {
        return 40
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tipView)
        contentView.backgroundColor = kClrBackGray
        tipView.IN(contentView).LEFT(12.5).CENTER.RIGHT(12.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

