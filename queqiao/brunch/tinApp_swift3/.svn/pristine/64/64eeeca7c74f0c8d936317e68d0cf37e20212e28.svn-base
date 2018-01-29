//
//  SubRankListViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SubRankListViewController: RootTableViewController {
    
    var rankList: SubRankList!
    var subRankLists: [SubRankList] = [SubRankList]()
    var begin: Int = 0
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        let id = SafeUnwarp(rankList.id, holderForNull: 0)
        RankManager.shareInstance.getSubRankList(id, type: rankList.type, begin: begin, success: { [weak self] (code, msg, lists) in
            if code == 0 {
                if let s = self {
                    let lists = lists!
                    if s.begin == 0 {
                        s.subRankLists = lists
                    } else {
                        s.subRankLists += lists
                    }
                    s.begin += 20
                    done(s.checkOutLoadDataType(allModels: s.subRankLists, newModels: lists))
                    s.tableView.reloadData()
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
        }
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        resetFooter()
        begin = 0
        loadMore(done)
    }
    
    lazy var headView: SubRankListHeadView = {
        let one = SubRankListHeadView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: one.viewHeight)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headView
        tableView.register(SubRankListCell.self, forCellReuseIdentifier: "SubRankListCell")
        tableViewTopCons.constant = -20
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        emptyMsg = "当前榜单为空"
        setupRefreshHeader()
        setupRefreshFooter()
        
        setupCustomNav()
        customNavView.setupBackButton()
        customNavView.backBlackBtn.isHidden = true
        customNavView.respondBack = { [unowned self] in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.statusBarStyle = .lightContent
        customNavView.respondWhite = { [unowned self] in
            self.statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
        }
        customNavView.respondTransparent = { [unowned self] in
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
    }

    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        headView.title = rankList.name
    }
    
//    var navAlpha: CGFloat = 0
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let totalHeight = headView.imgH - 64
//        if offsetY > 0 {
//            navAlpha =  offsetY / totalHeight
//            navAlpha = min(navAlpha, 1)
//        } else {
//            navAlpha = 0
//        }
//        updateNav()
//    }
//    func updateNav() {
//        // 当 searchView 的背景接近白色时，状态栏的颜色变黑色
//        if navAlpha > 0.9 {
//            customNavView.title = "榜单"
//            customNavView.backBlackBtn.isHidden = false
//            customNavView.backWhiteBtn.isHidden = true
//        } else {
//            customNavView.title = ""
//            customNavView.backBlackBtn.isHidden = true
//            customNavView.backWhiteBtn.isHidden = false
//        }
//        setNeedsStatusBarAppearanceUpdate()
//        // 更新nav背景色
//        customNavView.changeAlpha(navAlpha)
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customNavView.title = "榜单"
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subRankLists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubRankListCell") as! SubRankListCell
        let list = subRankLists[indexPath.row]
        cell.subRankList = list
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SubRankListCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let subRankList = subRankLists[indexPath.row]
        if let type = subRankList.type {
            if type == .subRankList {
                let vc = SubRankListViewController()
                vc.rankList = subRankList
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = RankDetailViewController()
                vc.rankList = subRankList
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
}

class SubRankListCell: RootTableViewCell {
    var subRankList: SubRankList! {
        didSet {
            titleLabel.text = subRankList.name
        }
    }
    override class func cellHeight() -> CGFloat {
        return 55
    }
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrDeepGray
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        setupRightArrow()
        titleLabel.IN(contentView).LEFT(12.5).RIGHT(rightMargin + 20).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SubRankListHeadView: UIView {
    
    let imgH: CGFloat = kScreenW * 402 / 750
    
    var viewHeight: CGFloat { return imgH }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    lazy var backImageView: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "bdTopImg")
        return one
    }()
    lazy var titleBgView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBlack
        one.alpha = 0.3
        return one
    }()
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.boldSystemFont(ofSize: 16)
        one.textColor = UIColor.white
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(backImageView)
        addSubview(titleBgView)
        addSubview(titleLabel)
        backImageView.IN(self).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        titleBgView.IN(self).LEFT.BOTTOM.HEIGHT(40).WIDTH(kScreenW).MAKE()
        titleLabel.IN(titleBgView).LEFT(12.5).RIGHT(12.5).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
