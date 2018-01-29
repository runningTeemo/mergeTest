//
//  RankDetailViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RankDetailViewController: RootTableViewController {
    
    var rankList: SubRankList!
    var rankDetails: [RankDetail] = [RankDetail]()
    var begin: Int = 0
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        let id = SafeUnwarp(rankList.id, holderForNull: 0)
        RankManager.shareInstance.getRankDetail(id, type: rankList.type, begin: begin, success: { [weak self] (code, msg, details) in
            if code == 0 {
                if let s = self {
                    let details = details!
                    if s.begin == 0 {
                        s.rankDetails = details
                    } else {
                        s.rankDetails += details
                    }
                    s.begin += 20
                    done(s.checkOutLoadDataType(allModels: s.rankDetails, newModels: details))
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "榜单详情"
        setupNavBackBlackButton(nil)
        tableView.register(RankDetailTipHeader.self, forHeaderFooterViewReuseIdentifier: "RankDetailTipHeader")
        tableView.register(RankDetailCell.self, forCellReuseIdentifier: "RankDetailCell")
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        emptyMsg = "榜单为空"
        setupRefreshHeader()
        setupRefreshFooter()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RankDetailViewController.didRecieveTokenErrorNotification), name: kNotificationTokenErrorFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RankDetailViewController.didRecieveLogoutNotification), name: kNotificationLogout, object: nil)
    }
    func didRecieveTokenErrorNotification() {
        self.dismiss(animated: false, completion: nil)
        confirmToLoginVc(comeFromVc: self)
    }
    func didRecieveLogoutNotification() {
        self.dismiss(animated: false, completion: nil)
        confirmToLoginVc(comeFromVc: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankDetails.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankDetailCell") as! RankDetailCell
        cell.indexLabel.text = String(format: "%02d", indexPath.row + 1) + " "
        if indexPath.row == 0 {
            cell.indexLabel.textColor = HEX("#d61f26")
        } else if indexPath.row == 1 {
            cell.indexLabel.textColor = HEX("#3aaaf1")
        } else if indexPath.row == 2 {
            cell.indexLabel.textColor = HEX("#44c4c3")
        } else  {
            cell.indexLabel.textColor = HEX("#666666")
        }
        cell.rankDetail = rankDetails[indexPath.row]
        cell.showBottomLine = !(indexPath.row == rankDetails.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RankDetailCell.cellHeightForModel(rankDetails[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RankDetailTipHeader.viewHeight(title: rankList.name)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RankDetailTipHeader") as! RankDetailTipHeader
        view.title = rankList.name
        return view
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let detail = rankDetails[indexPath.row]
        let type = detail.rankType
        if type == .case || type == .institution || type == .person {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
        
        if !Account.sharedOne.isLogin {
            push2ToLoginVc(comeFromVc: self)
            return
        }
        
        let detail = rankDetails[indexPath.row]
        let type = detail.rankType
        if type == .case {
            if let id = detail.cvId {
                let vc = EnterpriseDetailViewController()
                vc.id = id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if type == .person {
            if let id = detail.cvId {
                if Account.sharedOne.user.author ==  .isAuthed{
                    let vc = PersonageDetailViewController()
                    vc.id = id
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    remindCertification()
                }
            }
        } else if type == .institution {
            if let id = detail.cvId {
                let vc = InstitutionDetailViewController()
                vc.id = id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

class RankDetailCell: RootTableViewCell {
    
    class func cellHeightForModel(_ rankDetail: RankDetail) -> CGFloat {
        if let type = rankDetail.rankType {
            switch type {
            case .institution:
                let w = kScreenW - 50 - 30 - 100 - 20
                let h = StringTool.size(rankDetail.name, font: UIFont.systemFont(ofSize: 16), maxWidth: w).size.height
                return max(30 + h + 30, 80)
            case .case:
                let wa = (kScreenW - 30 - 50 - 20 - 20) / 3
                let wb = wa * 2
                let ha = StringTool.size(rankDetail.name, font: UIFont.systemFont(ofSize: 16), maxWidth: wa).size.height
                let hb = StringTool.size(rankDetail.institutions, font: UIFont.systemFont(ofSize: 14), maxWidth: wb).size.height
                return max(30 + max(ha, hb) + 30, 80)
            case .other:
                let ws = kScreenW - 30 - 50 - 20
                let h = StringTool.size(rankDetail.name, font: UIFont.systemFont(ofSize: 16), maxWidth: ws).size.height
                return max(30 + h + 30, 80)
            default:
                return 80
            }
        }
        return 80
    }
    
    var rankDetail: RankDetail! {
        didSet {
            hideAll()
            if let type = rankDetail.rankType {
                switch type {
                case .institution:
                    otherIconView.isHidden = false
                    otherLabel.isHidden = false
                    otherIconView.fullPath = rankDetail.icon
                    otherLabel.text = rankDetail.name
                case .person:
                    userIconView.isHidden = false
                    userNameLabel.isHidden = false
                    userIconView.fullPath = rankDetail.icon
                    userNameLabel.text = rankDetail.name
                case .case:
                    labelA.isHidden = false
                    labelB.isHidden = false
                    labelA.text = rankDetail.name
                    labelB.text = rankDetail.institutions
                default:
                    singleLabel.isHidden = false
                    singleLabel.text = rankDetail.name
                }
            }
        }
    }
    
    lazy var indexLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.italicSystemFont(ofSize: 18)
        return one
    }()
    
    lazy var userIconView: RoundIconView = {
        let one = RoundIconView(type: .user)
        one.contentMode = UIViewContentMode.scaleAspectFill
        return one
    }()
    lazy var userNameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrDeepGray
        return one
    }()
    
    lazy var otherIconView: ImageView = {
        let one = ImageView(type: .none)
        one.contentMode = .scaleAspectFit
        return one
    }()
    lazy var otherLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrDeepGray
        one.textAlignment = .center
        one.numberOfLines = 0
        return one
    }()
    
    lazy var singleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrDeepGray
        one.textAlignment = .center
        return one
    }()
    
    lazy var labelA: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrDeepGray
        one.textAlignment = .center
        one.numberOfLines = 0
        return one
    }()
    lazy var labelB: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrGray
        one.textAlignment = .center
        one.numberOfLines = 0
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(indexLabel)
        indexLabel.IN(contentView).LEFT(20).TOP(30).MAKE()
        
        contentView.addSubview(userIconView)
        contentView.addSubview(userNameLabel)
        userIconView.RIGHT(indexLabel).OFFSET(32).CENTER.SIZE(35, 35).MAKE()
        userNameLabel.RIGHT(userIconView).OFFSET(19).CENTER.MAKE()
        userNameLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-20).MAKE()
        
        contentView.addSubview(otherIconView)
        contentView.addSubview(otherLabel)
        otherIconView.RIGHT(indexLabel).OFFSET(32).CENTER.SIZE(80, 35).MAKE()
        otherLabel.IN(contentView).LEFT(50 + 30 + 100).RIGHT(20).TOP(30).MAKE()
        
        contentView.addSubview(singleLabel)
        let ws = kScreenW - 30 - 50 - 20
        singleLabel.IN(contentView).LEFT(30 + 50).TOP(30).WIDTH(ws).MAKE()

        contentView.addSubview(labelA)
        contentView.addSubview(labelB)
        let wa = (kScreenW - 30 - 50 - 20 - 20) / 3
        let wb = wa * 2
        labelA.IN(contentView).LEFT(30 + 50).TOP(30).WIDTH(wa).MAKE()
        labelB.RIGHT(labelA).OFFSET(20).TOP.WIDTH(wb).MAKE()

        bottomLineLeftCons?.constant = 20
        
        //contentView.qxRamdomColorForAllViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideAll() {
        userIconView.isHidden = true
        userNameLabel.isHidden = true
        
        otherIconView.isHidden = true
        otherLabel.isHidden = true
        
        singleLabel.isHidden = true
        
        labelA.isHidden = true
        labelB.isHidden = true
    }
}

class RankDetailTipHeader: RootTableViewHeaderFooterView {
    class func viewHeight(title: String?) -> CGFloat {
        let size = StringTool.size(title, font: UIFont.systemFont(ofSize: 10), maxWidth: kScreenW - 20 * 2).size
        return size.height + 7 * 2
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 10)
        one.textColor = kClrGray
        one.textAlignment = .center
        one.numberOfLines = 0
        return one
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.IN(contentView).CENTER.LEFT(20).RIGHT(20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
