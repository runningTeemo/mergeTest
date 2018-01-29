//
//  SpeedDialImagesView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SpeedDialImagesItem {
    
    var pictures: [Picture]? {
        didSet {
            update()
        }
    }
    
    var xMargin: CGFloat = 10
    var yMargin: CGFloat = 10
    var itemSize: CGSize = CGSize(width: 50, height: 50)
    
    fileprivate(set) var viewSize: CGSize = CGSize.zero
    fileprivate(set) var itemFrames: [CGRect] = [CGRect]()

    func update() {
        itemFrames.removeAll()
        if let pictures = pictures {
            if pictures.count > 0 {
                var maxX: CGFloat = 0
                var maxY: CGFloat = 0
                for i in 0..<pictures.count {
                    let x = i % 3
                    let y = i / 3
                    let frame = CGRect(x: (itemSize.width + xMargin) * CGFloat(x), y: (itemSize.height + yMargin) * CGFloat(y), width: itemSize.width, height: itemSize.height)
                    itemFrames.append(frame)
                    maxX = max(maxX, frame.maxX)
                    maxY = max(maxY, frame.maxY)
                }
                viewSize = CGSize(width: maxX, height: maxY)
            } else {
                viewSize = CGSize.zero
            }
        } else {
            viewSize = CGSize.zero
        }
    }
    
}

class SpeedDialImagesView: UIView {
    
    var respondIdx: ((_ idx: Int) -> ())?
    var respondBg: (() -> ())?

    var item: SpeedDialImagesItem? {
        didSet {
            for imageView in imageViews {
                imageView.isHidden = true
            }
            if let pics = item?.pictures {
                for i in 0..<pics.count {
                    let pic = pics[i]
                    let imageView = imageViews[i]
                    imageView.iconView.fullPath = pic.thumbUrl
                    imageView.isHidden = false
                }
            }
        }
    }

    let imageViews = [
        ImageButton(), ImageButton(), ImageButton(),
        ImageButton(), ImageButton(), ImageButton(),
        ImageButton(), ImageButton(), ImageButton()
    ]
    
    required init() {
        super.init(frame: CGRect.zero)
        var tag: Int = 0
        for imageView in imageViews {
            imageView.iconView.contentMode = .scaleAspectFill
            imageView.tag = tag
            imageView.signal_event_touchUpInside.head({ [unowned self, unowned imageView] (signal) in
                self.respondIdx?(imageView.tag)
            })
            addSubview(imageView)
            tag += 1
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondBg?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let item = item {
            for i in 0..<item.itemFrames.count {
                imageViews[i].frame = item.itemFrames[i]
            }
        }
    }
    
}
