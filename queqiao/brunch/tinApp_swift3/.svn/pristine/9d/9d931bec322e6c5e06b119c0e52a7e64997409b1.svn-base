//
//  ArticleProjectTextBubbleViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/9.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class ArticleProjectTextBubbleViewController: RootBubbleListViewController {
    
    var text: String? {
        didSet {
            textCell.item.text = text
            textCell.item = textCell.item
            tableView.reloadData()
        }
    }
    
    lazy var textCell: ArticleTextCell = {
        let one = ArticleTextCell()
        let item = ArticleBubbleText()
        item.text = nil
        one.item = item
        return one
    }()
    
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
