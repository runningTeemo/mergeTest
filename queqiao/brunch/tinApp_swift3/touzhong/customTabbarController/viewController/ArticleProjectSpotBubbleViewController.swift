//
//  ArticleProjectSpotBubbleViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleProjectSpotBubbleViewController: RootBubbleListViewController {
        
    var article: Article? {
        didSet {
            if let article = article {
                
                textCell.item.text = (article.attachments as? ArticleProjectAttachments)?.descri
                textCell.item = textCell.item
                
                tableView.reloadData()
            } else {
                
                textCell.item.text = nil
                textCell.item = textCell.item

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

    override func viewDidLoad() {
        super.viewDidLoad()
        headTitle = "项目亮点"
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        var height: CGFloat = 0
        height += retainHeight
        height += textCell.item.height
        updateHeight?(height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return textCell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return textCell.item.height
        }
        return 0
    }
    
}
