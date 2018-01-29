//
//  RootBubbleListViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RootBubbleListViewController: RootTableViewController {
    
    var updateHeight: ((_ h: CGFloat) -> ())?
    var prepareHeight: ((_ h: CGFloat) -> ())?
    
    var headTitle: String? {
        didSet {
           headView.title = headTitle
        }
    }
    var headAttriTitle: NSAttributedString? {
        didSet {
            headView.attriTitle = headAttriTitle
        }
    }
    
    lazy var headView: RootBubbleListViewHeadView = {
        let one = RootBubbleListViewHeadView()
        return one
    }()
    lazy var footView: RootBubbleListViewFooterView = {
        let one = RootBubbleListViewFooterView()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = kClrWhite
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(headView)
        headView.IN(view).LEFT.RIGHT.TOP.HEIGHT(RootBubbleListViewHeadView.viewHeight()).MAKE()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: RootBubbleListViewHeadView.viewHeight() + 5))
        tableView.tableFooterView = footView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    var retainHeight: CGFloat {
        return RootBubbleListViewHeadView.viewHeight() + 5 + 20
    }
    
}

class RootBubbleListViewHeadView: UIView {
    class func viewHeight() -> CGFloat {
        return 54
    }
    var title: String? {
        didSet {
            label.text = title
        }
    }
    var attriTitle: NSAttributedString? {
        didSet {
            label.attributedText = attriTitle
        }
    }
    
    private lazy var label: UILabel = {
        let one = UILabel()
        one.font = UIFont.boldSystemFont(ofSize: 16)
        one.textColor = kClrDeepGray
        return one
    }()
    
    let breakLine = NewBreakLine
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: RootBubbleListViewHeadView.viewHeight()))
        addSubview(label)
        addSubview(breakLine)
        label.IN(self).LEFT(12.5).RIGHT(60).TOP.BOTTOM.MAKE()
        breakLine.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(0.5).MAKE()
        backgroundColor = kClrWhite
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RootBubbleListViewFooterView: UIView {
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
