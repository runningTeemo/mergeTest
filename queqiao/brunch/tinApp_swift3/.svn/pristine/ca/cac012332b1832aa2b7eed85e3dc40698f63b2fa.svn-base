//
//  WriteArticleViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/20.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class WriteArticleViewController: RootTableViewController {
    
    var industries: [Industry] = [Industry]()
    var foldIndustries: Bool = true
    var industriesLoadStatus: LoadStatus = .loading
    var currentIndustry: Industry?
    weak var vcBefore: ArticleMainViewControler?
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "保存", responder: { [unowned self] in
            self.handleSave()
            })
        return one
    }()
    lazy var loadingNavItem: BarButtonItem = {
        let one = BarButtonItem(indicatorStyle: .gray)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发布八卦"
        navigationItem.rightBarButtonItem = saveNavItem
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
        tableView.register(WriteArticleIndustryCell.self, forCellReuseIdentifier: "WriteArticleIndustryCell")
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        
        if !Account.sharedOne.isLogin { return }
        
        currentIndustry = Account.sharedOne.user.industry
        if let industry = currentIndustry {
            industryHeadCell.titleLabel.text = "发布到 " + SafeUnwarp(industry.name, holderForNull: "") + "行业"
        }
    }
    
    func handleBack() {
        if NotNullText(inputCell.textView.text) || imagesCell.getImages().count > 0 {
            Confirmer.show("返回确认", message: "返回将不会保存页面内容，确认返回？", confirm: "返回", confirmHandler: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
                }, cancel: "继续编辑", cancelHandler: {
                }, inVc: self)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func checkOrLoadIndustrys() {
        if industriesLoadStatus == .loading {
            tableView.reloadData()
            
            ArticleManager.shareInstance.getIndustries({ [weak self] (code, msg, industries) in
                
                if code == 0 {
                    if let s = self {
                        var industries = industries!
                        industries = s.filt(allIndustries: industries)
                        if industries.count == 0 {
                            s.industriesLoadStatus = .doneEmpty
                        } else {
                            s.industriesLoadStatus = .done
                        }
                        s.industries = industries
                        s.tableView.reloadData()
                    }
                } else {
                    self?.industriesLoadStatus = .doneErr
                    self?.tableView.reloadData()
                }
                }, failed: { [weak self] (error) in
                    self?.industriesLoadStatus = .doneErr
                    self?.tableView.reloadData()
            })
        }
    }
    
    func filt(allIndustries: [Industry]) -> [Industry] {
        
        if !Account.sharedOne.isLogin {
            return allIndustries
        }
        
        var industries = [Industry]()
        if let oi = Account.sharedOne.user.industry {
            industries.append(oi)
        }
        industries += Account.sharedOne.user.industries
        
        var resultIndustries = [Industry]()
        resultIndustries += industries
        for industry in allIndustries {
            var notExist: Bool = true
            for myInd in industries {
                if SafeUnwarp(myInd.id, holderForNull: "") == SafeUnwarp(industry.id, holderForNull: "") {
                    notExist = false
                }
            }
            if notExist {
                resultIndustries.append(industry)
            }
        }
        return resultIndustries
    }
    
    func handleSave() {
        view.endEditing(true)
        
        if currentIndustry == nil {
            QXTiper.showWarning("请选择发布行业", inView: self.view, cover: true)
            return;
        }
        if NullText(inputCell.textView.text) && imagesCell.getImages().count == 0 {
            QXTiper.showWarning("内容不能为空", inView: self.view, cover: true)
            return;
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.navigationItem.rightBarButtonItem = self?.loadingNavItem
            let wait = QXTiper.showWaiting("发布中...", inView: self?.view, cover: true)
            self?.publish({ [weak self] in
                QXTiper.hideWaiting(wait)
                self?.navigationItem.rightBarButtonItem = self?.saveNavItem
            })
        }
    }
    
    func publish(_ done: @escaping (() -> ())) {
        
        if !Account.sharedOne.isLogin {
            done()
            return
        }
        
        let user = Account.sharedOne.user
        let industry = currentIndustry!
        let imgs = self.imagesCell.getImages()
        let content = inputCell.textView.text
        
        if imgs.count > 0 {
            
            ArticleManager.shareInstance.uploadImages(user, images: imgs, success: { [weak self] (code, msg, pictures) in
                if code == 0 {
                    ArticleManager.shareInstance.publish(user, indusrty: industry, content: content, pics: pictures, success: { [weak self] (code, message, ret) in
                        if code == 0 {
                            QXTiper.showSuccess("发布成功", inView: self?.view, cover: true)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                                self?.navigationController?.popViewController(animated: true)
                                self?.vcBefore?.performRefresh()
                            }
                        } else {
                            done()
                            QXTiper.showWarning(msg, inView: self?.view, cover: true)
                        }
                    }) { [weak self] (error) in
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        done()
                    }
                } else {
                    done()
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
            }) { [weak self] (error) in
                done()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
            
        } else {
            ArticleManager.shareInstance.publish(user, indusrty: industry, content: content, pics: nil, success: { [weak self] (code, message, ret) in
                if ret {
                    QXTiper.showSuccess("发布成功", inView: self?.view, cover: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                        self?.vcBefore?.performRefresh()
                    }
                } else {
                    QXTiper.showWarning(message, inView: self?.view, cover: true)
                }
                done()
            }) { [weak self] (error) in
                done()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
            
        }
    }

    
    lazy var inputCell: WriteArticleInputCell = {
        let one = WriteArticleInputCell()
        return one
    }()
    lazy var imagesCell: WriteArticleImagesCell = {
        let one = WriteArticleImagesCell()
        one.respondAdd = { [unowned self, unowned one] in
                ActionSheet.show(nil, actions: [
                    ("拍照", { [unowned self, unowned one] in
                        MediaTool.sharedOne.showCamera(edit: false, inVc: self)
                        MediaTool.sharedOne.pixelLimt = 1000 * 1000
                        MediaTool.sharedOne.respondImage = { image in
                            let item = WriteArticleImageItem(isAddType: false)
                            item.image = image
                            one.items.append(item)
                            one.update()
                            self.tableView.reloadData()
                        }
                    }),
                    ("图片库", { [unowned self, unowned one] in
                        let count = 9 - one.items.count
                        AlbumPhotoShowMutiSelect(self, maxCount: count, responder: { [unowned self, unowned one] (images) in
                            var items = [WriteArticleImageItem]()
                            for img in images {
                                let item = WriteArticleImageItem(isAddType: false)
                                item.image = img
                                items.append(item)
                            }
                            one.items += items
                            one.update()
                            self.tableView.reloadData()
                        })
                    }),
                    ], inVc: self)
        }
        one.respondImage = { [unowned self, unowned one] idx in
            let vc = PhotoViewerViewController()
            var items: [PhotoViewerItem] = [PhotoViewerItem]()
            for i in one.items {
                let img = Image()
                img.image = i.image
                let item = PhotoViewerItem(image: img, select: true)
                items.append(item)
            }
            vc.items = items
            vc.currentIndex = idx
            vc.isSelectModel = true
            vc.respondImages = { [unowned self, unowned one] images in
                var items = [WriteArticleImageItem]()
                for img in images {
                    let item = WriteArticleImageItem(isAddType: false)
                    item.image = img.image
                    items.append(item)
                }
                one.items = items
                one.update()
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    lazy var industryHeadCell: WriteArticleIndustryHeadCell = {
        let one = WriteArticleIndustryHeadCell()
        return one
    }()
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return foldIndustries ? 1 : 2
    }
    lazy var loadingCell: LoadingCell = {
        let one = LoadingCell()
        return one
    }()
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            if industriesLoadStatus == .done {
                return industries.count
            } else {
                return 1
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return inputCell
            } else if indexPath.row == 1 {
                return imagesCell
            } else if indexPath.row == 2 {
                industryHeadCell.showBottomLine = true
                industryHeadCell.respondClick = { [unowned self] in
                    self.foldIndustries = !self.foldIndustries
                    self.industryHeadCell.fold = self.foldIndustries
                    if !self.foldIndustries {
                        self.checkOrLoadIndustrys()
                    }
                    self.tableView.reloadData()
                }
                return industryHeadCell
            }
        } else {
            if industriesLoadStatus == .done {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WriteArticleIndustryCell") as! WriteArticleIndustryCell
                cell.titleLabel.text = industries[indexPath.row].name
                cell.showBottomLine = !(indexPath.row == industries.count - 1)
                return cell
            } else {
                if industriesLoadStatus == .loading {
                    loadingCell.showLoading()
                } else if industriesLoadStatus == .doneErr {
                    loadingCell.showFailed(kWebErrMsg)
                } else if industriesLoadStatus == .doneEmpty {
                    loadingCell.showEmpty("未查询到行业信息")
                }
                loadingCell.respondReload = { [unowned self] in
                    self.industriesLoadStatus = .loading
                    self.checkOrLoadIndustrys()
                }
                return loadingCell
            }
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return WriteArticleInputCell.cellHeight()
            } else if indexPath.row == 1 {
                return imagesCell.cellHeight
            } else if indexPath.row == 2 {
                return WriteArticleIndustryHeadCell.cellHeight()
            }
        } else {
            if industriesLoadStatus == .done {
                return WriteArticleIndustryCell.cellHeight()
            } else {
                return 200
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            if industriesLoadStatus == .done {
                return true
            }
        }
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.section == 1 {
            if industriesLoadStatus == .done {
                let industry = industries[indexPath.row]
                currentIndustry = industry
                industryHeadCell.titleLabel.text = "发布到 " + SafeUnwarp(industry.name, holderForNull: "") + "行业"
                foldIndustries = true
                industryHeadCell.fold = true
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0001 : 10
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

class WriteArticleInputCell: RootTableViewCell, UITextViewDelegate {
    override class func cellHeight() -> CGFloat {
        return 100
    }
    lazy var textView: UITextView = {
        let one = UITextView()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrDarkGray
        one.tintColor = kClrBlack
        one.delegate = self
        return one
    }()
    lazy var holderLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = UIFont.systemFont(ofSize: 16)
        one.text = "说点什么吧..."
        return one
    }()
    init() {
        super.init(style: .default, reuseIdentifier: "WriteArticleInputCell")
        contentView.addSubview(textView)
        contentView.addSubview(holderLabel)
        textView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP(12).BOTTOM(12).MAKE()
        holderLabel.IN(contentView).LEFT(15).TOP(20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            holderLabel.isHidden = true
        } else {
            holderLabel.isHidden = false
        }
    }
}

class WriteArticleImageItem {
    var image: UIImage?
    var isAddType: Bool
    init(isAddType: Bool) {
        self.isAddType = isAddType
    }
}

class WriteArticleImagesCell: RootTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var respondAdd: (() -> ())?
    var respondImage: ((_ idx: Int) -> ())?
    func getImages() -> [UIImage] {
        var imgs = [UIImage]()
        for item in items {
            if item.isAddType == false {
                if let img = item.image {
                    imgs.append(img)
                }
            }
        }
        return imgs
    }
    
    var items: [WriteArticleImageItem] = [WriteArticleImageItem]()
    lazy var addItem: WriteArticleImageItem = {
        let one = WriteArticleImageItem(isAddType: true)
        return one
    }()
    fileprivate(set) var cellHeight: CGFloat = 80

    func update() {
        collectionView.reloadData()
        cellHeight = flowLayout.collectionViewContentSize.height
        tipLabel.isHidden = items.count > 0
    }
    
    lazy var tipLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrLightGray
        one.font = UIFont.systemFont(ofSize: 17)
        one.text = "添加图片"
        return one
    }()
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.minimumInteritemSpacing = 10
        one.minimumLineSpacing = 10
        one.itemSize = CGSize(width: 80, height: 80)
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = false
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.register(WriteArticleImagesInnerCell.self, forCellWithReuseIdentifier: "WriteArticleImagesInnerCell")
        return one
    }()
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count < 9 {
            return items.count + 1
        }
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WriteArticleImagesInnerCell", for: indexPath) as! WriteArticleImagesInnerCell
        if items.count < 9 {
            if indexPath.item < items.count {
                cell.item = items[indexPath.item]
            } else {
                cell.item = addItem
            }
        } else {
            cell.item = items[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item: WriteArticleImageItem
        if items.count < 9 {
            if indexPath.item < items.count {
                item = items[indexPath.item]
            } else {
                item = addItem
            }
        } else {
            item = items[indexPath.item]
        }
        if item.isAddType {
            respondAdd?()
        } else {
            respondImage?(indexPath.item)
        }
    }
    init() {
        super.init(style: .default, reuseIdentifier: "WriteArticleInputCell")
        contentView.addSubview(collectionView)
        contentView.addSubview(tipLabel)
        collectionView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP.BOTTOM.MAKE()
        tipLabel.IN(contentView).LEFT(100).TOP(30).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WriteArticleImagesInnerCell: UICollectionViewCell {
    var item: WriteArticleImageItem! {
        didSet {
            if item.isAddType {
                iconView.image = UIImage(named: "iconImageUpload")
            } else {
                iconView.image = item.image
            }
        }
    }
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.contentMode = .scaleAspectFill
        return one
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconView)
        iconView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WriteArticleIndustryHeadCell: RootTableViewCell {
    
    var respondClick: (() -> ())?
    
    var fold: Bool? {
        didSet {
            if let f = fold {
                if f {
                    iconView.transform = CGAffineTransform.identity
                } else {
                    let transform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI))
                    iconView.transform = transform
                }
            }
        }
    }

    override class func cellHeight() -> CGFloat {
        return 15 + 45
    }
    lazy var backBtn: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrWhite
        one.dowBgColor = kClrSlightGray
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondClick?()
        })
        return one
    }()
    lazy var lineTop = NewBreakLine
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = UIFont.systemFont(ofSize: 17)
        one.text = "选择行业"
        return one
    }()
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconScreenMore")
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backBtn)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineTop)
        contentView.addSubview(iconView)
        backBtn.IN(contentView).LEFT.RIGHT.TOP(15).BOTTOM.MAKE()
        titleLabel.IN(contentView).LEFT(12.5).TOP(15 + 14).MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(iconView).LEFT.OFFSET(-20).MAKE()
        iconView.IN(contentView).RIGHT(12.5).TOP(15 + 15).SIZE(15, 15).MAKE()
        lineTop.IN(contentView).LEFT.RIGHT.TOP(15).HEIGHT(0.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WriteArticleIndustryCell: RootTableViewCell {
    
    override class func cellHeight() -> CGFloat {
        return 40
    }
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = UIFont.systemFont(ofSize: 16)
        one.text = ""
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-20).MAKE()
        bottomLineLeftCons?.constant = 12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

