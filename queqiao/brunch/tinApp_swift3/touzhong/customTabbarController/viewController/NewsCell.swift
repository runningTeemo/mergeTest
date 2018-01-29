//
//  NewsCell.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsCell: RootTableViewCell {
    
    var news: News! {
        didSet {
            if news.style == .Adv {
                coverImageView.isHidden = true
                contentLabel.isHidden = true
                subLabel1.isHidden = true
                subLabel2.isHidden = true
                dateLabel.isHidden = true
                advImageView.isHidden = false
                advImageView.fullPath = news.coverImage
                //advTimeLabel.isHidden = true
//                if let t = DateTool.getNature(news.publishDate) {
//                    advTimeLabel.text = t + " "
//                } else {
//                    advTimeLabel.text = nil
//                }
                advTimeLabel.text = "  "
                
                if let t = news.title {
                    advLabel.text = " " + t
                } else {
                    advLabel.text = nil
                }
            } else {
                coverImageView.isHidden = false
                contentLabel.isHidden = false
                subLabel1.isHidden = false
                subLabel2.isHidden = false
                dateLabel.isHidden = false
                advImageView.isHidden = true
                
                coverImageView.fullPath = news.coverImage
                
                if news.type == .news {
                    coverLabel.isHidden = false
                    coverLabel.text = news.tag.name
                } else {
                    coverLabel.isHidden = true
                }
                
                contentLabel.text = news.title
                Tools.setHighLightAttibuteColor(label: contentLabel, startStr: "<hlt>", endStr: "</hlt>", attributeFont: UIFont.systemFont(ofSize: 16))

                dateLabel.text = DateTool.getNature(news.publishDate)
                
                if news.type == .report {
                    subLabel1.text = news.author
                    subLabel2.text = nil
                } else {
                    if news.keyWords.count == 0 {
                        subLabel1.text = nil
                        subLabel2.text = nil
                    } else {
                        if news.keyWords.count == 1 {
                            subLabel1.text = news.keyWords.first?.content
                            subLabel2.text = nil
                        } else {
                            subLabel1.text = news.keyWords[0].content
                            subLabel2.text = news.keyWords[1].content
                        }
                    }
                }
                
                
            }
        }
    }
    
    class func cellHeightForModel(_ news: News) -> CGFloat {
        if news.style == .Adv {
            return (kScreenW - 12.5 * 2) * 180 / 750 + 15 * 2
        } else {
            return NewsCell.cellHeight()
        }
    }
    override class func cellHeight() -> CGFloat {
        return 94
    }
    
    lazy var advImageView: ImageView = {
        let one = ImageView(type: .report)
        one.addSubview(self.advLabel)
        one.addSubview(self.advTimeLabel)
        self.advLabel.IN(one).LEFT.BOTTOM.HEIGHT(26).MAKE()
        self.advTimeLabel.IN(one).RIGHT.BOTTOM.HEIGHT(26).MAKE()
        self.advLabel.RIGHT.EQUAL(self.advTimeLabel).LEFT.MAKE()
        return one
    }()
    lazy var advLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 14)
        one.backgroundColor = RGBA(0, 0, 0, 80)
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var advTimeLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor(white: 1, alpha: 0.5)
        one.font = UIFont.systemFont(ofSize: 12)
        one.backgroundColor = RGBA(0, 0, 0, 80)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    
    lazy var coverImageView: ImageView = {
        let one = ImageView(type: .news)
        one.addSubview(self.coverLabel)
        self.coverLabel.IN(one).LEFT.RIGHT.BOTTOM.HEIGHT(26).MAKE()
        return one
    }()
    lazy var coverLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 14)
        one.textAlignment = .center
        one.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = UIFont.systemFont(ofSize: 16)
        one.numberOfLines = 2
        return one
    }()
    
    lazy var subLabel1: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = UIFont.systemFont(ofSize: 12)
        return one
    }()
    lazy var subLabel2: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = UIFont.systemFont(ofSize: 12)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = UIFont.systemFont(ofSize: 12)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coverImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(subLabel1)
        contentView.addSubview(subLabel2)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(advImageView)
        
        coverImageView.IN(contentView).LEFT(12.5).CENTER.SIZE(97, 64).MAKE()
        contentLabel.RIGHT(coverImageView).OFFSET(10).TOP.MAKE()
        contentLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        subLabel1.RIGHT(coverImageView).OFFSET(10).BOTTOM.MAKE()
        subLabel2.RIGHT(subLabel1).OFFSET(12).CENTER.MAKE()
        dateLabel.RIGHT.EQUAL(contentView).OFFSET(-12.5).MAKE()
        dateLabel.BOTTOM.EQUAL(coverImageView).MAKE()
        subLabel2.RIGHT.LESS_THAN_OR_EQUAL(dateLabel).LEFT.OFFSET(-20).MAKE()
        
        advImageView.IN(contentView).LEFT(12.5).TOP(15).BOTTOM(15).RIGHT(12.5).MAKE()
        
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
