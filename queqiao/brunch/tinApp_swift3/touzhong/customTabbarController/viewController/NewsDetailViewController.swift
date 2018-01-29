//
//  NewsDetailViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
import JavaScriptCore


enum NewsDetailFontType {
    case medium
    case large
    case small
}

class NewsDetailViewController: LoadingViewController, UIGestureRecognizerDelegate, UIWebViewDelegate,TSWebViewDelegate {

    
    var news: News!
    var isSelect: Bool = false
    
    var done: LoadingDataDone?
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        self.done = done
        if let urlString = news.url {
            let size: String
            if let _size = UserDefaults.standard.value(forKey: kUserDefaultKeyFontSize) as? String {
                size = _size
            } else {
                size = "M"
            }
            let newStr = urlString + "&fontSize=" + size
            print(newStr)
            if let url = URL(string: newStr) {
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
    
    lazy var webView: UIWebView = {
        let one = UIWebView()
        one.scalesPageToFit = true
        one.backgroundColor = kClrBackGray
        one.delegate = self
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(NewsDetailViewController.pinch(_:)))
        pinch.delegate = self
        one.addGestureRecognizer(pinch)
        return one
    }()
    func pinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .ended {
            if recognizer.scale > 1 {
                largerFont()
            } else {
                smallerFont()
            }
        }
    }
    
    lazy var fontType: NewsDetailFontType = {
        if let _size = UserDefaults.standard.value(forKey: kUserDefaultKeyFontSize) as? String {
            if _size == "L" {
                return .large
            } else if _size == "M" {
                return .medium
            } else if _size == "S" {
                return .small
            }
        }
        return .medium
    }()
    func smallerFont(){
        switch fontType {
        case .large:
            self.webView.stringByEvaluatingJavaScript(from: "Application.adjustFontSize('M')");
            fontType = .medium
            showScale(msg: "中")
        case .medium:
            self.webView.stringByEvaluatingJavaScript(from: "Application.adjustFontSize('S')");
            fontType = .small
            showScale(msg: "小")
        default:
            break
        }
    }
    func largerFont(){
        switch fontType {
        case .small:
            self.webView.stringByEvaluatingJavaScript(from: "Application.adjustFontSize('M')");
            fontType = .medium
            showScale(msg: "中")
        case .medium:
            self.webView.stringByEvaluatingJavaScript(from: "Application.adjustFontSize('L')");
            fontType = .large
            showScale(msg: "大")
        default:
            break
        }
    }
    
    lazy var barView: NewsDetailCommentBar = {
        let one = NewsDetailCommentBar()
        one.respondComment = { [unowned self] text in
            self.handleComment(text)
        }
        one.respondToComment = { [unowned self] in
            let vc = NewsCommentViewController()
            vc.news = self.news
            vc.respondUpdate = { [unowned self] in
                self.setNeedsUpdateDetail = true
                self.checkOrLoadDetail()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondCollect = { [unowned self] in
            self.handleCollect()
        }
        return one
    }()
    
    var barViewBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBackBlackButton(nil)
        view.addSubview(webView)
        webView.IN(view).LEFT.RIGHT.TOP.BOTTOM(48).MAKE()
        
        view.addSubview(barView)
        
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).MAKE()
        
        view.addSubview(scaleTipView)
        scaleTipView.IN(webView).CENTER.SIZE(150, 100).MAKE()
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsDetailViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewsDetailViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsDetailViewController.didRecieveTokenErrorNotification), name: kNotificationTokenErrorFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewsDetailViewController.didRecieveLogoutNotification), name: kNotificationLogout, object: nil)
        
        view.bringSubview(toFront: barView)
        
    }
    
    func didRecieveTokenErrorNotification() {
        self.dismiss(animated: false, completion: nil)
        confirmToLoginVc(comeFromVc: self)
    }
    func didRecieveLogoutNotification() {
        self.dismiss(animated: false, completion: nil)
        confirmToLoginVc(comeFromVc: self)
    }
    
    lazy var shareItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconTopShareBlack", responder: { [unowned self] in
            self.handleShare()
            })
        return one
    }()
    //MARK:分享
    func handleShare(){
        if let info = news.shareInfo {
            let vc = ShareViewController()
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.info = info
             self.present(vc, animated: true) {
                
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if news.type == .news {
            title = "新闻详情"
        } else {
            title = "报告详情"
        }
        barView.collectButton.forceDown(!Account.sharedOne.isLogin)
        
        if let _ = news.shareInfo {
            setupRightNavItems(items: shareItem)
        } else {
            removeRightNavItems()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkOrLoadDetail()
        showNav()
    }
    
    var setNeedsUpdateDetail = true
    func checkOrLoadDetail() {
        if !setNeedsUpdateDetail { return }
        var userId: String? = nil
        if Account.sharedOne.isLogin {
            userId = Account.sharedOne.user.id
        }
        
        barView.collectButton.forceDown(true)
        
        CommentManager.shareInstance.getNewsDetail(news.type, userId: userId, newsId: SafeUnwarp(news.id, holderForNull: 0), success: { [weak self] (code, message, commentCount, isFav) in
            if code == 0 {
                self?.setNeedsUpdateDetail = false
                self?.barView.setCount(commentCount)
                self?.barView.setCollect(isFav)
                self?.isSelect = isFav
                if Account.sharedOne.isLogin {
                    self?.barView.collectButton.forceDown(false)
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    func handleFailed() {
        QXTiper.showWarning("网址错误", inView: self.view, cover: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        }
    }
    //MARK:Action
//    
//    func webView(_ webView: UIWebView!, didCreateJavaScriptContext ctx: JSContext!) {
//        OCDatamanager.setupContext(ctx, forKey: "shaliwa") { [weak self] str in
//            print(str)
//            if str != nil {
//                let json = JSON.parse(str!)
//                let tagId = SafeUnwarp(json["tagId"].string, holderForNull: "")
//                let tagType = SafeUnwarp(json["tagType"].string, holderForNull: "")
//                let x:CGFloat = CGFloat(json["x"].floatValue)
//                let y:CGFloat = CGFloat(json["y"].floatValue)
//                if tagId.characters.count > 0 && tagId.characters.count > 0 && tagType.characters.count > 0 {
//                    DispatchQueue.main.async { [weak self] in
//                        self?.tryOrShowTipVc(tagType: tagType, tagId: tagId, x:x, y: y)
//                    }
//                }
//            }
//        }
//        
//        OCDatamanager.setupContext(ctx, forKey: "reqDone") { [weak self] str in
//            if SafeUnwarp(str, holderForNull: "") == "1" {
//                self?.performLoadSuccess()
//            } else {
//                self?.performLoadFailed(err: nil)
//            }
//        }
//    }
    
    func tryOrShowTipVc(tagType:String,tagId:String,x:CGFloat,y:CGFloat){
        
        if Account.sharedOne.isLogin {
            let vc = NewsAlertViewController()
            let nav = RootNavigationController(rootViewController:vc)
            nav.modalPresentationStyle = .custom
            nav.transitioningDelegate = self
            let point = CGPoint(x: x, y: y)
            vc.anrchPoint = point
            vc.tagtId = tagId
            vc.tagType = tagType
            self.getData(tagType: tagType, tagId: tagId, x: x, y: y, vc: vc)
        } else {
            self.push2ToLoginVc(comeFromVc: self)
        }
        
    }
    
    func getData(tagType:String,tagId:String,x:CGFloat,y:CGFloat,vc:NewsAlertViewController) {
        weak var ws = self
        let vc = NewsAlertViewController()
        let nav = RootNavigationController(rootViewController:vc)
        nav.modalPresentationStyle = .custom
        nav.transitioningDelegate = self
        let point = CGPoint(x: x, y: y)
        vc.anrchPoint = point
        vc.tagtId = tagId
        vc.tagType = tagType
        if tagType == "1"{//机构
            DataListManager.shareInstance.getInstitutionCue(tagId, success: { (code, message, data) in
                if code == 0{
                    vc.institutionViewModel = data!
//                    vc.institutionView.institutionViewModel = data!
                    ws?.present(nav, animated: true) {
                    }
                }else if code == SIGNERRORCODE{
                    Account.sharedOne.logout()
                }
            }) { (error) in
                debugPrint(error)
            }
        }
        if tagType == "2"{//企业
            DataListManager.shareInstance.geteEnterpriseCue(tagId, success: { (successTuple) in
                if successTuple.code == 0{
                    //  ws?.endRefresh(.done, view: nil, message: nil)
                    let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                    if let dataDic = data{
                        let viewModel = EnterpriseCueViewModel()
                        let investDic = dataDic["events"] as? [Dictionary<String,AnyObject>]
                        let model = EnterpriseCueDataModel.objectWithKeyValues(dataDic as NSDictionary) as! EnterpriseCueDataModel
                        if investDic != nil{
                            model.parseEventsModel(investEvents:investDic!)
                        }
                        viewModel.model = model
                        vc.enterpriseViewModel = viewModel
                       // vc.enterpriseView.enterpriseViewModel = viewModel
                        ws?.present(nav, animated: true) {
                        }
                    }
                }else if successTuple.code == SIGNERRORCODE{
                    Account.sharedOne.logout()
                }
            }) { (error) in
                
            }
        }
        if tagType == "3"{//人物
            DataListManager.shareInstance.getePersonageDetail(tagId, success: { (code, message, data) in
                if code == 0{
//                    vc.personageView.personageViewModel = data!
                    vc.personageViewModel = data!
                    ws?.present(nav, animated: true) {
                    }
                }else if code == SIGNERRORCODE{
                    Account.sharedOne.logout()
                }
            }) { (error) in
               
            }
        }
    }

    
    
    func keyboardWillShow(_ notice: Notification) {
        if (notice as NSNotification).userInfo == nil { return }
        let frame = ((notice as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant =  -frame.size.height
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            })
    }
    func keyboardWillHide(_ notice: Notification) {
        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant = 0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            })
    }
    
    func handleComment(_ text: String) {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.comment(text)
        }
    }
    
    func comment(_ text: String) {
        let wait = QXTiper.showWaiting("评论中...", inView: view, cover: true)
        let targetId = "\(SafeUnwarp(news.id, holderForNull: 0))"
        CommentManager.shareInstance.saveComment(.news, userId: Account.sharedOne.optionalUserId, replayUserId: nil, targetId: targetId, content: text, newsBref: news.title, success: { [weak self] (code, message, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                self?.barView.commentField.textField.text = nil
                QXTiper.showSuccess("评论成功", inView: self?.view, cover: true)
                self?.setNeedsUpdateDetail = true
                self?.checkOrLoadDetail()
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func handleCollect() {
        
        if !Account.sharedOne.isLogin { return }
        
        let news = self.news!
        let user = Account.sharedOne.user
        let isSelect = !self.isSelect
        
        let collection = MyCollection()
        if news.type == .news {
            collection.type = .news
            collection.targetDescri = news.introduction
        } else {
            collection.type = .report
            if NotNullText(news.author) && NotNullText(news.introduction) {
                collection.targetDescri = news.author! + " " + news.introduction!
            } else if NotNullText(news.author) {
                collection.targetDescri = news.author
            } else if NotNullText(news.introduction) {
                collection.targetDescri = news.introduction
            } else {
                collection.targetDescri = nil
            }
        }
        collection.targetId = "\(SafeUnwarp(news.id, holderForNull: 0))"
        collection.targetUrl = news.url
        collection.targetContent = news.title
        collection.targetImage = news.coverImage
        
        barView.collectButton.forceDown(true)
        barView.setCollect(isSelect)
        
        MyselfManager.shareInstance.collect(user: user, collect: isSelect, collection: collection, success: { [weak self] (code, msg, ret) in
            self?.barView.collectButton.forceDown(false)
            if code == 0 {
                self?.isSelect = isSelect
            } else {
                self?.barView.setCollect(!isSelect)
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            self?.barView.collectButton.forceDown(false)
            self?.barView.setCollect(!isSelect)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func performLoadSuccess() {
        done?(.noMore)
    }
    func performLoadFailed(err: NSError?) {
        if let err = err {
            showFailed("网页加载失败(\((err as NSError).code))")
        } else {
            showFailed("网页加载失败")
        }
        done?(.err)
    }

    //MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    //MARK: UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        if let ctx = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            OCDatamanager.setupContext(ctx, forKey: "shaliwa") { [weak self] str in
                if str != nil {
                    let json = JSON.parse(str!)
                    let tagId = SafeUnwarp(json["tagId"].string, holderForNull: "")
                    let tagType = SafeUnwarp(json["tagType"].string, holderForNull: "")
                    let x:CGFloat = CGFloat(json["x"].floatValue)
                    let y:CGFloat = CGFloat(json["y"].floatValue)
                    if tagId.characters.count > 0 && tagId.characters.count > 0 && tagType.characters.count > 0 {
                        DispatchQueue.main.async { [weak self] in
                            self?.tryOrShowTipVc(tagType: tagType, tagId: tagId, x:x, y: y)
                        }
                    }
                }
            }
            OCDatamanager.setupContext(ctx, forKey: "reqDone") { [weak self] str in
                if SafeUnwarp(str, holderForNull: "") == "1" {
                    self?.performLoadSuccess()
                } else {
                    self?.performLoadFailed(err: nil)
                }
            }
            OCDatamanager.setupContext(ctx, forKey: "relNews") { [unowned self] str in
                if let news = self.stringToNews(str) {
                    DispatchQueue.main.async { [weak self] in
                        let vc = NewsDetailViewController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.news = news
                        _ = self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func stringToNews(_ str: String?) -> News? {
        
        if let str = str {
            if let data = str.data(using: .utf8) {
                do {
                    let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let dic = obj as? [String: Any] {
                        let news = News(type: .news)
                        news.update(dic)
                        return news
                    }
                } catch {
                    print(error)
                }
            }
        }
        return nil
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let err = error as NSError
        if err.code == NSURLErrorCancelled {
            /// 页面跳转
        } else {
            performLoadFailed(err: error as NSError?)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        performLoadSuccess()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer?.remove()
    }
    
    /// 字体缩放指示器
    func showScale(msg: String) {
        if !timerStarted {
            timerStarted = true
            startTimer()
        }
        counter = 10
        scaleTipView.isHidden = false
        scaleTipView.sizeLabel.text = msg
    }
    private var timerStarted: Bool = false
    private lazy var scaleTipView: SacleTipView = {
        let one = SacleTipView()
        one.frame = CGRect(x: 100, y: 200, width: 150, height: 100)
        return one
    }()
    private var counter: Int = 10
    private func handleLoop() {
        counter -= 1
        if counter < 0 {
            scaleTipView.isHidden = true
            endTimer()
        }
    }
    private var timer: QXTimer?
    private func startTimer() {
        timer = QXTimer(triggerCount: 6, runLoop: .main, mode: .commons)
        timer?.loop = { [weak self] t in
            self?.handleLoop()
        }
    }
    private func endTimer() {
        timerStarted = false
        timer?.remove()
    }
    
}


class SacleTipView: UIView {
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = UIFont.systemFont(ofSize: 14)
        one.textAlignment = .center
        one.text = "正文字体"
        return one
    }()
    
    lazy var sizeLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = UIFont.boldSystemFont(ofSize: 24)
        one.textAlignment = .center
        one.text = "大"
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(titleLabel)
        addSubview(sizeLabel)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        layer.cornerRadius = 5
        clipsToBounds = true
        isUserInteractionEnabled = false
        isHidden = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 0, y: 20, width: bounds.size.width, height: 15)
        sizeLabel.frame = CGRect(x: 0, y: 35, width: bounds.size.width, height: bounds.size.height - 35)
    }
    
    
}
