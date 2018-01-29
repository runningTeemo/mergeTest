//
//  PositionsPickerViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PositionsPickerViewController: LoadingViewController {
    
    var respondPossition: ((_ name: String?) -> ())?
    
    private var models: [PositionViewModel] = [PositionViewModel]()
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        DispatchQueue.global().async { [weak self] in
            var viewModels = [PositionViewModel]()
            for model in PositionsDataEntry.sharedOne.models {
                let vm = PositionViewModel(model: model)
                viewModels.append(vm)
            }
            viewModels.first!.isSelect = true
            self?.models = viewModels
            DispatchQueue.main.async { [weak self] in
                self?.update()
                done(.noMore)
            }
        }
    }
    
    private lazy var leftListView: PositionsListView = {
        let one = PositionsListView()
        one.isLeft = true
        return one
    }()
    
    private lazy var rightListView: PositionsListView = {
        let one = PositionsListView()
        one.isLeft = false
        return one
    }()
    
    private var leftIdx: Int = 0
    private lazy var whiteView: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor.white
        return one
    }()
    func update() {
        leftListView.models = models
        leftListView.tableView.reloadData()
        if models.count > 0 {
            let models = self.models[leftIdx].subModels
            rightListView.models = models
            
            let totalH = (kScreenH - 64 - 10)
            let cellH = PositionsCell.cellHeight() * CGFloat(models.count)
            rightListView.tableView.tableFooterView = nil
            if cellH < totalH {
                whiteView.frame = CGRect(x: 0, y: 0, width: 0, height: totalH - cellH)
                rightListView.tableView.tableFooterView = whiteView
            }
            
        } else {
            rightListView.models = nil
        }
        rightListView.tableView.reloadData()
    }
    
//    lazy var saveNavItem: BarButtonItem = {
//        let one = BarButtonItem(title: "确定", responder: { [unowned self] in
//            self.handleSave()
//        })
//        return one
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(leftListView)
        view.addSubview(rightListView)
        leftListView.IN(view).LEFT.WIDTH(130).TOP.BOTTOM.MAKE()
        rightListView.IN(view).RIGHT.TOP.BOTTOM.MAKE()
        leftListView.RIGHT.EQUAL(rightListView).LEFT.MAKE()
        
        title = "选择职位"
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupNavBackBlackButton(nil)
        
        //navigationItem.rightBarButtonItem = saveNavItem
        
        leftListView.respondSelect = { [unowned self] idx in
            for model in self.models {
                model.isSelect = false
            }
            let model = self.models[idx]
            model.isSelect = true
            self.leftIdx = idx
            
            let subModels = self.models[idx].subModels
            for model in subModels {
                model.isSelect = false
            }
            self.update()
        }
        
        rightListView.respondSelect = { [unowned self] idx in
            let subModels = self.models[self.leftIdx].subModels
            for model in subModels {
                model.isSelect = false
            }
            let model = subModels[idx]
            model.isSelect = true
            self.update()
            self.respondPossition?(model.model.name)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
//    func handleSave() {
//        if self.models.count > 0 {
//            let models = self.models[self.leftIdx].subModels
//            for model in models {
//                if model.isSelect {
//                    respondPossition?(model.model.name)
//                    self.navigationController?.popViewController(animated: true)
//                    return
//                }
//            }
//        }
//        respondPossition?(nil)
//        self.navigationController?.popViewController(animated: true)
//    }
    
}

class PositionViewModel {
    let model: PositionModel
    let subModels: [PositionViewModel]
    init(model: PositionModel) {
        self.model = model
        var cvms = [PositionViewModel]()
        for cm in model.childrens {
            let vc = PositionViewModel(model: cm)
            cvms.append(vc)
        }
        subModels = cvms

    }
    var isSelect: Bool = false
}

class PositionsListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var models: [PositionViewModel]?
    var isLeft: Bool = false
    var respondSelect: ((_ idx: Int) -> ())?
    
    lazy var tableView: UITableView = {
        let one = UITableView(frame: CGRect.zero, style: .grouped)
        one.delegate = self
        one.dataSource = self
        one.separatorEffect = nil
        one.separatorStyle = .none
        one.backgroundColor = kClrBackGray
        one.register(PositionsCell.self, forCellReuseIdentifier: "PositionsCell")
        one.register(RootTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "RootTableViewHeaderFooterView")
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(tableView)
        tableView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let models = self.models {
            return models.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PositionsCell") as! PositionsCell
        cell.isWhiteStyle = isLeft ? false : true
        cell.model = models![indexPath.row]
        cell.respondClick = { [unowned self] in
            self.respondSelect?(indexPath.row)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PositionsCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RootTableViewHeaderFooterView") as! RootTableViewHeaderFooterView
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RootTableViewHeaderFooterView") as! RootTableViewHeaderFooterView
        return view
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

class PositionsCell: RootTableViewCell {
    var isWhiteStyle: Bool = false
    var respondClick: (() -> ())?
    
    var model: PositionViewModel! {
        didSet {
            if isWhiteStyle {
                selectView.isHidden = false
                contentView.backgroundColor = kClrWhite
                if model.isSelect {
                    selectView.backgroundColor = HEX("#f2f2f2")
                    titleLabel.textColor = HEX("#d61f26")
                } else {
                    selectView.backgroundColor = kClrWhite
                    titleLabel.textColor = kClrDeepGray
                }
            } else {
                selectView.isHidden = true
                if model.isSelect {
                    titleLabel.textColor = kClrDeepGray
                    contentView.backgroundColor = kClrWhite
                } else {
                    titleLabel.textColor = HEX("#999999")
                    contentView.backgroundColor = HEX("#f2f2f2")
                }
            }
            titleLabel.text = model.model.name
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
    lazy var selectView: UIView = {
        let one = UIView()
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(selectView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(btnBg)
        titleLabel.IN(contentView).LEFT(12.5).TOP.BOTTOM.RIGHT(12.5).MAKE()
        selectView.IN(contentView).LEFT(10).TOP.BOTTOM.RIGHT(10).MAKE()
        btnBg.IN(contentView).LEFT.TOP.BOTTOM.RIGHT.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

