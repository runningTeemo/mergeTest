//
//  IndustryMembersViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/19.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class IndustryMembersViewController: RootTableViewController {
    
    var industry: Industry!
    var items: [IndustryMemberItem] = [IndustryMemberItem]()
    var lastDate: String?
    
    var currentUser: User?
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        resetFooter()
        lastDate = nil
        loadMore(done)
    }
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        let industry = self.industry!
        ArticleManager.shareInstance.getIndustryMembers(user: me, industry: industry, dateForPaging: lastDate, success: { [weak self] (code, msg, members) in
            if code == 0 {
                if let s = self {
                    let members = members!
                    var items = [IndustryMemberItem]()
                    for member in members {
                        let item = IndustryMemberItem(member: member)
                        item.update()
                        items.append(item)
                    }
                    if s.lastDate == nil {
                        s.items = items
                    } else {
                        s.items += items
                    }
                    
                    s.lastDate = s.items.last?.member.dateForPaging
                    done(s.checkOutLoadDataType(allModels: s.items, newModels: items))
                    s.tableView.reloadData()
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
            self?.autoCheckHasData(models: self?.items)
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
            self?.autoCheckHasData(models: self?.items)
        }
    }
    
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
        title = "成员列表"
        tableView.register(IndustryMemberCell.self, forCellReuseIdentifier: "IndustryMemberCell")
        setupNavBackBlackButton(nil)
        
        setupLoadingView()
        setupRefreshFooter()
        setupRefreshHeader()
        loadDataOnFirstWillAppear = true
        
        view.addSubview(barView)
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).OFFSET(barView.viewHeight).MAKE()
        NotificationCenter.default.addObserver(self, selector: #selector(IndustryMembersViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IndustryMembersViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndustryMemberCell") as! IndustryMemberCell
        cell.item = items[indexPath.row]
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
        cell.showBottomLine = !(indexPath.row == items.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        return item.cellHeight
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
        let vc = UserDetailViewController()
        vc.user = items[indexPath.row].member.user
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

class IndustryMemberItem {
    
    var member: IndustryMember
    var attentionsItem: RectSelectsFixSizeItem = RectSelectsFixSizeItem()
    fileprivate(set) var cellHeight: CGFloat = 0
    init(member: IndustryMember) {
        self.member = member
        update()
    }
    func update() {
        
        var items = [RectSelectFixSizeItem]()
        var f: Bool = true
     
        if let industry = member.user.industry {
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
        for i in member.user.industries {
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
        cellHeight = 75 + attentionsItem.viewHeight
    }
}

class IndustryMemberCell: RootTableViewCell {
    
    var indexPath: IndexPath!
    var respondAdd: ((_ user: User, _ indexPath: IndexPath) -> ())?

    var item: IndustryMemberItem! {
        didSet {
            iconView.iconView.fullPath = item.member.user.avatar
            nameLabel.text = item.member.user.realName
            companyLabel.text = item.member.user.company
            rectsView.item = item.attentionsItem
            
            if let isFriend = item.member.user.isFriend {
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
                if item.member.user.isMe() {
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
            let user = self.item.member.user
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
