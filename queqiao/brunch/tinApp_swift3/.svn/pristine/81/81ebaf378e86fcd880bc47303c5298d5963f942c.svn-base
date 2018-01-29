//
//  ShareViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/14.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ShareViewController: RootViewController {
    
    var respondSuccess: (() -> ())?
    
    var shareView:UIView = UIView()
    var  bgView:UIView = UIView()
    var desc:String?
    var image: String?
    var urlName:String?
    var titleName:String?
    var info:[String: Any]?{
        didSet{
            titleName = info?.nullableString("title")
            desc = info?.nullableString("desc")
            image = info?.nullableString("imgUrl")
            urlName = info?.nullableString("link")
        }
    }
    var articleInfo:[String: Any]?{
        didSet{
            titleName = articleInfo?.nullableString("title")
            desc = articleInfo?.nullableString("desc")
            image = info?.nullableString("imgUrl")
            urlName = articleInfo?.nullableString("pageUrl")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        let color  = UIColor.black
        bgView.backgroundColor = color.withAlphaComponent(0.6)
        bgView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-200)
        view.addSubview(bgView)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(ShareViewController.cancelAction))
        bgView.addGestureRecognizer(tapGes)
        shareView.frame = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        shareView.backgroundColor = MyColor.colorWithHexString("#f2f2f2")
        view.addSubview(shareView)
        createView()
        createCancelView()
    }
    
    func createView(){
        let imageArr = ["shareWX","sharePYQ","shareSC"]
        let titleArr = ["微信好友","微信朋友圈","微信收藏"]
        for i in 0..<imageArr.count {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 20+(70+40)*i, y: 30, width: 70, height: 70)
            imageView.image = UIImage(named: imageArr[i])
            imageView.tag = 100+i
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
            imageView.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(ShareViewController.tapAction(tapGes:)))
            imageView.addGestureRecognizer(tapGes)
            shareView.addSubview(imageView)
            let label = UILabel()
            label.text = titleArr[i]
            label.sizeToFit()
            label.tintColor = MyColor.colorWithHexString("#666666")
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: 20+(70+40)*CGFloat(i), y: 30+70+10, width: 70, height: label.frame.height)
            shareView.addSubview(label)
        }
    }
    
    //创建取消按钮
    func createCancelView(){
        let cancelLabel = UILabel()
        cancelLabel.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: 50)
        cancelLabel.text = "取消"
        cancelLabel.textColor = MyColor.colorWithHexString("#333333")
        cancelLabel.textAlignment = NSTextAlignment.center
        cancelLabel.backgroundColor = MyColor.colorWithHexString("#ffffff")
        cancelLabel.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(ShareViewController.cancelAction))
        cancelLabel.addGestureRecognizer(tapGes)
        shareView.addSubview(cancelLabel)
    }
    
    //MARK:ACTION
    func tapAction(tapGes:UITapGestureRecognizer){
        let tag = tapGes.view?.tag
        var type:SSDKPlatformType = SSDKPlatformType.subTypeWechatSession
        if tag == 100 {//微信好友
            type = SSDKPlatformType.subTypeWechatSession
        }else if tag == 101 {//微信朋友圈
            type = SSDKPlatformType.subTypeWechatTimeline
        }else if tag == 102 {//微信收藏
            type = SSDKPlatformType.subTypeWechatFav
        }
        weak var ws = self
        let shareParames = NSMutableDictionary()
        let url = URL(string:SafeUnwarp(urlName, holderForNull: ""))
        
        var imgUrl: NSURL = NSURL()
        if let s = image {
            if let url = NSURL(string: s) {
                imgUrl = url
            }
        }
        shareParames.ssdkSetupShareParams(byText:desc,
                                          images: [imgUrl],
                                          url :url,
                                          title :SafeUnwarp(titleName, holderForNull: ""),
                                          type :SSDKContentType.webPage)
        ShareSDK.share(type, parameters: shareParames) { [weak self] (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error: Error?) in
            switch state{
            case .success:
                self?.respondSuccess?()
            case .fail:
                var errmsg = "授权失败"
                if let err = error as? NSError {
                    if let errdesc = err.userInfo.nullableString("error description ") {
                        errmsg = errdesc
                    } else {
                        errmsg = "授权失败" + "\(err.code)"
                    }
                }
                QXTiper.showFailed(errmsg, inView: self?.view, cover: true)
            case .cancel:
                break
            //QXTiper.showFailed("操作取消", inView: self?.view, cover: true)
            default:break
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                ws?.cancelAction()
            }
        }
    }
    
    func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
