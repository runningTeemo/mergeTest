//
//  MyNewsCells.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/7.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyNewsArticleCell: RootTableViewCell {
    
    var article: Article! {
        didSet {
            
            if let date = article.createDate {
                let d1 = DateTool.getSegDate(Date())!
                let d2 = DateTool.getSegDate(date)!
                if d1.day == d2.day {
                    dayLabel.text = "今天"
                    monthLabel.text = nil
                } else if d1.day == d2.day + 1 {
                    dayLabel.text = "昨天"
                    monthLabel.text = nil
                } else {
                    dayLabel.text = String(format: "%02d", d2.day)
                    monthLabel.text = "\(d2.month)月"
                }
            } else {
                dayLabel.text = nil
                monthLabel.text = nil
            }
            
            if article.pictures.count > 0 {
                contentLabel.text = article.content
                imagesView.pictures = article.pictures
                imageCountLabel.text = "共\(article.pictures.count)张"
                contentLabel.isHidden = false
                imagesView.isHidden = false
                imageCountLabel.isHidden = false
                fullContentLabel.isHidden = true
            } else {
                contentLabel.isHidden = true
                imagesView.isHidden = true
                imageCountLabel.isHidden = true
                fullContentLabel.isHidden = false
                fullContentLabel.text = article.content
            }
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return 110
    }
    
    lazy var dayLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 30)
        one.textColor = kClrBlack
        return one
    }()
    lazy var monthLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrBlack
        return one
    }()
    
    lazy var imagesView: FourImageView = {
        let one = FourImageView()
        return one
    }()
    lazy var imageCountLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.numberOfLines = 2
        return one
    }()
    lazy var fullContentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.numberOfLines = 0
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dayLabel)
        contentLabel.addSubview(monthLabel)
        contentView.addSubview(imagesView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(imageCountLabel)
        dayLabel.IN(contentView).LEFT(12.5).TOP(25).MAKE()
        monthLabel.RIGHT(dayLabel).BOTTOM(-5).MAKE()
        imagesView.IN(contentView).TOP(20).LEFT(85).SIZE(80, 80).MAKE()
        contentLabel.RIGHT(imagesView).OFFSET(10).TOP.MAKE()
        contentLabel.RIGHT.EQUAL(contentView).OFFSET(-12.5).MAKE()
        imageCountLabel.RIGHT(imagesView).OFFSET(10).BOTTOM.MAKE()
        
        contentView.addSubview(fullContentLabel)
        fullContentLabel.IN(contentView).LEFT(85).TOP(20).BOTTOM(20).RIGHT(12.5).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MyNewsCirclesCell: RootTableViewCell {
    
    var item: RectSelectsFixSizeItem! {
        didSet {
            circlesView.item = item
        }
    }
    
    lazy var circlesView: RectSelectsFixSizeView = {
        let one = RectSelectsFixSizeView()
        one.isUserInteractionEnabled = false
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(circlesView)
        circlesView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP(20).BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MyNewsCommentCell: RootTableViewCell {
    
    var article: Article! {
        didSet {
            
            userIcon.image = nil
            userNameLabel.text = article.user.nickName
            userCompanyLabel.text = article.user.company
            userPossitionLabel.text = article.user.position
            
            if let d = DateTool.getSegDate(article.createDate) {
                dateLabel.text = String(format: "%02d月%02d日", d.month, d.day)
            } else {
                dateLabel.text = nil
            }
            if article.pictures.count > 0 {
                contentLabel.text = article.content
                imagesView.pictures = article.pictures
                imageCountLabel.text = "共\(article.pictures.count)张"
                contentLabel.isHidden = false
                imagesView.isHidden = false
                imageCountLabel.isHidden = false
                fullContentLabel.isHidden = true
            } else {
                contentLabel.isHidden = true
                imagesView.isHidden = true
                imageCountLabel.isHidden = true
                fullContentLabel.isHidden = false
                fullContentLabel.text = article.content
            }
            commentCountLabel.text = "您参与过0条评论"
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return 170
    }
    
    lazy var userIcon: RoundIconView = {
        let one = RoundIconView()
        return one
    }()
    lazy var userNameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = HEX("#46689b")
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var userCompanyLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var line = NewBreakLine
    lazy var userPossitionLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    
    lazy var imagesView: FourImageView = {
        let one = FourImageView()
        return one
    }()
    lazy var imageCountLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        return one
    }()
    lazy var commentCountLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.numberOfLines = 2
        return one
    }()
    lazy var fullContentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.numberOfLines = 2
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userIcon)
        contentLabel.addSubview(userNameLabel)
        contentView.addSubview(userCompanyLabel)
        contentView.addSubview(line)
        contentView.addSubview(userPossitionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(imagesView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(imageCountLabel)
        contentView.addSubview(commentCountLabel)
        
        userIcon.IN(contentView).LEFT(12.5).TOP(20).SIZE(40, 40).MAKE()
        dateLabel.IN(contentView).RIGHT(12.5).TOP(25).MAKE()
        userNameLabel.RIGHT(userIcon).OFFSET(10).TOP.MAKE()
        userNameLabel.RIGHT.LESS_THAN_OR_EQUAL(dateLabel).LEFT.OFFSET(-10).MAKE()
        userCompanyLabel.RIGHT(userIcon).OFFSET(10).BOTTOM(-3).MAKE()
        line.RIGHT(userCompanyLabel).OFFSET(10).CENTER.SIZE(0.5, 12).MAKE()
        userPossitionLabel.RIGHT(line).OFFSET(10).CENTER.MAKE()
        userPossitionLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        
        imagesView.IN(contentView).LEFT(12.5).TOP(75).SIZE(80, 80).MAKE()
        imageCountLabel.RIGHT(imagesView).OFFSET(10).BOTTOM.MAKE()
        commentCountLabel.RIGHT.EQUAL(contentView).OFFSET(-12.5).MAKE()
        commentCountLabel.BOTTOM.EQUAL(imagesView).MAKE()
        contentLabel.RIGHT(imagesView).OFFSET(10).TOP.MAKE()
        contentLabel.RIGHT.EQUAL(contentView).OFFSET(-12.5).MAKE()
        
        contentView.addSubview(fullContentLabel)
        fullContentLabel.LEFT.EQUAL(imagesView).MAKE()
        fullContentLabel.TOP.EQUAL(imagesView).MAKE()
        fullContentLabel.RIGHT.EQUAL(contentView).OFFSET(-12.5).MAKE()
        
        
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
