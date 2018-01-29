//
//  LoadingView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LoadingTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var loadingHeight: CGFloat = UIScreen.main.bounds.size.height - 64 - 49 {
        didSet {
            rowHeight = loadingHeight
            reloadData()
        }
    }
    
    var respondScroll: (() -> ())?
    
    lazy var cell: LoadingCell = LoadingCell()
    required init() {
        super.init(frame: CGRect.zero, style: .grouped)
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        dataSource = self
        delegate = self
        rowHeight = UIScreen.main.bounds.size.height - 64 - 49
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        respondScroll?()
    }
}

class LoadingCell: UITableViewCell {
    
    var respondReload: (()->())? {
        didSet {
            loadingView.respondReload = respondReload
        }
    }

    func showLoading() { loadingView.showLoading() }
    func showFailed(_ tip: String) { loadingView.showFailed(tip) }
    func showEmpty(_ tip: String) { loadingView.showEmpty(tip) }
    
    lazy var loadingView: LoadingView = {
        let one = LoadingView()
        one.showLoading()
        return one
    }()
    required init() {
        super.init(style: .default, reuseIdentifier: "cell")
        contentView.addSubview(loadingView)
        loadingView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(loadingView)
        loadingView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LoadingView: UIView {
    
    var respondReload: (()->())?
    
    func showLoading() {
        loadingView.isHidden = false
        tipView.isHidden = true
        failedView.isHidden = true
        emptyView.isHidden = true
        rotateForever(loadingView)
    }
    func showFailed(_ tip: String) {
        loadingView.isHidden = true
        tipView.isHidden = false
        failedView.isHidden = false
        emptyView.isHidden = true
        tipView.text = tip
    }
    func showEmpty(_ tip: String) {
        loadingView.isHidden = true
        tipView.isHidden = false
        failedView.isHidden = true
        emptyView.isHidden = false
        tipView.text = tip
    }
    
    lazy var tipView: UILabel = {
        let one = UILabel()
        one.textAlignment = .center
        one.font = UIFont.systemFont(ofSize: 15)
        one.textColor = UIColor.gray
        one.numberOfLines = 0
        return one
    }()
    
    lazy var loadingView: UIImageView = {
        let img = UIImage(named: "loading")
        let one = UIImageView(image: img)
        return one
    }()
    lazy var centerView: UIView = UIView()
    lazy var failedView: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "noNetwork")
        return one
    }()
    lazy var emptyView: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "noData")
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(centerView)
        addSubview(loadingView)
        addSubview(failedView)
        addSubview(emptyView)
        addSubview(tipView)
        centerView.IN(self).CENTER.MAKE()
        loadingView.IN(self).CENTER.SIZE(30, 30).MAKE()
        failedView.IN(centerView).TOP.SIZE(100, 78).CENTER.MAKE()
        emptyView.IN(centerView).TOP.SIZE(100, 78).CENTER.MAKE()
        tipView.BOTTOM(failedView).OFFSET(10).CENTER.SIZE(150, 40).MAKE()
        tipView.BOTTOM.EQUAL(centerView).MAKE()
        showLoading()
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondReload?()
    }
    
    func rotateForever(_ view: UIView) {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = CGFloat(M_PI * 2)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.duration = 1.5
        anim.repeatCount = MAXFLOAT
        view.layer.add(anim, forKey: "transform.rotation")
    }
    
}
