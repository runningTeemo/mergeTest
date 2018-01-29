//
//  AlbumPhotoBottomView.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/7.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class AlbumPhotoPickerBottomView: UIView {
    
    //MARK: bussiness

    var pickCount: Int = 0 {
        didSet {
            countLabel.text = "\(pickCount)"
            if pickCount > 0 {
                previewBtn.isEnabled = true
                confirmBtn.isEnabled = true
                previewBtn.alpha = 1
                confirmBtn.alpha = 1
            } else {
                previewBtn.isEnabled = false
                confirmBtn.isEnabled = false
                previewBtn.alpha = 0.5
                confirmBtn.alpha = 0.5
            }            
        }
    }
    
    lazy var confirmBtn: UIButton = {
        let one = UIButton()
        one.setTitleColor(UIColor.white, for: UIControlState())
        one.setTitleColor(UIColor.green, for: .highlighted)
        one.setTitle("确认", for: UIControlState())
        one.isEnabled = false
        one.alpha = 0.5
        return one
    }()
    lazy var previewBtn: UIButton = {
        let one = UIButton()
        one.setTitleColor(UIColor.white, for: UIControlState())
        one.setTitleColor(UIColor.green, for: .highlighted)
        one.setTitle("预览", for: UIControlState())
        one.isEnabled = false
        one.alpha = 0.5
        return one
    }()
    
    lazy var countLabel: UILabel = {
        let one = UILabel()
        one.backgroundColor = UIColor.red
        one.textColor = UIColor.white
        one.layer.cornerRadius = 12.0
        one.clipsToBounds = true
        one.text = "0"
        one.font = UIFont.boldSystemFont(ofSize: 16)
        one.textAlignment = .center
        return one
    }()
    
    //MARK: other
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(120, 120, 120, 120)
        addSubview(confirmBtn)
        addSubview(previewBtn)
        addSubview(countLabel)
        confirmBtn.IN(self).RIGHT.TOP.BOTTOM.WIDTH(100).MAKE()
        previewBtn.IN(self).LEFT.TOP.BOTTOM.WIDTH(100).MAKE()
        countLabel.LEFT(confirmBtn).OFFSET(-20).CENTER.SIZE(24, 24).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AlbumPhotoPreviewBottomView: UIView {

    //MARK: bussiness

    var pickCount: Int = 0 {
        didSet {
            countLabel.text = "\(pickCount)"
            if pickCount > 0 {
                confirmBtn.isEnabled = true
                confirmBtn.alpha = 1
            } else {
                confirmBtn.isEnabled = false
                confirmBtn.alpha = 0.5
            }
        }
    }
    var select: Bool = false {
        didSet {
            if select {
                let image = UIImage(named: "photo_select")
                selectBtn.setImage(image, for: UIControlState())
            } else {
                let image = UIImage(named: "photo_select_dis")
                selectBtn.setImage(image, for: UIControlState())
            }
        }
    }
    
    lazy var confirmBtn: UIButton = {
        let one = UIButton()
        one.setTitleColor(UIColor.white, for: UIControlState())
        one.setTitleColor(UIColor.green, for: .highlighted)
        one.setTitle("确认", for: UIControlState())
        one.isEnabled = false
        one.alpha = 0.5
        return one
    }()
    lazy var selectBtn: UIButton = {
        let one = UIButton()
        return one
    }()
    lazy var countLabel: UILabel = {
        let one = UILabel()
        one.backgroundColor = UIColor.red
        one.textColor = UIColor.white
        one.layer.cornerRadius = 12.0
        one.clipsToBounds = true
        one.text = "0"
        one.font = UIFont.boldSystemFont(ofSize: 16)
        one.textAlignment = .center
        return one
    }()
    
    //MARK: other
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(120, 120, 120, 120)
        addSubview(confirmBtn)
        addSubview(selectBtn)
        addSubview(countLabel)
        confirmBtn.IN(self).RIGHT.TOP.BOTTOM.WIDTH(100).MAKE()
        selectBtn.IN(self).LEFT.TOP.BOTTOM.WIDTH(100).MAKE()
        countLabel.LEFT(confirmBtn).OFFSET(-20).CENTER.SIZE(24, 24).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class AlbumPhotoEditBottomView: UIView {

    //MARK: bussiness
    lazy var confirmBtn: UIButton = {
        let one = UIButton()
        one.setTitleColor(UIColor.white, for: UIControlState())
        one.setTitleColor(UIColor.green, for: .highlighted)
        one.setTitle("确认", for: UIControlState())
        one.isEnabled = false
        one.alpha = 0.5
        return one
    }()
    
    //MARK: other
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(120, 120, 120, 120)
        addSubview(confirmBtn)
        confirmBtn.IN(self).RIGHT.TOP.BOTTOM.WIDTH(100).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

