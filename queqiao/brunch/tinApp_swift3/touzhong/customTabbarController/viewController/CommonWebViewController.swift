//
//  CommonWebViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

//
//  MeetingDetailViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CommonWebViewController: LoadingViewController, UIWebViewDelegate {
    
    var url: String?
    var done: LoadingDataDone?
    
    var canCollect: Bool = true
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        self.done = done
        if let urlString = url {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
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
    
    lazy var webView: UIWebView = {
        let one = UIWebView()
        one.scalesPageToFit = true
        one.backgroundColor = kClrBackGray
        one.delegate = self
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "网址详情"
        setupNavBackBlackButton(nil)
        view.addSubview(webView)
        webView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
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

