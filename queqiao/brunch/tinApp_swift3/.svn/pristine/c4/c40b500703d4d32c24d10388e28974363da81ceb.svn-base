//
//  TouInMeetingViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TouInMeetingViewController: RootTableViewController {
    
    var items: [TouInMeetingItem] = [TouInMeetingItem]()
 
    override func loadData(_ done: @escaping LoadingDataDone) {
        MeetingManager.shareInstance.getTouInMeetingList({ [weak self] (code, msg, meetings) in
            if code == 0 {
                let meetings = meetings!
                if meetings.count > 0 {
                    done(.thereIsMore)
                } else {
                    done(.empty)
                }
                var items = [TouInMeetingItem]()
                for meeting in meetings {
                    let item = TouInMeetingItem(meeting: meeting)
                    items.append(item)
                }
                TouInMeetingItem.initForShow(items)
                self?.items = items
                self?.tableView.reloadData()
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
            }) { [weak self] (error) in
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                done(.err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "投中会议"
        setupNavBackBlackButton(nil)
        tableView.register(TouInMeetingCell.self, forCellReuseIdentifier: "TouInMeetingCell")
        setupLoadingView()
        //setupRefreshFooter()
        setupRefreshHeader()
        emptyMsg = "暂无相关数据"
        loadDataOnFirstWillAppear = true
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TouInMeetingCell") as! TouInMeetingCell
        cell.item = items[indexPath.row]
        cell.showBottomLine = !(indexPath.row == items.count - 1)
        cell.lineTop.isHidden = indexPath.row == 0
        cell.lineBottom.isHidden = indexPath.row == (items.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TouInMeetingCell.cellHeight()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let meeting = self.items[indexPath.row].meeting
        let vc = MeetingDetailViewController()
        vc.meeting = meeting
        self.navigationController?.pushViewController(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}


class TouInMeetingItem {
    let meeting: Meeting
    let isThisYear: Bool
    let year: Int?
    var isFristOfThisYear: Bool = true
    init(meeting: Meeting) {
        self.meeting = meeting
        year = DateTool.getSegDate(meeting.startDate)?.year
        if let year = year {
            isThisYear = (year == DateTool.getSegDate(Date())!.year)
        } else {
            isThisYear = false
        }
    }
    
    class func initForShow(_ items: [TouInMeetingItem]) {
        var year: Int = 0
        for item in items {
            let itemYear = SafeUnwarp(item.year, holderForNull: 0)
            if year == 0 {
                year = itemYear
                item.isFristOfThisYear = true
            } else {
                if itemYear == year {
                    item.isFristOfThisYear = false
                } else {
                    item.isFristOfThisYear = true
                    year = itemYear
                }
            }
        }
    }
}

class TouInMeetingCell: RootTableViewCell {
    
    override class func cellHeight() -> CGFloat {
        return 100
    }
    
    var item: TouInMeetingItem! {
        didSet {
            if let year  = item.year {
                yearLabel.text = String(format: "%04d", year)
                yearLabel.isHidden = !item.isFristOfThisYear
            } else {
                yearLabel.isHidden = true
            }
            
            titleLabel.text = item.meeting.name
            pictureView.fullPath = item.meeting.coverImage
            locationLabel.text = item.meeting.address
            
            let s = DateTool.getDateString(item.meeting.startDate)
            //let e = DateTool.getDateString(item.meeting.endDate)
            dateLabel.text = SafeUnwarp(s, holderForNull: "-") //+ " 至 " + SafeUnwarp(e, holderForNull: "-")
            if item.isThisYear {
                lineTop.isHidden = true
                yearLabel.backgroundColor = kClrOrange
            } else {
                lineTop.isHidden = false
                yearLabel.backgroundColor = kClrBlue
            }
            lineBottom.isHidden = false
        }
    }
    
    lazy var yearLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 15)
        one.textColor = kClrWhite
        one.textAlignment = .center
        one.clipsToBounds = true
        return one
    }()
    lazy var lineTop: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        return one
    }()
    lazy var lineBottom: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        return one
    }()
    
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
        
        contentView.addSubview(lineTop)
        contentView.addSubview(lineBottom)
        contentView.addSubview(yearLabel)

        contentView.addSubview(titleLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(locationIcon)
        contentView.addSubview(dateIcon)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        
        titleLabel.IN(contentView).LEFT(83).TOP(15).MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        pictureView.IN(contentView).LEFT(83).TOP(40).SIZE(96, 44).MAKE()
        locationIcon.RIGHT(pictureView).OFFSET(15).TOP(-5).SIZE(10, 10).MAKE()
        dateIcon.RIGHT(pictureView).OFFSET(15).BOTTOM(-5).SIZE(10, 10).MAKE()
        
        locationLabel.RIGHT(locationIcon).OFFSET(10).CENTER.MAKE()
        dateLabel.RIGHT(dateIcon).OFFSET(10).CENTER.MAKE()
        
        locationLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        dateLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        
        lineTop.CENTER_X.EQUAL(yearLabel).MAKE()
        lineTop.TOP.EQUAL(contentView).MAKE()
        lineTop.BOTTOM.EQUAL(yearLabel).CENTER_Y.MAKE()
        lineTop.WIDTH.EQUAL(1).MAKE()
        lineBottom.CENTER_X.EQUAL(yearLabel).MAKE()
        lineBottom.BOTTOM.EQUAL(contentView).MAKE()
        lineBottom.TOP.EQUAL(yearLabel).CENTER_Y.MAKE()
        lineBottom.WIDTH.EQUAL(1).MAKE()
        
        yearLabel.IN(contentView).LEFT(23).TOP(15).SIZE(40, 40).MAKE()
        yearLabel.layer.cornerRadius = 20
        bottomLineLeftCons?.constant = 83
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
