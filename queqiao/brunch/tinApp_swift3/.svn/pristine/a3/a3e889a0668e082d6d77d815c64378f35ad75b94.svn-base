//
//  MeetingMainViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeetingMainViewController: RootTableViewController {
    
    var meetings: [Meeting] = [Meeting]()
    
    var searchType: MeetingType?
    var searchSort: MeetingSort = .time
    var searchOrder: MeetingOrderBy?
    
    var searchKeyWords: [String]?

    var searchWeekDay: Bool?
    var searchWeekEnd: Bool?
    var searchMeetDate: String?
    var searchKeyWord: String?
    var searchAddresses: [String]?
    var searchGuests: [String]?
    
    var loadingStatus: LoadStatus = .loading
    
    lazy var headView: MeetingHeadView = {
        let one = MeetingHeadView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: one.viewHeight)
        one.bannerView.respondSelect = { [unowned self] banner in
            let vc = CommonWebViewController()
            vc.url = banner.url
            vc.title = "会议详情"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.tinMeettingView.responder = { [unowned self] in
            let vc = TouInMeetingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.tagView.respondTag = { [unowned self] tag in
            if tag == 0 {
                self.searchSort = .time
                self.meetings.removeAll()
                self.refreshData()
            } else if tag == 1 {
                self.searchSort = .recommend
                self.meetings.removeAll()
                self.refreshData()
            } else {
                self.searchSort = .hot
                self.meetings.removeAll()
                self.refreshData()
            }
        }
        one.tagView.respondFilter = { [unowned self] in
            RootFilterShower.shareOne.show(onLeft: false, vc: self.filterVc, inVc: self, complete: nil)
        }
        return one
    }()
    
    lazy var filterVc: MeetingFilterViewController = {
        let one = MeetingFilterViewController()
        one.baseVc = self
        return one
    }()
    
    var lastDate: String?
    
    func loadMore(_ done: (() -> ())? = nil) {
        
        MeetingManager.shareInstance.getMeetingListNew(lastDate, rows: 20, keyword: searchKeyWord, type: searchType, sort: searchSort, order: searchOrder, weekDay: searchWeekDay, weekEnd: searchWeekEnd, meetDate: searchMeetDate, addresses: searchAddresses, guests: searchGuests, success: { [weak self] (code, msg, meetings) in
            if code == 0 || code == 1001 {
                if let s = self {
                    let meetings = meetings!
                    if meetings.count == 0 {
                        self?.loadingStatus = .doneEmpty
                    } else {
                        self?.loadingStatus = .done
                    }
                    if s.lastDate == nil {
                        s.meetings = meetings
                    } else {
                        s.meetings += meetings
                    }
                    s.lastDate = s.meetings.last?.dateForPaging
                }
                
            } else {
                self?.loadingStatus = .doneErr
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
            self?.tableView.reloadData()
            self?.updateFooter()

            done?()
        }) { [weak self] (error) in
            done?()
            self?.loadingStatus = .doneErr
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            self?.tableView.reloadData()
            self?.updateFooter()
        }
    }
    
    func refreshData(_ done: (() -> ())? = nil) {
        loadingStatus = .loading
        lastDate = nil
        tableView.reloadData()
        updateFooter()
        loadMore(done)
        
        bannerLoadSuccess = false
        checkOrRequestBanner()
        
        tinLoadSuccess = false
        checkOrRequestTin()
    }
    
    fileprivate var bannerLoadSuccess: Bool = false
    func checkOrRequestBanner() {
        if bannerLoadSuccess == false {
            MeetingManager.shareInstance.getBanners({ [weak self] (code, msg, banners) in
                if code == 0 {
                    self?.bannerLoadSuccess = true
                    if let banners = banners {
                        if banners.count > 0 {
                            self?.headView.bannerView.banners = banners
                        } else {
                            self?.headView.bannerView.banners = [Banner()]
                        }
                    }
                }
            }) { (error) in
            }
        }
    }
    
    fileprivate var tinLoadSuccess: Bool = false
    func checkOrRequestTin() {
        if tinLoadSuccess == false {
            MeetingManager.shareInstance.getTouInMeetingList({ [weak self] (code, msg, meetings) in
                if code == 0 {
                    let meetings = meetings!
                    if meetings.count == 0 {
                    } else if meetings.count == 1 {
                        self?.headView.tinMeettingView.label1.text = meetings[0].name
                        self?.headView.tinMeettingView.label2.text = nil
                    } else {
                        self?.headView.tinMeettingView.label1.text = meetings[0].name
                        self?.headView.tinMeettingView.label2.text = meetings[1].name
                    }
                }
                }, failed: { (error) in
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkOrRequestBanner()
        checkOrRequestTin()
        showNav()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "会议"
        setupNavBackBlackButton(nil)
        tableView.tableHeaderView = headView
        tableView.register(MeetingCell.self, forCellReuseIdentifier: "MeetingCell")
                
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.refreshData({ [weak self] in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
            })
            })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                self?.loadMore({ [weak self] in
                    guard let s = self else {
                        return
                    }
                    if s.loadingStatus == .doneEmpty {
                        s.tableView.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        s.tableView.mj_footer.endRefreshing()
                    }
                })
            })
    }
    
    /// 添加刷新尾
    lazy var footer: MJRefreshAutoNormalFooter = {
        let one =  MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadMore({ [weak self] in
                guard let s = self else {
                    return
                }
                if s.loadingStatus == .doneEmpty {
                    s.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    s.tableView.mj_footer.endRefreshing()
                }
            })
        })
        return one!
    }()
    func updateFooter() {
        if meetings.count > 0 {
            tableView.mj_footer = footer
        } else {
            tableView.mj_footer = nil
        }
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        refreshData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadingStatus != .done && meetings.count == 0 {
            return 1
        }
        return meetings.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if loadingStatus != .done && meetings.count == 0 {
            return 200
        }
        return MeetingCell.cellHeight()
    }
    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loadingStatus != .done && meetings.count == 0 {
            if loadingStatus == .doneEmpty {
                loadingCell.showEmpty(self.emptyMsg)
            } else if loadingStatus == .doneErr {
                loadingCell.showFailed(self.faliedMsg)
            } else {
                loadingCell.showLoading()
            }
            loadingCell.respondReload = { [unowned self] in
                self.refreshData()
            }
            return loadingCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell") as! MeetingCell
        cell.meeting = meetings[indexPath.row]
        cell.showBottomLine = !(indexPath.row == meetings.count - 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if loadingStatus != .done && meetings.count == 0 {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if loadingStatus == .done {
            let meeting = self.meetings[indexPath.row]
            let vc = MeetingDetailViewController()
            vc.meeting = meeting
            self.navigationController?.pushViewController(vc, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
                tableView?.deselectRow(at: indexPath, animated: false)
            }
        }
    }
}

class MeetingCell: RootTableViewCell {
    
    override class func cellHeight() -> CGFloat {
        return 120
    }
    
    var meeting: Meeting! {
        didSet {
            titleLabel.text = meeting.name
            Tools.setHighLightAttibuteColor(label: titleLabel, startStr: "<hlt>", endStr: "</hlt>", attributeFont: kFontNormal)
            
            pictureView.fullPath = meeting.coverImage
            locationLabel.text = meeting.address
            
            labelLabel.text = meeting.tags?.first
            
            let s = DateTool.getDateString(meeting.startDate)
            let e = DateTool.getDateString(meeting.endDate)
            dateLabel.text = SafeUnwarp(s, holderForNull: "-") + " 至 " + SafeUnwarp(e, holderForNull: "-")
        }
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = kFontNormal
        one.textColor = kClrDeepGray
        return one
    }()
    lazy var pictureView: ImageView = {
        let one = ImageView()
        return one
    }()
    lazy var labelIcon: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHyLabel")
        return one
    }()
    lazy var locationIcon: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHyAddress")
        return one
    }()
    lazy var dateIcon: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHyTime")
        return one
    }()
    
    lazy var labelLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        return one
    }()
    lazy var locationLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(labelIcon)
        contentView.addSubview(locationIcon)
        contentView.addSubview(dateIcon)
        contentView.addSubview(labelLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)

        titleLabel.IN(contentView).LEFT(12.5).TOP(15).MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        pictureView.IN(contentView).LEFT(12.5).TOP(40).SIZE(97, 64).MAKE()
        labelIcon.RIGHT(pictureView).OFFSET(15).TOP(-5).SIZE(10, 10).MAKE()
        locationIcon.RIGHT(pictureView).OFFSET(15).CENTER.SIZE(10, 10).MAKE()
        dateIcon.RIGHT(pictureView).OFFSET(15).BOTTOM(-5).SIZE(10, 10).MAKE()
        
        labelLabel.RIGHT(labelIcon).OFFSET(10).CENTER.MAKE()
        locationLabel.RIGHT(locationIcon).OFFSET(10).CENTER.MAKE()
        dateLabel.RIGHT(dateIcon).OFFSET(10).CENTER.MAKE()

        labelLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        locationLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        dateLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
