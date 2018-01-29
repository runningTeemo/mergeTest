//
//  FourImageView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/7.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FourImageView: UIView {
    
    var pictures: [Picture]? {
        didSet {
            if let pictures = pictures {
                show(pictures.count)
                for i in 0..<pictures.count {
                    if i < 4 {
                        let imgV = imageViews[i]
                        imgV.fullPath = pictures[i].url
                    }
                }
                setNeedsLayout()
                layoutIfNeeded()
            } else {
                show(0)
            }
        }
    }
    
    var margin: CGFloat = 2
    
    lazy var imageViews: [ImageView] = {
        var one = [ImageView]()
        for _ in 0..<4 {
            let imgV = ImageView()
            imgV.contentMode = .scaleAspectFill
            one.append(imgV)
        }
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        for imgV in imageViews {
            addSubview(imgV)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = bounds.size.width
        let h = bounds.size.height
        
        if let pictures = pictures {
            let count = pictures.count
            if count == 0 {
            } else if count == 1 {
                let imgV0 = imageViews[0]
                imgV0.frame = bounds
            } else if count == 2 {
                let imgV0 = imageViews[0]
                let imgV1 = imageViews[1]
                let imgW = (w - margin) / 2
                imgV0.frame = CGRect(x: 0, y: 0, width: imgW, height: h)
                imgV1.frame = CGRect(x: imgW + margin, y: 0, width: imgW, height: h)
            } else if count == 3 {
                let imgV0 = imageViews[0]
                let imgV1 = imageViews[1]
                let imgV2 = imageViews[2]
                let imgW = (w - margin) / 2
                let imgH = (h - margin) / 2
                imgV0.frame = CGRect(x: 0, y: 0, width: imgW, height: h)
                imgV1.frame = CGRect(x: imgW + margin, y: 0, width: imgW, height: imgH)
                imgV2.frame = CGRect(x: imgW + margin, y: imgH + margin, width: imgW, height: imgH)
            } else {
                let imgV0 = imageViews[0]
                let imgV1 = imageViews[1]
                let imgV2 = imageViews[2]
                let imgV3 = imageViews[3]
                let imgW = (w - margin) / 2
                let imgH = (h - margin) / 2
                imgV0.frame = CGRect(x: 0, y: 0, width: imgW, height: imgH)
                imgV1.frame = CGRect(x: imgW + margin, y: 0, width: imgW, height: imgH)
                imgV2.frame = CGRect(x: 0, y: imgH + margin, width: imgW, height: imgH)
                imgV3.frame = CGRect(x: imgW + margin, y: imgH + margin, width: imgW, height: imgH)
            }
        } else {
            show(0)
        }
    }
    
    fileprivate func show(_ count: Int) {
        for i in 0..<4 {
            let imgV = imageViews[i]
            imgV.isHidden = i >= count
            imgV.frame = CGRect.zero
        }
    }
    
}
