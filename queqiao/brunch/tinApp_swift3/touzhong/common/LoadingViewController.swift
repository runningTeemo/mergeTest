//
//  LoadingViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum LoadStatus {
    case loading
    case done
    case doneErr
    case doneEmpty
}

enum LoadDataType {
    case thereIsMore
    case noMore
    case empty
    case err
}

typealias LoadingDataDone = (_ dataType: LoadDataType)->()

/// 自带加载界面的控制器，可方便实现loading动画
class LoadingViewController: RootViewController {
    
    func loadData() {
        showLoading()
        loadData({ [weak self] (dataType) in
            if let s = self {
                s._dataType = dataType
                switch dataType {
                case .thereIsMore, .noMore:
                    s.showSuccess()
                case .empty:
                    s.showEmpty(s.emptyMsg)
                case .err:
                    s.showFailed(s.faliedMsg)
                }
            }
            })
    }
    
    var dataType: LoadDataType? { return _dataType }
    fileprivate var _dataType: LoadDataType?
    func setDataType(_ t: LoadDataType) {
        _dataType = t
    }
    
    /// 用于整个界面一个数据加载
    var loadDataOnFirstWillAppear: Bool = false
    func loadData(_ done: @escaping LoadingDataDone) {  done(.empty) }
    func loadMore(_ done: @escaping LoadingDataDone) {  done(.empty) }
    
    var faliedMsg: String = "哎呀，访问出错啦"
    var emptyMsg: String = "没有找到数据"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.backgroundColor = kClrBackGray
        setNeedsStatusBarAppearanceUpdate()
    }

    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if loadingTableViewAdded && loadDataOnFirstWillAppear {
            loadData()
        }
    }
    
    var loadingContentHeight: CGFloat = kScreenH - 64 - 49 {
        didSet {
            loadingTableView.loadingHeight = loadingContentHeight
        }
    }
    var loadingViewLeftCons: NSLayoutConstraint?
    var loadingViewRightCons: NSLayoutConstraint?
    var loadingViewTopCons: NSLayoutConstraint?
    var loadingViewBottomCons: NSLayoutConstraint?
    func setupLoadingView() {
        self.view.addSubview(loadingTableView)
        loadingViewLeftCons = loadingTableView.LEFT.EQUAL(view).MAKE()
        loadingViewRightCons = loadingTableView.RIGHT.EQUAL(view).MAKE()
        loadingViewTopCons = loadingTableView.TOP.EQUAL(view).MAKE()
        loadingViewBottomCons = loadingTableView.BOTTOM.EQUAL(view).MAKE()
        self.loadingTableViewAdded = true
        loadingTableView.isHidden = true
    }
    
    private var isLoading: Bool = false
    func showLoading() {
        if !loadingTableViewAdded { return }
        loadingTableView.isHidden = false
        loadingTableView.cell.showLoading()
        isLoading = true
    }
    func showFailed(_ msg: String) {
        if !loadingTableViewAdded { return }
        loadingTableView.isHidden = false
        loadingTableView.cell.showFailed(msg)
        isLoading = false
    }
    func showEmpty(_ msg: String) {
        if !loadingTableViewAdded { return }
        loadingTableView.isHidden = false
        loadingTableView.cell.showEmpty(msg)
        isLoading = false
    }
    func showSuccess() {
        loadingTableView.isHidden = true
        isLoading = false
    }
    
    func reload() { self.loadData() }
    fileprivate(set) var loadingTableViewAdded: Bool = false
    lazy var loadingTableView: LoadingTableView = {
        let one = LoadingTableView()
        one.cell.respondReload = { [weak self] in
            if let s = self {
                if !s.isLoading {
                    s.reload()
                }
            }
        }
        one.respondScroll = { [weak self] in
            self?.view.endEditing(true)
        }
        return one
    }()
    
    func checkOutLoadDataType(allModels: [AnyObject], newModels: [AnyObject]) -> LoadDataType {
        if allModels.count > 0 && newModels.count > 0 {
            return .thereIsMore
        } else if allModels.count > 0 && newModels.count == 0 {
            return .noMore
        } else if allModels.count == 0 && newModels.count > 0 {
            //assert(true, "错误的调用")
        } else {
            return .empty
        }
        return .err
    }
    

}
