//
//  MyCareerInfoViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyCareerInfoViewController: StaticCellBaseViewController {
    
    var careers: [Career] = [Career]()
    var loadingStatus: LoadStatus = .loading
    
    override func clearFirstInStatus() {
        super.clearFirstInStatus()
        tableView.contentOffset = CGPoint.zero
        careers.removeAll()
        tableView.reloadData()
    }
    
    override func loadData() {
        loadingStatus = .loading
        tableView.reloadData()
        loadData({ [weak self] (dataType) in
            if let s = self {
                switch dataType {
                case .thereIsMore, .noMore:
                    s.loadingStatus = .done
                case .empty:
                    s.loadingStatus = .doneEmpty
                case .err:
                    s.loadingStatus = .doneErr
                }
                s.tableView.reloadData()
            }
            })
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {

        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let user = Account.sharedOne.user
        
        MyselfManager.shareInstance.getCareers(user: user, success: { [weak self] (code, msg, careers) in
            if code == 0 {
                let careers = careers!
                self?.careers = careers
                if careers.count > 0 {
                    done(.noMore)
                } else {
                    done(.empty)
                }
                self?.tableView.reloadData()
            } else {
                done(.err)
                QXTiper.showFailed(msg, inView: self?.view, cover: true)
            }
        
        }) { [weak self] (error) in
            done(.err)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var headView: MyCareerInfoHeadView = {
        let one = MyCareerInfoHeadView()
        one.frame = CGRect(x: 0, y: 0, width: 0, height: one.viewHeight)
        one.user = nil
        one.respondInfo = { [unowned self] in
            let vc = MeInformationViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var warningItem: StaticCellWarningItem = {
        let one = StaticCellWarningItem()
        one.text = "请补充第一条职业生涯信息后再继续添加"
        one.responder = { [unowned self] in
            if let career = self.careers.first {
                let vc = MyCareerEditViewController()
                vc.career = career
                vc.vcBefore = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return one
    }()
    lazy var titleItem: MyCareerInfoAddItem = {
        let one = MyCareerInfoAddItem()
        one.respondAdd = { [unowned self] in
            self.handleAdd()
        }
        return one
    }()

    func handleAdd() {
        if checkOrWarningFirstNotFull() {
            let vc = MyCareerEditViewController()
            vc.vcBefore = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkOrWarningFirstNotFull() -> Bool {
        if let career = careers.first {
            if career.startDate == nil {
                staticItems = [warningItem, titleItem]
                tableView.reloadData()
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTopCons.constant = -kScreenH
        
        tableView.tableHeaderView = headView
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MyCareerInfoAddCell.self, forCellReuseIdentifier: "MyCareerInfoAddCell")
        tableView.register(MyCareerCell.self, forCellReuseIdentifier: "MyCareerCell")
        
        staticItems = [spaceItem, titleItem]
        
        setupCustomNav()
        customNavView.changeAlpha(0)
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
        
        setupRefreshHeader()
        loadDataOnFirstWillAppear = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Account.sharedOne.isLogin {
            headView.user = Account.sharedOne.user
        }

        hideNav()
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        loadData()
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return staticItems.count
        } else {
            if loadingStatus == .done {
                return careers.count
            } else {
                return 1
            }
        }
    }

    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return super.tableView(tableView, cellForRowAt: indexPath)
        } else {
            if loadingStatus == .done {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyCareerCell") as! MyCareerCell
                cell.carreer = careers[indexPath.row]
                return cell
            } else {
                loadingCell.respondReload = { [unowned self] in
                    self.loadData()
                }
                if loadingStatus == .loading {
                    loadingCell.showLoading()
                } else if loadingStatus == .doneErr {
                    loadingCell.showFailed(kWebErrMsg)
                } else {
                    loadingCell.showEmpty("没有生涯数据，请点击添加")
                }
                return loadingCell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.section == 0 {
            super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        } else {
            if loadingStatus == .done {
                let career = careers[indexPath.row]
                let vc = MyCareerEditViewController()
                vc.vcBefore = self
                vc.career = career
                self.navigationController?.pushViewController(vc, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
                    tableView?.deselectRow(at: indexPath, animated: false)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return super.tableView(tableView, shouldHighlightRowAt: indexPath)
        } else {
            if loadingStatus == .done {
                return true
            } else {
                return false
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return super.tableView(tableView, heightForRowAt: indexPath)
        } else {
            if loadingStatus == .done {
                return MyCareerCell.cellHeight()
            } else {
                return kScreenH - headView.imgH - titleItem.cellHeight
            }
        }
    }
    
    var navAlpha: CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        customNavView.title = "我的生涯"
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }

}

class MyCareerCell: RootTableViewCell {
    
    var carreer: Career! {
        didSet {
            if carreer.endDate != nil {
                let begin = SafeUnwarp(DateTool.getCareerString(carreer.startDate), holderForNull: "未知时间")
                let end = SafeUnwarp(DateTool.getCareerString(carreer.endDate), holderForNull: "未知时间")
                dateLabel.text = begin + " 至 " + end
                iconView.image = UIImage(named: "myWorkold")
            } else {
                let begin = SafeUnwarp(DateTool.getCareerString(carreer.startDate), holderForNull: "未知时间")
                dateLabel.text = begin + " 至今"
                iconView.image = UIImage(named: "myWorkNew")
            }
            if let author = carreer.authorStatus {
                switch author {
                case .not:
                    authorLabel.text = "  未审核  "
                    authorLabel.backgroundColor = HEX("#9e9e9e")
                case .progressing:
                    authorLabel.text = "  审核中  "
                    authorLabel.backgroundColor = HEX("#9e9e9e")
                case .isAuthed:
                    authorLabel.text = "  已审核  "
                    authorLabel.backgroundColor = HEX("#fc9c55")
                case .failed:
                    authorLabel.text = "  审核失败  "
                    authorLabel.backgroundColor = HEX("#9e9e9e")
                }
            } else {
                authorLabel.text = "  未审核  "
                authorLabel.backgroundColor = HEX("#9e9e9e")
            }
            companyLabel.text = carreer.company
            possitionLabel.text = carreer.possition
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return 100
    }
    
    lazy var timerLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBreak
        return one
    }()
    
    lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "myWorkold")
        return one
    }()
    
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 12)
        one.textColor = RGBA(153, 153, 153, 255)
        return one
    }()
    lazy var companyLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 17)
        one.textColor = RGBA(51, 51, 51, 255)
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var authorLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 9)
        one.textColor = kClrWhite
        one.layer.cornerRadius = 6
        one.backgroundColor = HEX("#9e9e9e")
        one.clipsToBounds = true
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var possitionLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = RGBA(153, 153, 153, 255)
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(timerLine)
        contentView.addSubview(iconView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(possitionLabel)
        setupRightArrow()
        
        timerLine.IN(contentView).LEFT(20).TOP.BOTTOM.WIDTH(1).MAKE()
        iconView.IN(contentView).LEFT(12).TOP(10).SIZE(16, 16).MAKE()
        dateLabel.IN(contentView).LEFT(20 + 43).TOP(10).MAKE()
        companyLabel.IN(contentView).LEFT(20 + 43).TOP(30).MAKE()
        authorLabel.RIGHT(companyLabel).OFFSET(10).CENTER.HEIGHT(12).MAKE()
        possitionLabel.IN(contentView).LEFT(20 + 43).TOP(55).MAKE()
        
        dateLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-rightMargin).MAKE()
        authorLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-rightMargin).MAKE()
        possitionLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-rightMargin).MAKE()

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class MyCareerInfoAddItem: StaticCellBaseItem {
    var respondAdd: (() -> ())?
    override init() {
        super.init()
        cellHeight = 50
    }
}


class MyCareerInfoAddCell: StaticCellBaseCell {
    
    lazy var timerLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBreak
        return one
    }()
    lazy var timerLineBlock: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBlue
        return one
    }()
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = kFontSubTitle
        one.textColor = kClrTitle
        one.text = "职业生涯"
        return one
    }()
    lazy var addIcon: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "MyWorkAdd")
        return one
    }()
    lazy var addBtn: TitleButton = {
        let one = TitleButton()
        one.norTitlefont = UIFont.systemFont(ofSize: 15)
        one.dowTitlefont = UIFont.systemFont(ofSize: 15)
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.title = "添加"
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            if let item = self.item as? MyCareerInfoAddItem {
                item.respondAdd?()
            }
        })
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(timerLine)
        contentView.addSubview(timerLineBlock)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addIcon)
        contentView.addSubview(addBtn)
        
        timerLine.IN(contentView).LEFT(20).TOP(20).BOTTOM.WIDTH(1).MAKE()
        timerLineBlock.IN(contentView).LEFT(19).CENTER.SIZE(3, 16).MAKE()
        titleLabel.IN(contentView).LEFT(30).CENTER.MAKE()
        addBtn.IN(contentView).RIGHT.CENTER.WIDTH(70).HEIGHT(30).MAKE()
        addIcon.IN(contentView).RIGHT(55).CENTER.SIZE(15, 15).MAKE()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


