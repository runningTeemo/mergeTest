//
//  MessageMainViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/21.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MessageMainViewController: StaticCellBaseViewController {
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var associateToMeItem: MessageMainItem = {
        let one = MessageMainItem()
        one.iconName = "iconCircleYwxg"
        one.title = "与我相关"
        one.dotType = true
        one.responder = { [unowned self] in
            let vc = AssociateToMeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.bottomLineLeftMargin = 12.5
        one.bottomLineRightMargin = 12.5
        one.showBottomLine = true
        return one
    }()
    
    lazy var addFriendItem: MessageMainItem = {
        let one = MessageMainItem()
        one.iconName = "iconCircleHytj"
        one.title = "好友添加"
        one.dotType = true
        one.responder = { [unowned self] in
            let vc = NewFriendsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.bottomLineLeftMargin = 12.5
        one.bottomLineRightMargin = 12.5
        one.showBottomLine = true
        return one
    }()
    
    lazy var conversationItem: MessageMainItem = {
        let one = MessageMainItem()
        one.iconName = "iconCircleHhlb"
        one.title = "会话列表"
        one.dotType = true
        one.responder = { [unowned self] in
            if Account.sharedOne.isLogin {
                let vc = ConversationListController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        one.bottomLineLeftMargin = 12.5
        one.bottomLineRightMargin = 12.5
        one.showBottomLine = false
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息通知"
        setupNavBackBlackButton(nil)
        tableView.register(MessageMainCell.self, forCellReuseIdentifier: "MessageMainCell")
        staticItems = [topSpaceItem, associateToMeItem, addFriendItem, conversationItem, bottomSpaceItem]
        
        associateToMeItem.content = "您有一条新的评论"
        associateToMeItem.count = 5
        associateToMeItem.date = Date()
        
        addFriendItem.content = "您有新的好友添加请求"
        addFriendItem.count = 5
        addFriendItem.date = Date()
               conversationItem.count = 8
        conversationItem.date = Date()
        reloadMessageStr()
        NotificationCenter.default.addObserver(self, selector: #selector(MessageMainViewController.updateaBadge), name: ReciveMessage, object: nil)
        
        if !EMClient.shared().isLoggedIn {
            if Account.sharedOne.isLogin {
                DispatchQueue.global().async {
                    ChatManage.shareInstance.loginHuanxin()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateaBadge()
    }
    
    func updateaBadge(){
        ChatManage.shareInstance.getAllUnReadMessage()
        reloadBage()
        reloadMessageStr()
        tableView.reloadData()
    }
    //更新红点
    func reloadBage(){
        self.conversationItem.count = Account.sharedOne.messagesBadge
        self.addFriendItem.count = Account.sharedOne.friendsBadge
        self.associateToMeItem.count = Account.sharedOne.associateBadge
    }
    //更新消息
    func reloadMessageStr(){
        if Account.sharedOne.messagesBadge>0 {
            conversationItem.content = "您有新的消息"
        }else{
            let model = ChatManage.shareInstance.getLastMessage()
            let lastMssageAtributeStr = ChatTools.getlastMassageAttributeStr(model)
            conversationItem.content = lastMssageAtributeStr?.string
        }
        if Account.sharedOne.associateBadge>0 {
            associateToMeItem.content = "您有一条新的评论"
        }else{
            associateToMeItem.content = ""
        }
        if Account.sharedOne.friendsBadge>0 {
            addFriendItem.content = "您有新的好友添加请求"
        }else{
            addFriendItem.content = ""
        }
    }
}



class MessageMainItem: StaticCellBaseItem {
    var iconName: String?
    var title: String?
    var content: String?
    var count: Int?
    var dotType: Bool = true
    var date: Date?
    override init() {
        super.init()
        cellHeight = 75
    }
}

class MessageMainCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? MessageMainItem {
            if let name = item.iconName {
                iconView.image = UIImage(named: name)
            }
            nameLabel.text = item.title
            contentLabel.text = item.content
            
            //if let count = item.count {
            //    contentLabel.isHidden = count == 0
            //} else {
            //    contentLabel.isHidden = true
           // }
            
            if item.dotType {
                dotView.isHidden = false
                countLabel.isHidden = true
                countLabel.text = " 0 "
                if let count = item.count {
                    dotView.isHidden = count == 0
                } else {
                    dotView.isHidden = true
                }
            } else {
                dotView.isHidden = true
                countLabel.isHidden = false
                
                if let count = item.count {
                    if count == 0 {
                        countLabel.isHidden = true
                    } else {
                        if count < 100 {
                            countLabel.text = " \(count) "
                        } else {
                            countLabel.text = " 99+ "
                        }
                    }
                } else {
                    countLabel.isHidden = true
                }
            }
            //dateLabel.text = DateTool.getNature(item.date)
        }
    }
    
    lazy var iconView: ImageView = {
        let one = ImageView()
        return one
    }()
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = kFontSubTitle
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var countLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 12)
        one.backgroundColor = UIColor.red
        one.layer.cornerRadius = 8
        one.clipsToBounds = true
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var dotView: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor.red
        one.layer.cornerRadius = 6
        one.clipsToBounds = true
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(dotView)
        iconView.IN(contentView).LEFT(12.5).CENTER.SIZE(45, 45).MAKE()
        nameLabel.RIGHT(iconView).OFFSET(10).TOP.MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(dateLabel).LEFT.OFFSET(-20).MAKE()
        dateLabel.IN(contentView).RIGHT(12.5).TOP(16).MAKE()
        contentLabel.BOTTOM(nameLabel).OFFSET(10).LEFT.MAKE()
        contentLabel.RIGHT.LESS_THAN_OR_EQUAL(countLabel).LEFT.OFFSET(-20).MAKE()
        
        dotView.IN(contentView).RIGHT(12.5 + 2).BOTTOM(17 + 2).SIZE(12, 12).MAKE()
        countLabel.IN(contentView).RIGHT(12.5).BOTTOM(17).SIZE(16, 16).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
