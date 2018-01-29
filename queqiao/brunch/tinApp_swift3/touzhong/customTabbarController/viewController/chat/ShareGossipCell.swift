//
//  ShareGossipCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ShareGossipCell: CommonShareCell {

    var model:Article?{
        didSet{
            nameLabel.numberOfLines = 2
            nameLabel.text = model?.content
            nameLabel.sizeToFit()
        }
    }
    override func setModel(article: Article) {
        model = article
        if article.pictures.count > 0 {
            let pic = article.pictures[0]
            if pic.thumbUrl != nil {
                let url = URL(string: pic.thumbUrl!)
                activityImageV.sd_setImage(with: url, placeholderImage: UIImage(named:"shareGossip"))
            }
        }else{
            activityImageV.image = UIImage(named:"shareGossip")
        }
    }
    ///去掉infoLabel
    override func addModuleAndChangeFrame() {
        super.addModuleAndChangeFrame()
        infoLabel.isHidden = true
        nameLabel.frame = CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y, width: nameLabel.frame.width, height: activityImageV.frame.height)
    }
    override func tapAction() {
        super.tapAction()
        let article = Article()
        article.id = model?.id
        article.type = .normal
        let viewC = ArticleDetailViewControler()
        viewC.orgienArticle = article
        self.vc?.navigationController?.pushViewController(viewC, animated: true)
    }
    
}
