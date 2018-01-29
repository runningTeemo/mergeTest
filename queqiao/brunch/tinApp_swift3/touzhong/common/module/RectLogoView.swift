//
//  RectLogoView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/4.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class RectLogoView: UIView {
    
    var fullPath: String? {
        didSet {
            self.image = defalutLogoImage
            if let str = fullPath {
                if let url = URL(string: str) {
                    
                    self.logoView.sd_setImage(with: url, completed: { [weak self] (image, _, _, _) in
                        self?.image = image
                        })
                }
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            if let image = image {
                logoView.image = image
            } else {
                logoView.image = defalutLogoImage
            }
            layoutSubviews()
        }
    }
    
    var defalutLogoImage: UIImage?
    
    var margin: CGFloat = 5 {
        didSet {
            layoutSubviews()
        }
    }
    
    lazy var logoView: ImageView = {
        let one = ImageView(type: .none)
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(logoView)
        clipsToBounds = true
        backgroundColor = kClrWhite
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let winW = bounds.size.width
        let winH = bounds.size.height

        if let image = image {
            let size = image.size
            if size.width > 0 && size.height > 0 && winW > 0 && winH > 0 {
                if winW / winH > size.width / size.height {
                    let y = margin
                    let h = winH - margin * 2
                    let w = h * size.width / size.height
                    let x = (winW - w) / 2
                    logoView.frame = CGRect(x: x, y: y, width: w, height: h)
                } else {
                    let x = margin
                    let w = winW - margin * 2
                    let h = w * size.height / size.width
                    let y = (winH - h) / 2
                    logoView.frame = CGRect(x: x, y: y, width: w, height: h)
                }
            } else {
                logoView.frame = CGRect.zero
            }
        }
        
    }
    
}
