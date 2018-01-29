//
//  ShareProjectCell.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ShareProjectCell: CommonShareCell {

    var model:ArticleProjectAttachments?{
        didSet{
            nameLabel.text = model?.name
            nameLabel.sizeToFit()
            var roundsStr:String? = ""
            if  model?.dealType == 1{
                roundsStr = (TinSearch(code: model?.currentRound, inKeys: kProjectInvestTypeKeys)?.name)
            }
            if model?.dealType == 2{
                roundsStr = (TinSearch(code: model?.currentRound, inKeys: kProjectMergeTypeKeys)?.name)
            }
            let roundS = SafeUnwarp(roundsStr, holderForNull: "")
            
            let currency = TinSearch(code: model?.currency, inKeys: kCurrencyTypeKeys)?.name
            var money: String?
            let n = StaticCellTools.doubleToNatureMoney(n: SafeUnwarp(model?.currencyAmount, holderForNull: 0))
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
            investStockRatioStr = "\(SafeUnwarp(model?.investStockRatio, holderForNull: 0.00))"
            investStockRatioStr = Tools.decimal(3, originalStr: investStockRatioStr!)
            investStockRatioStr = "/"+investStockRatioStr!+"%"
            let locationStr = SafeUnwarp(model?.location, holderForNull: "")
            infoLabel.text = roundS + "   " +  money! + investStockRatioStr! + "  " + locationStr
            infoLabel.sizeToFit()
        }
    }
    override func setModel(article: Article) {
        model = article.attachments as? ArticleProjectAttachments
        if article.pictures.count > 0 {
            let pic = article.pictures[0]
            if pic.thumbUrl != nil {
                let url = URL(string: pic.thumbUrl!)
                activityImageV.sd_setImage(with: url, placeholderImage: UIImage(named:"shareProject"))
            }
        }else{
            activityImageV.image = UIImage(named:"shareProject")
        }
    }
    override func tapAction() {
        super.tapAction()
        
        if self.vc == nil { return }
        
        if ArticleWriteLimitChecker.check(onVc: self.vc!, operation: "查看项目详情") {
            let article = Article()
            article.id = model?.id
            article.type = .project
            let viewC = ArticleDetailViewControler()
            viewC.orgienArticle = article
            self.vc?.navigationController?.pushViewController(viewC, animated: true)
        }
        
    }
    
}
