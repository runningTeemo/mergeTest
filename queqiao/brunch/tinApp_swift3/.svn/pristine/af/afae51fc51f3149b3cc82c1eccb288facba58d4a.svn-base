//
//  ShareTalentCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ShareTalentCell: CommonShareCell {

    var model:ArticleManpowerAttachments?{
        didSet{
            nameLabel.text = SafeUnwarp(model?.duty, holderForNull: "")
            nameLabel.sizeToFit()
            let salary  = TinSearch(code: model?.salary, inKeys: kManPowerSalaryKeys)?.name
            infoLabel.text = SafeUnwarp(salary, holderForNull: "") + "  " + SafeUnwarp(model?.address, holderForNull: "")
            infoLabel.sizeToFit()
        }
    }
    
    override func setModel(article: Article) {
        model = article.attachments as? ArticleManpowerAttachments
        if article.pictures.count > 0 {
            let pic = article.pictures[0]
            if pic.thumbUrl != nil {
                let url = URL(string: pic.thumbUrl!)
                activityImageV.sd_setImage(with: url, placeholderImage: UIImage(named:"shareTalent"))
            }
        }else{
            activityImageV.image = UIImage(named:"shareTalent")
        }
    }
    override func tapAction() {
        super.tapAction()
        let article = Article()
        article.id = model?.id
        article.type = .manpower
        let viewC = ArticleDetailViewControler()
        viewC.orgienArticle = article
        self.vc?.navigationController?.pushViewController(viewC, animated: true)
    }

}
