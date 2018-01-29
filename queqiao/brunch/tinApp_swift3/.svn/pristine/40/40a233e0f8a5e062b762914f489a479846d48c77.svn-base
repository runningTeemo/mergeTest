//
//  ArticleImagesCell.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//


import Foundation

class ArticleBubbleImages: RootBubbleItem {
    
    var piciures: [Picture]? {
        didSet {
            if let piciures = piciures {
                if piciures.count > 0 {
                    let item = SpeedDialImagesItem()
                    item.xMargin = 5
                    item.yMargin = 5
                    let size = (kBubbleContentWidth - 5 * 2 - 12.5 * 2) / 3
                    item.itemSize = CGSize(width: size, height: size)
                    item.pictures = piciures
                    item.update()
                    imgsItem = item
                } else {
                    imgsItem = nil
                }
            } else {
                imgsItem = nil
            }
        }
    }
    
    private(set) var imgsItem: SpeedDialImagesItem?
    
    override var height: CGFloat {
        if let item = imgsItem {
            return item.viewSize.height
        }
        return 0
    }
    
}

class ArticleBubbleImagesCell: RootTableViewCell {
    
    var respondPictures: ((_ idx: Int, _ pics: [Picture]) -> ())?
    
    var item: ArticleBubbleImages! {
        didSet {
            imagesView.item = item.imgsItem
        }
    }
    
    lazy var imagesView: SpeedDialImagesView = {
        let one = SpeedDialImagesView()
//        one.respondBg = { [unowned self] in
//            self.hanldeCellClick()
//        }

        return one
    }()
    required init() {
        super.init(style: .default, reuseIdentifier: "ArticleBubbleImagesCell")
        addSubview(imagesView)
        imagesView.IN(self).LEFT(12.5).RIGHT(12.5).TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
