//
//  ArticleProjectBriefBubbleViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleProjectBriefBubbleViewController: RootBubbleListViewController {
    
    var respondPictures: ((_ idx: Int, _ pics: [Picture]) -> ())?

    var article: Article? {
        didSet {
            if let article = article {
                
                textCell.item.text = (article.attachments as? ArticleProjectAttachments)?.brief
                textCell.item = textCell.item
                
                imagesCell.item.piciures = article.pictures
                imagesCell.item = imagesCell.item
                
                tableView.reloadData()
            } else {
                
                textCell.item.text = nil
                textCell.item = textCell.item
                
                imagesCell.item.piciures = nil
                imagesCell.item = imagesCell.item
                
                tableView.reloadData()
            }
        }
    }

    lazy var textCell: ArticleTextCell = {
        let one = ArticleTextCell()
        let item = ArticleBubbleText()
        item.text = nil
        one.item = item
        return one
    }()
    
    lazy var imagesCell: ArticleBubbleImagesCell = {
        let one = ArticleBubbleImagesCell()
        let item = ArticleBubbleImages()
        item.piciures = nil
        one.item = item
        one.imagesView.respondIdx = { [unowned self] idx in
            if let article = self.article {
                self.respondPictures?(idx, article.pictures)
            }
        }
        return one
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headTitle = "产品概况"
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        var height: CGFloat = 0
        height += retainHeight
        height += textCell.item.height
        height += imagesCell.item.height
        updateHeight?(height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return textCell
        } else if indexPath.row == 1 {
            return imagesCell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return textCell.item.height
        } else if indexPath.row == 1 {
            return imagesCell.item.height
        }
        return 0
    }
    
}
