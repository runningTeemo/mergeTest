//
//  AddFriendsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/21.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class AddFriendsViewController: RootTableViewController {
    
    var items: [AddFriendItem] = [AddFriendItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加好友"
        tableView.register(AddFriendCell.self, forCellReuseIdentifier: "AddFriendCell")
        setupNavBackBlackButton(nil)

        let user = User()
        user.realName = "小明"
        user.company = "投中"
        let i = Industry()
        i.name = "电子商务"
        user.industries = [i, i, i, i, i, i, i, i, i, i, i, i]
        let item = AddFriendItem(user: user)
        
        items = [item, item, item, item, item, item]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendCell") as! AddFriendCell
        cell.item = items[indexPath.row]
        cell.showBottomLine = !(indexPath.row == items.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        
        print(item.cellHeight)
        return item.cellHeight
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}

class AddFriendItem {
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
        for i in user.industries {
            let item = RectSelectFixSizeItem()
            item.size = CGSize(width: 60 * kSizeRatio, height: 20 * kSizeRatio)
            item.norTitleFontSize = 9 * kSizeRatio
            item.selTitleFontSize = 9 * kSizeRatio
            item.norBorderWidth = 0.3
            item.selBorderWidth = 0.3
            item.showCornerImage = false
            if f {
                item.isSelect = true
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

class AddFriendCell: RootTableViewCell {
    var item: AddFriendItem! {
        didSet {
            iconView.iconView.fullPath = item.user.avatar
            nameLabel.text = item.user.realName
            companyLabel.text = item.user.company
            rectsView.item = item.attentionsItem
        }
    }
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
    lazy var rectsView: RectSelectsFixSizeView = {
        let one = RectSelectsFixSizeView()
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
        rectsView.RIGHT.EQUAL(handleBtn).LEFT.OFFSET(-20).MAKE()
        rectsView.BOTTOM.EQUAL(contentView).MAKE()
        
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
