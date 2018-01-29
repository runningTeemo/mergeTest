//
//  ShareActivityCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ShareActivityCell: CommonShareCell {
    
    
    var model:ArticleActivityAttachments?{
        didSet{
            nameLabel.text = SafeUnwarp(model?.name, holderForNull: "")
            nameLabel.sizeToFit()
            var startTimeStr = ""
            var endTimeStr = ""
            if model?.startTime != nil {
                startTimeStr = Tools.getTimeStrFromDate((model?.startTime)!, dataFormatter: "yyyy/MM/dd")
            }
            if model?.endTime != nil {
                endTimeStr = Tools.getTimeStrFromDate((model?.endTime)!, dataFormatter: "yyyy/MM/dd")
            }
            infoLabel.text = startTimeStr + "-" + endTimeStr
            infoLabel.sizeToFit()

        }
    }
    override func setModel(article: Article) {
        model = article.attachments as? ArticleActivityAttachments
        if article.pictures.count > 0 {
            let pic = article.pictures[0]
            if pic.thumbUrl != nil {
                let url = URL(string: pic.thumbUrl!)
                activityImageV.sd_setImage(with: url, placeholderImage: UIImage(named:"shareActivity"))
            }
        }else{
            activityImageV.image = UIImage(named:"shareActivity")
        }
    }
    override func tapAction() {
        super.tapAction()
        let article = Article()
        article.id = model?.id
        article.type = .activity
        let viewC = ArticleDetailViewControler()
        viewC.orgienArticle = article
        self.vc?.navigationController?.pushViewController(viewC, animated: true)
    }
}
