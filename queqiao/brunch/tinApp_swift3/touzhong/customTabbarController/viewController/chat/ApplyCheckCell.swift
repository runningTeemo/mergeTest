//
//  ApplyCheckCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ApplyCheckCell: CommonCell {
    
    var conversation:EMConversation?
    var headImage:String?{
        didSet{
            headImageV.sd_setImage(with:URL(string:SafeUnwarp(headImage, holderForNull: "")), placeholderImage: UIImage(named:"EaseUIResource.bundle/user"))
        }
    }
    var vc:UIViewController?
    
    
    var articleProjectModel:ArticleProjectAttachments?{
        didSet{
            nameLabel.text = articleProjectModel?.name
            nameLabel.sizeToFit()
            var roundsStr:String? = ""
            if  articleProjectModel?.dealType == 1 {
                roundsStr = (TinSearch(code: articleProjectModel?.currentRound, inKeys: kProjectInvestTypeKeys)?.name)
            }
            if articleProjectModel?.dealType == 2 {
                roundsStr = (TinSearch(code: articleProjectModel?.currentRound, inKeys: kProjectMergeTypeKeys)?.name)
            }
            let roundS = SafeUnwarp(roundsStr, holderForNull: "")
            
            let currency = TinSearch(code: articleProjectModel?.currency, inKeys: kCurrencyTypeKeys)?.name
            var money: String?
            let n = StaticCellTools.doubleToNatureMoney(n: SafeUnwarp(articleProjectModel?.currencyAmount, holderForNull: 0))
            if currency == "人民币" {
                money = "¥" + n
            } else if currency == "美元" {
                money = "$" + n
            } else if currency == "欧元" {
                money = "€" + n
            } else {
                money = n
            }
            money = SafeUnwarp(money, holderForNull: "")
            var investStockRatioStr:String? = ""
            investStockRatioStr = "\(SafeUnwarp(articleProjectModel?.investStockRatio, holderForNull: 0.00))"
            investStockRatioStr = Tools.decimal(3, originalStr: investStockRatioStr!)
            investStockRatioStr = "/"+investStockRatioStr!+"%"
            let locationStr = SafeUnwarp(articleProjectModel?.location, holderForNull: "")
            infoLabel.text = roundS + "   " +  money! + investStockRatioStr! + "  " + locationStr
            infoLabel.sizeToFit()
        }
    }
    var projectViewModel:ProjectViewCommitDataModel?{
        didSet{
            if projectViewModel?.applyStatus == "2" { //当前项目申请查看的状态
                projectViewSwith.isOn = true
            }else{
                projectViewSwith.isOn = false
            }
        }
    }
    
    var dic:[String:AnyObject] = [String:AnyObject]() {
        
        didSet{
            if let articleDic = dic[articleShareDic] {
                let article = Article()
                if let dic = articleDic as? [String: Any] {
                    article.update(dic)
                } else if let str  = articleDic as? String {
                    if let data = str.data(using: String.Encoding.utf8) {
                        do {
                            let obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                            if let dic = obj as? [String: Any] {
                                article.update(dic)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                let project  = article.attachments as? ArticleProjectAttachments
                if project != nil {
                    articleProjectModel = project
                }
                
            }
            
            let postId:String? = dic[postMessageId] as? String;
            let type = ArticleViewType.applying
            //判断是否是自己 取值postID
            if postId == Account.sharedOne.user.huanXinId {
                self.isMe = true
            }else{
                self.isMe = false
            }
            self.headImage = dic[postMessageImg] as? String
            //取申请模型
            let commitModel = ProjectViewCommitDataModel()
            if let commitDic = dic[commitProjectModel] {
                if let dic = commitDic as? [String: Any] {
                    commitModel.update(dic)
                } else if let str  = commitDic as? String {
                    if let data = str.data(using: String.Encoding.utf8) {
                        do {
                            let obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                            if let dic = obj as? [String: Any] {
                                commitModel.update(dic)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            projectViewModel = commitModel
            //验证申请状态
            if projectViewModel != nil {
                applyValidate(applyUserId: projectViewModel?.applyUserId)
            }
            
            addModuleAndChangeFrame()
        }
    }
    var message:EMMessage?{
        didSet{
        }
    }
    
    var applyStatus:projectApplyViewStatus?{
        didSet{
            if isMe {
                if applyStatus == .pass {
                    applyLabel.text = "申请通过"
                }else{
                    applyLabel.text = "申请中"
                    projectViewSwith.isOn = false
                    projectViewSwith.isOn = true
                }
            }else{
                applyLabel.text = "项目详情"
                if applyStatus == .pass {
                    projectViewSwith.isOn = true
                }else{
                    projectViewSwith.isOn = false
                }
            }
        }
    }
    
    /// 该申请查看是否是自己发出的
    var isMe:Bool = false{
        didSet{
            if isMe {
                projectViewSwith.isHidden = true
                if applyStatus == .pass {
                    applyLabel.text = "申请通过"
                }else{
                    applyLabel.text = "申请中"
                }
            }else{
                projectViewSwith.isHidden = false
                applyLabel.text = "项目详情"
            }
        }
    }
    
    var headImageV:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 21
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    var bubbleImageV:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chat_receiver_bg")
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    var infoLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#999999")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var line:UIView = {
        let lineView = UIView()
        lineView.backgroundColor = verticalLineColor
        return lineView
    }()
    var applyLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#3AAAF1")
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "项目详情"
        label.sizeToFit()
        return label
    }()
    
    /// 正在加载
    var loadingView:UIActivityIndicatorView = {
        let loadingV : UIActivityIndicatorView = UIActivityIndicatorView()
        loadingV.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        loadingV.startAnimating()
        loadingV.backgroundColor = UIColor.gray
        loadingV.isHidden = false
        return loadingV
    }()
    
    var projectViewSwith:ZJSwitch = {
        let sw = ZJSwitch()
        sw.style = ZJSwitchStyle.noBorder
        sw.onTintColor = MyColor.colorWithHexString("#23c966")
        sw.textFont = UIFont.systemFont(ofSize: 9)
        sw.onText = "打开"
        sw.offText = "关闭"
        return sw
    }()
    
    override func addModuleAndChangeFrame() {
        headImageV.frame = CGRect(x: leftStartX, y: 0, width: 42, height: 42)
        bubbleImageV.frame = CGRect(x: headImageV.frame.maxX+4, y: 0, width: cellWidth-15-headImageV.frame.maxX-4, height: 120)
        bubbleImageV.image = UIImage(named: "chat_receiver_bg")
        nameLabel.frame = CGRect(x: leftStartX, y: 15, width: bubbleImageV.frame.width-leftStartX*2, height: nameLabel.frame.height)
        infoLabel.frame = CGRect(x: leftStartX, y: nameLabel.frame.maxY+14, width: bubbleImageV.frame.width-15*2, height: nameLabel.frame.height)
        line.frame = CGRect(x: 0, y: 76.5, width: bubbleImageV.frame.width, height: 0.5);
        projectViewSwith.frame = CGRect(x: bubbleImageV.frame.width-leftStartX-60, y: line.frame.maxY+9, width: 60, height: 29)
        applyLabel.frame = CGRect(x: leftStartX, y: line.frame.maxY, width: projectViewSwith.frame.origin.x-leftStartX, height: 42)
        if projectViewModel?.applyUserId == Account.sharedOne.user.id {
            headImageV.frame = CGRect(x: cellWidth-leftStartX-42.0, y: 0, width: 42, height: 42)
            bubbleImageV.frame = CGRect(x: leftStartX, y: 0, width: cellWidth-leftStartX*2-headImageV.frame.width-4, height: 120)
            bubbleImageV.image = UIImage(named: "bubbleWhiteRight")
        }
        bubbleImageV.showDefaultLoading()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headImageV)
        contentView.addSubview(bubbleImageV)
        bubbleImageV.addSubview(nameLabel)
        bubbleImageV.addSubview(infoLabel)
        bubbleImageV.addSubview(line)
        bubbleImageV.addSubview(applyLabel)
        bubbleImageV.addSubview(projectViewSwith)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        projectViewSwith.addTarget(self, action: #selector(ApplyCheckCell.projectViewAction(sw:)), for: UIControlEvents.valueChanged)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(ApplyCheckCell.tapAction))
        bubbleImageV.isUserInteractionEnabled = true
        bubbleImageV.addGestureRecognizer(tapGes)
    }
    
    //MARK:Action
    func projectViewAction(sw:ZJSwitch){
        print(sw.isOn)
        projectViewSwith.isUse = true
        if sw.isOn {
            projectViewModel?.applyStatus = "2"
        }else{
            projectViewModel?.applyStatus = "1"
        }
        weak var ws = self
        ChatManage.shareInstance.applyCheckCommit(articleModel:Article(),model: projectViewModel ?? ProjectViewCommitDataModel(), success: { (codel, message, projectModel) in
            if codel == 0{
                ws?.updateMessage(model: projectModel)
            }else{
                print(message)
            }
            ws?.projectViewSwith.isUse = false
        }, failed: { (error) in
            ws?.projectViewSwith.isUse = false
            print(error)
        })
    }
    /// 更新message中的ext
    func updateMessage(model:ProjectViewCommitDataModel?){
        print(message?.ext)
        if model != nil {
            projectViewModel = model
        }
        var extM = message?.ext
        if (extM == nil) {
            extM = [String:AnyObject]()
        }
        if let dic = model?.keyValues{
            print(dic)
           extM?.append(commitProjectModel, notNullValue: dic)
        }
        print(extM)
        message?.ext = extM
        //为了更新message的最新ext 保证下次进入会话界面的时候申请查看的状态值正确
        self.conversation?.deleteMessage(withId: message?.messageId, error: nil)
        self.conversation?.insert(message, error: nil)
    }
    
    func tapAction(){
        bubbleImageV.isUserInteractionEnabled = false
        applyValidate(isTap: true, applyUserId: projectViewModel?.applyUserId)
    }
    /// 验证申请状态
    func applyValidate(isTap:Bool = false, applyUserId:String?){
        weak var ws = self
        print(projectViewModel?.projectId)
        print(applyUserId)
        ChatManage.shareInstance.applyValidate(projectId: projectViewModel?.projectId, applyUserId:applyUserId,success: {(code,message,data) in
            ws?.bubbleImageV.isUserInteractionEnabled = true
            ws?.bubbleImageV.hideDefaultLoading()
            ws?.applyStatus = projectApplyViewStatus(rawValue: code)
            if ws?.applyStatus == nil {
                ws?.bubbleImageV.isUserInteractionEnabled = true
            }
            if isTap {
                ws?.successTap()
            }
        }, failed: {error in
            ws?.bubbleImageV.isUserInteractionEnabled = true
            print(error)
        })
    }
    
    func successTap(){
        
        if self.vc == nil { return }
        
        if ArticleWriteLimitChecker.check(onVc: self.vc!, operation: "查看项目详情") {
            
            if !self.isMe || applyStatus == .pass{
                let article = Article()
                article.id = articleProjectModel?.id
                article.type = .project
                let viewC = ArticleDetailViewControler()
                viewC.orgienArticle = article
                self.vc?.navigationController?.pushViewController(viewC, animated: true)
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
