//
//  MainSearchResultViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum MainSearchResultType: Int {
    case news = 0
    case events = 1 // 101
    case institutions = 2
    case enterprises = 3
    case users = 4
    case meetings = 5
}

class MainSearchResultItem {
    let title: String
    var items: [AnyObject] = [AnyObject]()
    var count: Int = 0
    var type: SearchType?
    var show: Bool = true
    init(title: String) {
        self.title = title
    }
    func update(_ dic: [String: Any]) {
        count = SafeUnwarp(dic.nullableInt("totalCount"), holderForNull: 0)
        //category = dic.nullableInt("category")
    }
}

class MainSearchResultsItem {
    
    var enterprisesItem = MainSearchResultItem(title: "企业")
    var eventsItem = MainSearchResultItem(title: "事件")
    var institutionsItem = MainSearchResultItem(title: "机构")
    var meetingsItem = MainSearchResultItem(title: "会议")
    var newsItem = MainSearchResultItem(title: "新闻")
    var usersItem = MainSearchResultItem(title: "人物")
    
    let count: Int = 6
    
    func update(_ dic: [String: Any]) {
        
        if let d = dic["enterprises"] as? [String: Any] {
            enterprisesItem.update(d)
            var enterprises:[EnterpriseViewModel] = [EnterpriseViewModel]()
            if let arr = d["items"] as? [[String: Any]] {
                for dic in arr {
                 let viewModel = EnterpriseViewModel()
                    let model = EnterpriseDataModel.objectWithKeyValues(dic as NSDictionary) as! EnterpriseDataModel
                    viewModel.model = model
                    enterprises.append(viewModel)
                }
            }
            enterprisesItem.type = .enterprise
            enterprisesItem.items = enterprises
        }
        
        if let d = dic["events"] as? [String: Any] {
            eventsItem.update(d)
            var viewModels = [CommonViewModel]()
            if let arr = d["items"] as? [[String: Any]] {
                for dic in arr {
                    let category = dic["category"] as? Int
                    if category == 5 {
                        let model = InvestEventDataModel.objectWithKeyValues(dic as NSDictionary) as! InvestEventDataModel
                        let viewModel = FinacingViewModel()
                        viewModel.model = model
                        viewModel.category = category
                        viewModels.append(viewModel)
                    }
                    if category == 6 {
                        let model = MergerDataModel.objectWithKeyValues(dic as NSDictionary) as! MergerDataModel
                        let viewModel = MergerViewModel()
                        viewModel.model = model
                        viewModel.category = category
                        viewModels.append(viewModel)
                    }
                    if category == 7 {
                        let model = ExitEventDataModel.objectWithKeyValues(dic as NSDictionary) as! ExitEventDataModel
                        let viewModel = ExitEventViewModel()
                        viewModel.model = model
                        viewModel.category = category
                        viewModels.append(viewModel)
                    }
                }
            }
            eventsItem.type = .combine
            eventsItem.items = viewModels
        }
        if let d = dic["institutions"] as? [String: Any] {
            institutionsItem.update(d)
            var insttutions:[InstitutionViewModel] = [InstitutionViewModel]()
            if let arr = d["items"] as? [[String: Any]] {
                for dic in arr {
                    let viewModel = InstitutionViewModel()
                    let model = InstitutionDataModel.objectWithKeyValues(dic as NSDictionary) as! InstitutionDataModel
                    viewModel.model = model
                    insttutions.append(viewModel)
                }
            }
            institutionsItem.type = .institution
            institutionsItem.items = insttutions
        }
        if let d = dic["meetings"] as? [String: Any] {
            meetingsItem.update(d)
            var meetings = [Meeting]()
            if let arr = d["items"] as? [[String: Any]] {
                for dic in arr {
                    let meeting = Meeting()
                    meeting.update(dic)
                    meetings.append(meeting)
                }
            }
            meetingsItem.type = .meeting
            meetingsItem.items = meetings
        }
        if let d = dic["news"] as? [String: Any] {
            newsItem.update(d)
            var newses = [News]()
            if let arr = d["items"] as? [[String: Any]] {
                for dic in arr {
                    let news = News(type: .news)
                    news.update(dic)
                    newses.append(news)
                }
            }
            newsItem.type = .news
            newsItem.items = newses
        }
        if let d = dic["users"] as? [String: Any] {
            usersItem.update(d)
            var viewModels = [PersonageViewModel]()
            if let arr = d["items"] as? [[String: Any]] {
                for dic in arr {
                    let viewModel = PersonageViewModel()
                    let model = PersonageDataModel.objectWithKeyValues(dic as NSDictionary) as! PersonageDataModel
                    viewModel.model = model
                    viewModels.append(viewModel)
                }
            }
            usersItem.type = .person
            usersItem.items = viewModels
        }
    }

}

class MainSearchResultViewController: RootTableViewController {
    
    var item: MainSearchResultsItem = MainSearchResultsItem()
    var respondScroll: (() -> ())?
    var searchKey: String?
    var respondType: ((_ type: SearchType, _ key: String, _ count: Int) -> ())?
    
    var respondCanFilt: ((_ can: Bool) -> ())?
    
    override func loadData(_ done: @escaping ((_ dataType: LoadDataType) -> ())) {
        if let key = searchKey {
            
            respondCanFilt?(false)
            
            CommonSearchManager.shareInstance.search(key, success: { [weak self] (code, msg, result) in
                if code == 0 {
                    let result = result!
                    self?.item = result
                    self?.tableView.reloadData()
                    if
                        result.enterprisesItem.count == 0 &&
                        result.eventsItem.count == 0 &&
                        result.enterprisesItem.count == 0 &&
                        result.institutionsItem.count == 0 &&
                        result.meetingsItem.count == 0 &&
                        result.newsItem.count == 0 &&
                        result.usersItem.count == 0 {
                        done(.empty)
                    } else {
                        done(.noMore)
                        self?.respondCanFilt?(true)
                    }
                    
                } else {
                    done(.err)
                }
            }) { (error) in
                done(.err)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.register(MeetingCell.self, forCellReuseIdentifier: "MeetingCell")
        tableView.register(InstitutionCell.self, forCellReuseIdentifier: "InstitutionCell")
        tableView.register(EnterpriseCell.self, forCellReuseIdentifier: "EnterpriseCell")
        tableView.register(FinancingCell.self, forCellReuseIdentifier: "FinancingCell")
        tableView.register(MergerCell.self, forCellReuseIdentifier: "MergerCell")
        tableView.register(ExitEventCell.self, forCellReuseIdentifier: "ExitEventCell")
        tableView.register(PersonageCell.self, forCellReuseIdentifier: "PersonageCell")

        tableView.register(MainSearchResultHeadView.self, forHeaderFooterViewReuseIdentifier: "MainSearchResultHeadView")
        
        setupLoadingView()
        setupRefreshHeader()
        loadDataOnFirstWillAppear = false
        
        emptyMsg = "未检索到数据"
    }
    

    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return item.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch MainSearchResultType(rawValue: section)! {
        case .enterprises:
            if item.enterprisesItem.show {
                return item.enterprisesItem.items.count
            } else {
                return 0
            }
        case .events:
            if item.eventsItem.show {
                return item.eventsItem.items.count
            } else {
                return 0
            }
        case .institutions:
            if item.institutionsItem.show {
                return item.institutionsItem.items.count
            } else {
                return 0
            }
        case .meetings:
            if item.meetingsItem.show {
                return item.meetingsItem.items.count
            } else {
                return 0
            }
        case .news:
            if item.newsItem.show {
                return item.newsItem.items.count
            } else {
                return 0
            }
        case .users:
            if item.usersItem.show {
                return item.usersItem.items.count
            } else {
                return 0
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch MainSearchResultType(rawValue: indexPath.section)! {
        case .enterprises:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnterpriseCell") as! EnterpriseCell
            cell.cellWidth = self.view.frame.width
            cell.viewModel = item.enterprisesItem.items[indexPath.row] as! EnterpriseViewModel
            cell.cellLine.isHidden = true
            cell.showBottomLine = !(indexPath.row == item.newsItem.items.count - 1)
            return cell
        case .events:
            let viewModel = item.eventsItem.items[indexPath.row] as? CommonViewModel
            if viewModel?.category == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FinancingCell") as! FinancingCell
                cell.cellWidth = self.view.frame.width
                cell.viewModel = viewModel as! FinacingViewModel
                cell.cellLine.isHidden = true
                cell.showBottomLine = !(indexPath.row == item.newsItem.items.count - 1)
                return cell
            }
            if viewModel?.category == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MergerCell") as! MergerCell
                cell.cellWidth = self.view.frame.width
                cell.viewModel = viewModel as! MergerViewModel
                cell.cellLine.isHidden = true
                cell.showBottomLine = !(indexPath.row == item.newsItem.items.count - 1)
                return cell
            }
            if viewModel?.category == 7{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExitEventCell") as! ExitEventCell
                cell.cellWidth = self.view.frame.width
                cell.viewModel = viewModel as! ExitEventViewModel
                cell.cellLine.isHidden = true
                cell.showBottomLine = !(indexPath.row == item.newsItem.items.count - 1)
                return cell
            }
            return UITableViewCell()
        case .institutions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InstitutionCell") as! InstitutionCell
            cell.cellWidth = self.view.frame.width
            cell.viewModel = item.institutionsItem.items[indexPath.row] as! InstitutionViewModel
            cell.cellLine.isHidden = true
            cell.showBottomLine = !(indexPath.row == item.institutionsItem.items.count - 1)
            return cell
        case .meetings:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell") as! MeetingCell
            cell.meeting = item.meetingsItem.items[indexPath.row] as! Meeting
            cell.showBottomLine = !(indexPath.row == item.meetingsItem.items.count - 1)
            return cell
        case .news:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
            cell.news = item.newsItem.items[indexPath.row] as! News
            cell.showBottomLine = !(indexPath.row == item.newsItem.items.count - 1)
            return cell
        case .users:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonageCell") as! PersonageCell
            cell.cellWidth = self.view.frame.width
            cell.viewModel = item.usersItem.items[indexPath.row] as! PersonageViewModel
            cell.cellLine.isHidden = true
            cell.showBottomLine = !(indexPath.row == item.newsItem.items.count - 1)
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch MainSearchResultType(rawValue: indexPath.section)! {
        case .enterprises:
            return 120
        case .events:
            if let model = item.eventsItem.items[indexPath.row] as? FinacingViewModel {
                return model.cellHeight!
            }
            if let model = item.eventsItem.items[indexPath.row] as? MergerViewModel {
                return model.cellHeight!
            }
            if let model = item.eventsItem.items[indexPath.row] as? ExitEventViewModel {
                return model.cellHeight!
            }
        case .institutions:
            let viewModel = item.institutionsItem.items[indexPath.row] as! InstitutionViewModel
            return viewModel.cellHeight!
        case .meetings:
            return MeetingCell.cellHeight()
        case .news:
            return NewsCell.cellHeight()
        case .users:
            let viewModel = item.usersItem.items[indexPath.row] as! PersonageViewModel
            return viewModel.cellHeight!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainSearchResultHeadView") as! MainSearchResultHeadView
        switch MainSearchResultType(rawValue: section)! {
        case .enterprises:
            view.item = item.enterprisesItem
            view.title = "企业 (\(SafeUnwarp(item.enterprisesItem.count, holderForNull: 0))条结果)"
            view.lineView.isHidden = item.enterprisesItem.items.count == 0
        case .events:
            view.item = item.eventsItem
            view.title = "事件 (\(SafeUnwarp(item.eventsItem.count, holderForNull: 0))条结果)"
            view.lineView.isHidden = item.eventsItem.items.count == 0
        case .institutions:
            view.item = item.institutionsItem
            view.title = "机构 (\(SafeUnwarp(item.institutionsItem.count, holderForNull: 0))条结果)"
            view.lineView.isHidden = item.institutionsItem.items.count == 0
        case .meetings:
            view.item = item.meetingsItem
            view.title = "会议 (\(SafeUnwarp(item.meetingsItem.count, holderForNull: 0))条结果)"
            view.lineView.isHidden = item.meetingsItem.items.count == 0
        case .news:
            view.item = item.newsItem
            view.title = "新闻 (\(SafeUnwarp(item.newsItem.count, holderForNull: 0))条结果)"
            view.lineView.isHidden = item.newsItem.items.count == 0
        case .users:
            view.item = item.usersItem
            view.title = "人物 (\(SafeUnwarp(item.usersItem.count, holderForNull: 0))条结果)"
            view.lineView.isHidden = item.usersItem.items.count == 0
        }
        view.respondItem = { [unowned self] item in
            if NotNull(self.searchKey) && NotNull(item.type) {
                let key = self.searchKey!
                let type = item.type!
                self.respondType?(type, key, item.count)
            }
        }
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let norH = MainSearchResultHeadView.viewHeight()
        switch MainSearchResultType(rawValue: section)! {
        case .enterprises:
            return (item.enterprisesItem.count == 0 || item.enterprisesItem.show == false) ? 0.0001 : norH
        case .events:
            return (item.eventsItem.count == 0 || item.eventsItem.show == false) ? 0.0001 : norH
        case .institutions:
            return (item.institutionsItem.count == 0 || item.institutionsItem.show == false) ? 0.0001 : norH
        case .meetings:
            return (item.meetingsItem.count == 0 || item.meetingsItem.show == false) ? 0.0001 : norH
        case .news:
            return (item.newsItem.count == 0 || item.newsItem.show == false) ? 0.0001 : norH
        case .users:
            return (item.usersItem.count == 0 || item.usersItem.show == false) ? 0.0001 : norH
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch MainSearchResultType(rawValue: section)! {
        case .enterprises, .events, .institutions, .news, .users:
            return 0.0001
        case .meetings:
            return 10
        }
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch MainSearchResultType(rawValue: indexPath.section)! {
        case .events:
            if let model = item.eventsItem.items[indexPath.row] as? FinacingViewModel {
                let vc = FinancingDetailViewController()
                vc.viewModel = model
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if let model = item.eventsItem.items[indexPath.row] as? MergerViewModel {
                let vc = MergerDetailViewController()
                vc.viewModel = model
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if let model = item.eventsItem.items[indexPath.row] as? ExitEventViewModel {
                let vc = ExitEventDetailViewController()
                vc.id = model.model.eventId!
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .enterprises:
            let model = item.enterprisesItem.items[indexPath.row] as! EnterpriseViewModel
            let vc = EnterpriseDetailViewController()
            vc.id = SafeUnwarp(model.model.id, holderForNull: "")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .institutions:
            let model = item.institutionsItem.items[indexPath.row] as! InstitutionViewModel
            let vc = InstitutionDetailViewController()
            vc.id = SafeUnwarp(model.model.id, holderForNull: "")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .users:
            if Account.sharedOne.user.author ==  .isAuthed{
                let model = item.usersItem.items[indexPath.row] as! PersonageViewModel
                let vc = PersonageDetailViewController()
                vc.id = SafeUnwarp(model.model.userId, holderForNull: "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                remindCertification()
            }
        case .meetings:
            let model = item.meetingsItem.items[indexPath.row] as! Meeting
            let vc = MeetingDetailViewController()
            vc.meeting = model
            self.navigationController?.pushViewController(vc, animated: true)

        case .news:
            let model = item.newsItem.items[indexPath.row] as! News
            let vc = NewsDetailViewController()
            vc.news = model
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        respondScroll?()
    }
}

class MainSearchResultHeadView: RootTableViewHeaderFooterView {
    
    var item: MainSearchResultItem!
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    fileprivate(set) var isBack: Bool = false
    func arrowBack(_ b: Bool) {
        isBack = b
        if b {
            let transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            arrowView.transform = transform
        } else {
            arrowView.transform = CGAffineTransform.identity
        }
    }
    
    var respondItem: ((_ item: MainSearchResultItem) -> ())?
    var respondBack: (() -> ())?

    override class func viewHeight() -> CGFloat {
        return 10 + 44
    }
    lazy var touchBack: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrWhite
        one.dowBgColor = kClrSlightGray
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            if self.isBack {
                self.respondBack?()
            } else {
                self.respondItem?(self.item)
            }
        })
        return one
    }()
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 15)
        one.textColor = kClrDarkGray
        return one
    }()
    lazy var arrowView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconListMore")
        return one
    }()
    lazy var lineView = NewBreakLine
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kClrBackGray
        contentView.addSubview(touchBack)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(lineView)
        touchBack.IN(contentView).LEFT.RIGHT.BOTTOM.HEIGHT(44).MAKE()
        arrowView.IN(touchBack).RIGHT(12.5).CENTER.SIZE(15, 15).MAKE()
        titleLabel.IN(touchBack).LEFT(12.5).CENTER.MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(arrowView).LEFT.OFFSET(-20).MAKE()
        lineView.IN(contentView).BOTTOM.LEFT(12.5).RIGHT.HEIGHT(0.5).MAKE()
        contentView.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
