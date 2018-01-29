//
//  MainSearchTypeResultViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/23.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MainSearchTypeResultViewController: RootTableViewController {
    
    var type: SearchType?
    var key: String?
    var totalCount: Int = 0
    
    var models: [AnyObject] = [AnyObject]()
    var loadingStatus: LoadStatus = .loading
    var dataStatus: LoadDataType = .thereIsMore

    var start: Int = 0
    var respondBack: (() -> ())?
    var respondScroll: (() -> ())?
    
    func initForNew() {
        loadingStatus = .loading
        models.removeAll()
    }
    
    override func handleLoadDone(_ dataType: LoadDataType) {
        self.setDataType(dataType)
        dataStatus = dataType
        if dataType == .noMore {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            self.tableView.mj_footer.endRefreshing()
        }
        tableView.reloadData()
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        tableView.reloadData()
        resetFooter()
        start = 0
        loadMore(done)
    }

    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        if Null(key) || Null(type) { return }
        
        loadingStatus = .loading
        CommonSearchManager.shareInstance.search(key!, type: type!, start: start, rows: 20, success: { [weak self] (code, msg, arr, totalCount) in
            if code == 0 {
                if let s = self {
                    let arr = arr!
                    let count = totalCount!
                    if s.start == 0 {
                        if arr.count > 0 {
                            done(.thereIsMore)
                        } else {
                            done(.empty)
                        }
                        s.models = s.modelsForArr(s.type!, arr: arr)
                    } else {
                        if arr.count > 0 {
                            done(.thereIsMore)
                        } else {
                            done(.noMore)
                        }
                        s.models += s.modelsForArr(s.type!, arr: arr)
                    }
                    s.totalCount = count
                    s.start += 20
                    if s.models.count > 0 {
                        s.loadingStatus = .done
                    } else {
                        s.loadingStatus = .doneEmpty
                    }
                    s.tableView.reloadData()
                }
            } else {
                self?.loadingStatus = .doneErr
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
        }) { [weak self] (error) in
            self?.loadingStatus = .doneErr
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
        }
    }
    
    func modelsForArr(_ type: SearchType, arr: [[String: Any]]) -> [AnyObject] {
        switch type {
        case .enterprise:
            var enterprises:[EnterpriseViewModel] = [EnterpriseViewModel]()
            for dic in arr {
                let viewModel = EnterpriseViewModel()
                let model = EnterpriseDataModel.objectWithKeyValues(dic as NSDictionary) as! EnterpriseDataModel
                viewModel.model = model
                enterprises.append(viewModel)
            }
            return enterprises
        case .combine:
            var viewModels = [CommonViewModel]()
            for dic in arr {
                let category = dic["category"]
                if (category as! Int) == 5 {
                    let model = InvestEventDataModel.objectWithKeyValues(dic as NSDictionary) as! InvestEventDataModel
                    let viewModel = FinacingViewModel()
                    viewModel.model = model
                    viewModel.category = category as! Int?
                    viewModels.append(viewModel)
                }
                if (category as! Int) == 6 {
                    let model = MergerDataModel.objectWithKeyValues(dic as NSDictionary) as! MergerDataModel
                    let viewModel = MergerViewModel()
                    viewModel.model = model
                    viewModel.category = category as! Int?
                    viewModels.append(viewModel)
                }
                if (category as! Int) == 7 {
                    let model = ExitEventDataModel.objectWithKeyValues(dic as NSDictionary) as! ExitEventDataModel
                    let viewModel = ExitEventViewModel()
                    viewModel.model = model
                    viewModel.category = category as! Int?
                    viewModels.append(viewModel)
                }
            }
            return viewModels
        case .institution:
            var viewModels:[InstitutionViewModel] = [InstitutionViewModel]()
            for dic in arr {
                let viewModel = InstitutionViewModel()
                let model = InstitutionDataModel.objectWithKeyValues(dic as NSDictionary) as! InstitutionDataModel
                viewModel.model = model
                viewModels.append(viewModel)
            }
            return viewModels
        case .meeting:
            var meetings = [Meeting]()
            for dic in arr {
                let meeting = Meeting()
                meeting.update(dic)
                meetings.append(meeting)
            }
            return meetings
        case .news:
            var news = [News]()
            for dic in arr {
                let n = News(type: .news)
                n.update(dic)
                news.append(n)
            }
            return news
        case .person:
            var viewModels = [PersonageViewModel]()
            for dic in arr {
                let viewModel = PersonageViewModel()
                let model = PersonageDataModel.objectWithKeyValues(dic as NSDictionary) as! PersonageDataModel
                viewModel.model = model
                viewModels.append(viewModel)
            }
            return viewModels
        default:
            return [AnyObject]()
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

        setupRefreshHeader()
        setupRefreshFooter()
        loadDataOnFirstWillAppear = false
        
        emptyMsg = "未查询到数据"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadingStatus != .done {
            return 1
        }
        return models.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loadingStatus != .done {
            if loadingStatus == .loading {
                loadingCell.showLoading()
            } else if loadingStatus == .doneErr {
                loadingCell.showFailed(kWebErrMsg)
            } else if loadingStatus == .doneEmpty {
                loadingCell.showEmpty("未查询到结果")
            }
            loadingCell.respondReload = { [unowned self] in
                self.loadData()
            }
            self.hideFooter(true)
            return loadingCell
        }
        
        self.hideFooter(false)
        
        if NotNull(key) && NotNull(type) {
            switch type! {
            case .enterprise:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EnterpriseCell") as! EnterpriseCell
                cell.cellWidth = self.view.frame.width
                cell.viewModel = models[indexPath.row] as! EnterpriseViewModel
                cell.cellLine.isHidden = true
                cell.showBottomLine = !(indexPath.row == models.count - 1)
                return cell

            case .combine:
                if let model = models[indexPath.row] as? FinacingViewModel {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FinancingCell") as! FinancingCell
                    cell.cellWidth = self.view.frame.width
                    cell.viewModel = model
                    cell.cellLine.isHidden = true
                    cell.cellWidth = self.view.frame.width
                    cell.showBottomLine = !(indexPath.row == models.count - 1)
                    return cell
                }
                if let model = models[indexPath.row] as? MergerViewModel {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MergerCell") as! MergerCell
                    cell.cellWidth = self.view.frame.width
                    cell.viewModel = model
                    cell.cellLine.isHidden = true
                    cell.cellWidth = self.view.frame.width
                    cell.showBottomLine = !(indexPath.row == models.count - 1)
                    return cell
                }
                if let model = models[indexPath.row] as? ExitEventViewModel {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ExitEventCell") as! ExitEventCell
                    cell.cellWidth = self.view.frame.width
                    cell.viewModel = model
                    cell.cellLine.isHidden = true
                    cell.cellWidth = self.view.frame.width
                    cell.showBottomLine = !(indexPath.row == models.count - 1)
                    return cell
                }
            case .institution:
                let cell = tableView.dequeueReusableCell(withIdentifier: "InstitutionCell") as! InstitutionCell
                cell.cellWidth = self.view.frame.width
                cell.viewModel = models[indexPath.row] as! InstitutionViewModel
                cell.cellLine.isHidden = true
                cell.showBottomLine = !(indexPath.row == models.count - 1)
                return cell
            case .meeting:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell") as! MeetingCell
                cell.meeting = models[indexPath.row] as! Meeting
                cell.showBottomLine = !(indexPath.row == models.count - 1)
                return cell
            case .news:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
                cell.news = models[indexPath.row] as! News
                cell.showBottomLine = !(indexPath.row == models.count - 1)
                return cell
            case .person:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonageCell") as! PersonageCell
                cell.cellWidth = self.view.frame.width
                cell.viewModel = models[indexPath.row] as! PersonageViewModel
                cell.cellLine.isHidden = true
                cell.showBottomLine = !(indexPath.row == models.count - 1)
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if loadingStatus != .done {
            return 200
        }
        
        if NotNull(key) && NotNull(type) {
            switch type! {
            case .enterprise:
                let viewModel = models[indexPath.row] as! EnterpriseViewModel                
                return viewModel.cellHeight!
            case .combine:
                if let model = models[indexPath.row] as? FinacingViewModel {
                    return model.cellHeight!
                }
                if let model = models[indexPath.row] as? MergerViewModel {
                    return model.cellHeight!
                }
                if let model = models[indexPath.row] as? ExitEventViewModel {
                    return model.cellHeight!
                }
            case .institution:
                let viewModel = models[indexPath.row] as! InstitutionViewModel
                return viewModel.cellHeight!
            case .meeting:
                return MeetingCell.cellHeight()
            case .news:
                return NewsCell.cellHeight()
            case .person:
                let viewModel = models[indexPath.row] as! PersonageViewModel
                return viewModel.cellHeight!
            default:
                return 0
            }
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MainSearchResultHeadView.viewHeight()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if NotNull(key) && NotNull(type) {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainSearchResultHeadView") as! MainSearchResultHeadView
            switch type! {
            case .enterprise:
                view.title = "企业 (\(totalCount)条结果)"
            case .combine:
                view.title = "事件 (\(totalCount)条结果)"
            case .institution:
                view.title = "机构 (\(totalCount)条结果)"
            case .meeting:
                view.title = "会议 (\(totalCount)条结果)"
            case .news:
                view.title = "新闻 (\(totalCount)条结果)"
            case .person:
                view.title = "人物 (\(totalCount)条结果)"
            default:
                break
            }
            //view.arrowBack(true)
            view.arrowView.isHidden = true
            view.respondBack = self.respondBack
            view.isUserInteractionEnabled = false
            return view
        } else {
            return UIView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        respondScroll?()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if let model = models[indexPath.row] as? FinacingViewModel {
            let vc = FinancingDetailViewController()
            vc.viewModel = model
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if let model = models[indexPath.row] as? MergerViewModel {
            let vc = MergerDetailViewController()
            vc.viewModel = model
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if let model = models[indexPath.row] as? ExitEventViewModel {
            let vc = ExitEventDetailViewController()
            vc.id = SafeUnwarp(model.model.eventId, holderForNull: "")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let model = models[indexPath.row] as? PersonageViewModel {
            if Account.sharedOne.user.author ==  .isAuthed{
                let vc = PersonageDetailViewController()
                vc.id = SafeUnwarp(model.model.userId, holderForNull: "")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                remindCertification()
            }
        }
        if let model = models[indexPath.row] as? EnterpriseViewModel {
            let vc = EnterpriseDetailViewController()
            vc.id = SafeUnwarp(model.model.id, holderForNull: "")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if let model = models[indexPath.row] as? InstitutionViewModel {
            let vc = InstitutionDetailViewController()
            vc.id = SafeUnwarp(model.model.id, holderForNull: "")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let model = models[indexPath.row] as? News {
            let vc = NewsDetailViewController()
            vc.news = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
