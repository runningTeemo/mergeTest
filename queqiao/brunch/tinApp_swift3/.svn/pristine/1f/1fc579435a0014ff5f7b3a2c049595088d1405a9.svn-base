//
//  CommonShareCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CommonShareCell: CommonCell {
    
    var conversation:EMConversation?
    var headImage:String?{
        didSet{
            headImageV.sd_setImage(with:URL(string:SafeUnwarp(headImage, holderForNull: "")), placeholderImage: UIImage(named:"EaseUIResource.bundle/user"))
        }
    }
    
    var vc:UIViewController?
    
    /// message.ext 每个消息的扩展字段
    var dic:[String:AnyObject] = [String:AnyObject]() {
        didSet{
            let postId = dic[postMessageId] as? String
            headImage = dic[postMessageImg] as? String
            if postId == Account.sharedOne.user.huanXinId {
                isMe = true
            }else{
                isMe = false
            }
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
                setModel(article: article)
            }
            addModuleAndChangeFrame()
        }
    }
    
    
    func setModel(article:Article){
        
    }
    
    var message:EMMessage?{
        didSet{
            
        }
    }
    
    /// 该申请查看是否是自己发出的
    var isMe:Bool = false{
        didSet{
            
        }
    }
    
    /// 聊天用户的头像
    var headImageV:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 21
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    /// 活动、人才、八卦、项目的头像
    var activityImageV:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.red
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
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var infoLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#999999")
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    
    override func addModuleAndChangeFrame() {
        headImageV.frame = CGRect(x: leftStartX, y: 0, width: 42, height: 42)
        bubbleImageV.frame = CGRect(x: headImageV.frame.maxX+4, y: 0, width: cellWidth-15-headImageV.frame.maxX-4, height: 71)
        bubbleImageV.image = UIImage(named: "chat_receiver_bg")
        activityImageV.frame = CGRect(x: leftStartX, y: 15, width: 41, height: 41)
        nameLabel.frame = CGRect(x: activityImageV.frame.maxX + 10, y: 15, width: bubbleImageV.frame.width-activityImageV.frame.maxX - 10 - leftStartX, height: nameLabel.frame.height)
        infoLabel.frame = CGRect(x: activityImageV.frame.maxX + 10, y: activityImageV.frame.maxY - infoLabel.frame.height, width: bubbleImageV.frame.width-activityImageV.frame.maxX - 10 - leftStartX, height: infoLabel.frame.height)
        if isMe{
            headImageV.frame = CGRect(x: cellWidth-leftStartX-42.0, y: 0, width: 42, height: 42)
            bubbleImageV.frame = CGRect(x: leftStartX, y: 0, width: cellWidth-leftStartX*2-headImageV.frame.width-4, height: 71)
            bubbleImageV.image = UIImage(named: "bubbleWhiteRight")
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        contentView.addSubview(headImageV)
        contentView.addSubview(bubbleImageV)
        bubbleImageV.addSubview(activityImageV)
        bubbleImageV.addSubview(nameLabel)
        bubbleImageV.addSubview(infoLabel)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(ApplyCheckCell.tapAction))
        bubbleImageV.isUserInteractionEnabled = true
        bubbleImageV.addGestureRecognizer(tapGes)
    }

    
    func tapAction(){
        //bubbleImageV.isUserInteractionEnabled = false
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
