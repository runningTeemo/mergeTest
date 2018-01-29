//
//  RootFilterViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RootFilterViewController: RootTableViewController {
    
    var editChanged: Bool = false
    var showBottomView: Bool = true
    
    var items: [RootFilterSectionItem] = [RootFilterSectionItem]()
    
    func handleBlue() {  }
    func handleRed() {  }
    
    lazy var bottomView: UIView = {
        let one = UIView()
        one.addSubview(self.btnBlue)
        one.addSubview(self.btnRed)
        one.addSubview(self.bottomViewTopLine)
        self.btnBlue.IN(one).LEFT.TOP.BOTTOM.MAKE()
        self.btnRed.IN(one).RIGHT.TOP.BOTTOM.MAKE()
        self.btnRed.WIDTH.EQUAL(self.btnBlue).MAKE()
        self.btnBlue.RIGHT.EQUAL(self.btnRed).LEFT.MAKE()
        self.bottomViewTopLine.IN(one).LEFT.RIGHT.TOP.HEIGHT(0.5).MAKE()
        return one
    }()
    lazy var btnBlue: TitleButton = {
        let one = TitleButton()
        one.norTitleColor = HEX("#666666")
        one.dowTitleColor = HEX("#666666")
        one.norBgColor = HEX("#ffffff")
        one.dowBgColor = HEX("#ffffff")
        one.title = "重置"
        one.norTitlefont = UIFont.systemFont(ofSize: 17)
        one.dowTitlefont = UIFont.systemFont(ofSize: 17)
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.handleBlue()
        })
        return one
    }()
    lazy var btnRed: TitleButton = {
        let one = TitleButton()
        one.norTitleColor = kClrWhite
        one.dowTitleColor = kClrWhite
        one.norBgColor = kClrOrange
        one.dowBgColor = kClrOrange
        one.title = "完成"
        one.norTitlefont = UIFont.systemFont(ofSize: 17)
        one.dowTitlefont = UIFont.systemFont(ofSize: 17)
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.handleRed()
            })
        return one
    }()
    lazy var bottomViewTopLine = NewBreakLine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = kClrWhite
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44 + 20))
        
        tableViewTopCons.constant = -40

        tableView.register(RootFilterCell.self, forCellReuseIdentifier: "RootFilterCell")
        tableView.register(FilterSpaceCell.self, forCellReuseIdentifier: "FilterSpaceCell")
        tableView.register(FilterLabelsCell.self, forCellReuseIdentifier: "FilterLabelsCell")
        tableView.register(FilterInputCell.self, forCellReuseIdentifier: "FilterInputCell")
        tableView.register(FilterMoreCell.self, forCellReuseIdentifier: "FilterMoreCell")

        tableView.register(RootFilterHeadView.self, forHeaderFooterViewReuseIdentifier: "RootFilterHeadView")
        tableView.register(RootFilterFootView.self, forHeaderFooterViewReuseIdentifier: "RootFilterFootView")

        NotificationCenter.default.addObserver(self, selector: #selector(StaticCellBaseViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StaticCellBaseViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        view.addSubview(bottomView)
        bottomView.IN(view).LEFT.RIGHT.BOTTOM.HEIGHT(44).MAKE()
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if showBottomView {
            bottomView.isHidden = false
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44 + 20))
        } else {
            bottomView.isHidden = true
            tableView.tableFooterView = nil
        }
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RootFilterHeadView") as! RootFilterHeadView
        view.item = items[section]
        view.respondFoldChange = { [unowned self] in
            self.tableView.reloadData()
        }
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RootFilterHeadView.viewHeight()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RootFilterFootView") as! RootFilterFootView
        view.item = items[section]
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return RootFilterFootView.viewHeight()
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items[section].fold {
            return 0
        } else {
            return items[section].items.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section].items[indexPath.row]
        var clsStr = NSStringFromClass(type(of: item)) as NSString
        clsStr = clsStr.components(separatedBy: ".").last! as NSString
        clsStr = clsStr.replacingOccurrences(of: "Item", with: "Cell") as NSString
        let cell = tableView.dequeueReusableCell(withIdentifier: clsStr as String) as! RootFilterCell
        cell.item = item
        cell.tableView = tableView
        cell.indexPath = indexPath
        //cell.viewController = self
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section].items[indexPath.row]
        return item.cellHeight
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -40 && isDragging {
            view.endEditing(true)
        }
    }
    
    //MARK: keyboard
    
    fileprivate var origenFooterView: UIView?
    fileprivate var isSecondShow: Bool = false // 解决第三方键盘的多次弹出问题
    func keyboardWillShow(_ notice: Notification) {
        if (notice as NSNotification).userInfo == nil { return }
        if isSecondShow { return }
        isSecondShow = true
        // 解决第三方键盘的多次弹出问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.isSecondShow = false
        }
        let frame = (notice as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]
        if let f = frame {
            let v = f as! NSValue
            let rect = v.cgRectValue
            // 这里有tabBar则还要-49
            let endHeight = rect.size.height + 20
            if let footerView = tableView.tableFooterView {
                if !footerView.isKind(of: KeyboardSpaceView.self) {
                    origenFooterView = footerView
                }
            }
            let footerView = KeyboardSpaceView(frame: CGRect(x: 0,y: 0,width: 0,height: endHeight))
            tableView.tableFooterView = footerView
        }
    }
    
    func keyboardWillHide() {
        tableView.tableFooterView = origenFooterView
        origenFooterView = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension RootFilterViewController {
    
    /// 处理互斥选择
    func handleMutualSelect(_ idxes: [Int], lastIdx: Int, item: FilterLabelsItem) {
        var selectLatestOne: Bool = false
        for idx in idxes {
            if idx == lastIdx {
                selectLatestOne = true
            }
        }
        if selectLatestOne {
            item.selectIdxes = [lastIdx]
        } else {
            item.selectIdxes = idxes
        }
    }
    
    /// 处理多选
    func handleMutiSelectChange(_ idxes: [Int], lastIdx: Int, item: FilterLabelsItem) {
        if idxes.count == 0 {
            item.selectIdxes = [0]
            item.update()
            tableView.reloadData()
        } else {
            if lastIdx == 0 {
                if idxes.first! ==  0 {
                    item.selectIdxes = [0]
                } else {
                    item.selectIdxes = []
                }
                item.update()
                tableView.reloadData()
            } else {
                if idxes.first! ==  0 {
                    var _idexes = idxes
                    _idexes.remove(at: 0)
                    item.selectIdxes = _idexes
                } else {
                    item.selectIdxes = idxes
                }
                item.update()
                tableView.reloadData()
            }
        }
    }
    
    /// 获取选中的文字
    func getSelectStrings(_ item: FilterLabelsItem) -> [String] {
        var strs = [String]()
        for label in getSelectLabels(item) {
            if let name = label.name {
                strs.append(name)
            }
        }
        return strs
    }
    
    /// 获取选中的标签
    func getSelectLabels(_ item: FilterLabelsItem) -> [labelProtocol] {
        var labels = [labelProtocol]()
        if let _labels = item.labels {
            for idx in item.selectIdxes {
                let label = _labels[idx]
               labels.append(label)
            }
        }
        return labels
    }
    
    /// 重置label标签（选中第一个）
    func checkOrResetLabelItem(_ item: FilterLabelsItem) {
        guard let labels = item.labels else {
            return
        }
        if labels.count > 0 {
            item.selectIdxes = [0]
            item.update()
        }
    }
    
}


class RootFilterHeadView: RootTableViewHeaderFooterView {
    
    var item: RootFilterSectionItem! {
        didSet {
            myTitleLabel.text = item.title
            if item.fold {
                arrowView.transform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI))
            } else {
                arrowView.transform = CGAffineTransform.identity
            }
            arrowView.isHidden = !item.showArrow
            touchBg.isHidden = !item.canFold
        }
    }
    
    var respondFoldChange: (() -> ())?
    
    override class func viewHeight() -> CGFloat {
        return 50
    }
    lazy var touchBg: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            if self.item.canFold {
                self.item.fold = !self.item.fold
                self.respondFoldChange?()
            }
        })
        return one
    }()
    lazy var myTitleLabel: UILabel = {
        let one = UILabel()
        one.font = kFontNormal
        one.textColor = kClrDarkGray
        return one
    }()
    lazy var arrowView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconScreenMore")
        return one
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(touchBg)
        contentView.addSubview(myTitleLabel)
        contentView.addSubview(arrowView)
        myTitleLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        arrowView.IN(contentView).RIGHT(12.5).CENTER.SIZE(15, 15).MAKE()
        myTitleLabel.RIGHT.LESS_THAN_OR_EQUAL(arrowView).LEFT.OFFSET(-20).MAKE()
        touchBg.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RootFilterFootView: RootTableViewHeaderFooterView {
    
    var item: RootFilterSectionItem! {
        didSet {
            lineView.isHidden = !item.showBottomLine
        }
    }
    
    override class func viewHeight() -> CGFloat {
        return 0.5
    }
    lazy var lineView = NewBreakLine
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lineView)
        lineView.IN(contentView).LEFT.RIGHT.CENTER.HEIGHT(0.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
