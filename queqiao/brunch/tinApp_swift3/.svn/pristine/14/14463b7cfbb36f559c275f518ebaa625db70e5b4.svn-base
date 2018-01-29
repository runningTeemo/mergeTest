//
//  CycleView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CycleView: UIControl {
    var pictures: [Picture] = [Picture]() {
        didSet {
            fixPictures()
            orderImageViews()
        }
    }
    fileprivate(set) var idx: Int = 0
    fileprivate(set) var isMoving: Bool = false
    
    func pre() {
        if isMoving { return }
        idx -= 1
        if idx < 0 { idx = imageViews.count - 1 }
        imageViews.exchangeObject(at: 1, withObjectAt: 2)
        imageViews.exchangeObject(at: 0, withObjectAt: 1)
        isMoving = true
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.orderImageViews()
            }, completion: { [weak self] (_) in
                self?.fixPictures()
                self?.isMoving = false
        }) 
        sendActions(for: .valueChanged)
    }
    
    func next() {
        if isMoving { return }
        idx += 1
        if idx == pictures.count { idx = 0 }
        imageViews.exchangeObject(at: 0, withObjectAt: 1)
        imageViews.exchangeObject(at: 1, withObjectAt: 2)
        isMoving = true
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.orderImageViews()
        }, completion: { [weak self] (_) in
            self?.fixPictures()
            self?.isMoving = false
        }) 
        sendActions(for: .valueChanged)
    }
    
    fileprivate func fixPictures() {
        for i in 0..<imageViews.count {
            let imgV = imageViews[i] as! ImageView
            let index = (self.idx + i - 1 + pictures.count) % pictures.count
            imgV.fullPath = pictures[index].url
        }
    }
    
    fileprivate func orderImageViews() {
        let size = bounds.size
        let leftImgV = imageViews[0] as! ImageView
        let centerImgV = imageViews[1] as! ImageView
        let rightImgV = imageViews[2] as! ImageView
        leftImgV.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
        centerImgV.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        rightImgV.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
        bringSubview(toFront: centerImgV)
    }
    
    fileprivate lazy var imageViews: NSMutableArray = {
        let imgV0 = ImageView(type: .rectangleImage)
        let imgV1 = ImageView(type: .rectangleImage)
        let imgV2 = ImageView(type: .rectangleImage)
        return [imgV0, imgV1, imgV2]
    }()
    required init() {
        super.init(frame: CGRect.zero)
        let leftSwip = UISwipeGestureRecognizer(target: self, action: #selector(CycleView.pre))
        leftSwip.direction = .right
        let rightSwip = UISwipeGestureRecognizer(target: self, action: #selector(getter: CycleView.next))
        rightSwip.direction = .left
        addGestureRecognizer(leftSwip)
        addGestureRecognizer(rightSwip)
        for imgV in imageViews {
            addSubview(imgV as! ImageView)
        }
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class CycleTextView: UIControl {
    
    var attributedTexts: [NSAttributedString] = [NSAttributedString]() {
        didSet {
            fixLabels()
            orderLabels()
        }
    }
    fileprivate(set) var idx: Int = 0
    fileprivate(set) var isMoving: Bool = false
    
    func pre() {
        if isMoving { return }
        idx -= 1
        if idx < 0 { idx = labels.count - 1 }
        labels.exchangeObject(at: 1, withObjectAt: 2)
        labels.exchangeObject(at: 0, withObjectAt: 1)
        let backLabel = labels[0] as! UILabel
        backLabel.isHidden = true
        isMoving = true
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.orderLabels()
        }, completion: { [weak self] (_) in
            self?.fixLabels()
            self?.isMoving = false
            backLabel.isHidden = false
        }) 
        sendActions(for: .valueChanged)
    }
    
    func next() {
        if isMoving { return }
        idx += 1
        if idx == labels.count { idx = 0 }
        labels.exchangeObject(at: 0, withObjectAt: 1)
        labels.exchangeObject(at: 1, withObjectAt: 2)
        let backLabel = labels[2] as! UILabel
        backLabel.isHidden = true
        isMoving = true
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.orderLabels()
        }, completion: { [weak self] (_) in
            self?.fixLabels()
            self?.isMoving = false
            backLabel.isHidden = false
        }) 
        sendActions(for: .valueChanged)
    }
    
    fileprivate func fixLabels() {
        for i in 0..<labels.count {
            let label = labels[i] as! UILabel
            let index = (self.idx + i - 1 + attributedTexts.count) % attributedTexts.count
            label.attributedText = attributedTexts[index]
        }
    }
    fileprivate func orderLabels() {
        let size = bounds.size
        let leftLabel = labels[0] as! UILabel
        let centerLabel = labels[1] as! UILabel
        let rightLabel = labels[2] as! UILabel
        leftLabel.frame = CGRect(x: -size.width, y: 0, width: size.width, height: size.height)
        centerLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        rightLabel.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
        bringSubview(toFront: centerLabel)
    }
    
    fileprivate lazy var labels: NSMutableArray = {
        let label0 = UILabel()
        let label1 = UILabel()
        let label2 = UILabel()
        return [label0, label1, label2]
    }()
    required init() {
        super.init(frame: CGRect.zero)
        let leftSwip = UISwipeGestureRecognizer(target: self, action: #selector(CycleView.pre))
        leftSwip.direction = .right
        let rightSwip = UISwipeGestureRecognizer(target: self, action: #selector(getter: CycleView.next))
        rightSwip.direction = .left
        addGestureRecognizer(leftSwip)
        addGestureRecognizer(rightSwip)
        for label in labels {
            addSubview(label as! UILabel)
        }
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
