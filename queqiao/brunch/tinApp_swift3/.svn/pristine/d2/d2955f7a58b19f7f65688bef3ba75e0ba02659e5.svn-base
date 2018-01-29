//
//  ArticleFilteCommon.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleFilteLeftViewController: RootTableViewController {
    
    func reset() {
        tableView.contentOffset = CGPoint.zero
        currentIdx = 1
        tableView.reloadData()
    }
    
    var titles = [String?]()
    var currentIdx: Int = 1

    var respondSelect: ((_ idx: Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ArticleFilteLeftCell.self, forCellReuseIdentifier: "ArticleFilteLeftCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleFilteLeftCell") as! ArticleFilteLeftCell
        cell.title = titles[indexPath.row]
        cell.isSelect = indexPath.row == currentIdx
        cell.respondClick = { [unowned self] in
            self.currentIdx = indexPath.row
            self.tableView.reloadData()
            self.respondSelect?(indexPath.row)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ArticleFilteLeftCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

class ArticleFilteLeftCell: RootTableViewCell {
    
    var respondClick: (() -> ())?
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var isSelect: Bool = false {
        didSet {
            if isSelect {
                titleLabel.textColor = kClrDeepGray
                contentView.backgroundColor = kClrWhite
            } else {
                titleLabel.textColor = HEX("#999999")
                contentView.backgroundColor = HEX("#f2f2f2")
            }
        }
    }
    override class func cellHeight() -> CGFloat {
        return 40
    }
    
    lazy var btnBg: UIButton = {
        let one = UIButton()
        one.addTarget(self, action: #selector(PositionsCell.btnClick), for: .touchUpInside)
        return one
    }()
    func btnClick() {
        respondClick?()
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = UIFont.systemFont(ofSize: 14)
        one.textAlignment = .center
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(btnBg)
        titleLabel.IN(contentView).LEFT(12.5).TOP.BOTTOM.RIGHT(12.5).MAKE()
        btnBg.IN(contentView).LEFT.TOP.BOTTOM.RIGHT.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
