//
//  MeetingDetailViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeetingDetailViewController: LoadingViewController, UIWebViewDelegate {
    
    var meeting: Meeting!
    var done: LoadingDataDone?
    
    var canCollect: Bool = true
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        self.done = done
        if let urlString = meeting.url {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
                webView.loadRequest(request)
            } else {
                handleFailed()
                done(.err)
            }
        } else {
            handleFailed()
            done(.err)
        }
    }
    
    lazy var collectItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconTopKeepSelect", responder: { [unowned self] in
            self.handleCollect(collect: false)
        })
        return one
    }()
    
    lazy var disCollectItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconTopKeep", responder: { [unowned self] in
            self.handleCollect(collect: true)
            })
        return one
    }()
    
    
    var setNeedsUpdateCollect = true
    func checkOrLoadCollect() {
        
        if !Account.sharedOne.isLogin { return }
        if !setNeedsUpdateCollect { return }
        
        let me = Account.sharedOne.user
        removeRightNavItems()
        
        let id = "\(SafeUnwarp(meeting.id, holderForNull: 0))"
        
        MyselfManager.shareInstance.checkCollect(user: me, id: id, type: .conference, success: { [weak self] (code, msg, ret) in
            if code == 0 {
                self?.setNeedsUpdateCollect = false
                if ret {
                    self?.setupRightNavItems(items: self?.collectItem)
                } else {
                    self?.setupRightNavItems(items: self?.disCollectItem)
                }
                self?.checkOrHideCollect()
            }
        }) { (error) in
            print(error)
        }
    }
    
    func checkOrHideCollect() {
        if !self.canCollect {
            removeRightNavItems()
        }
    }
    
    func handleCollect(collect: Bool) {
        
        if !Account.sharedOne.isLogin { return }
        
        let meeting = self.meeting!
        let user = Account.sharedOne.user
        
        let collection = MyCollection()
        collection.type = .conference

        collection.targetId = "\(SafeUnwarp(meeting.id, holderForNull: 0))"
        collection.targetUrl = meeting.url
        collection.targetContent = meeting.name
        
        let s = DateTool.getDateString(meeting.startDate)
        let e = DateTool.getDateString(meeting.endDate)
        collection.targetDescri = SafeUnwarp(s, holderForNull: "-") + " 至 " + SafeUnwarp(e, holderForNull: "-")
        
        collection.targetImage = meeting.coverImage
        
        if collect {
            setupRightNavItems(items: collectItem)
        } else {
            setupRightNavItems(items: disCollectItem)
        }
        
        MyselfManager.shareInstance.collect(user: user, collect: collect, collection: collection, success: { [weak self] (code, msg, ret) in
            if code == 0 {
            } else {
                if collect {
                    self?.setupRightNavItems(items: self?.disCollectItem)
                } else {
                    self?.setupRightNavItems(items: self?.collectItem)
                }
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            if collect {
                self?.setupRightNavItems(items: self?.disCollectItem)
            } else {
                self?.setupRightNavItems(items: self?.collectItem)
            }
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
    lazy var webView: UIWebView = {
        let one = UIWebView()
        one.scalesPageToFit = true
        one.backgroundColor = kClrBackGray
        one.delegate = self
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "会议详情"
        setupNavBackBlackButton(nil)
        view.addSubview(webView)
        webView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        print(meeting.url ?? "")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
        checkOrLoadCollect()
    }
    
    func handleFailed() {
        QXTiper.showWarning("网址错误", inView: self.view, cover: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        showFailed("网页加载失败(\((error as NSError).code))")
//        done?(.err)
        let err = error as NSError
        if err.code == NSURLErrorCancelled {
            /// 页面跳转
        } else {
            showFailed("网页加载失败(\((error as NSError).code))")
            done?(.err)
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        done?(.noMore)
    }
    
}

