//
//  RoundLogoView.swift
//  xxx
//
//  Created by Richard.q.x on 2016/11/4.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

class RoundLogoView: UIView {
        
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
    
    var defalutLogoImage: UIImage? {
        didSet {
            if let image = image {
                logoView.image = image
            } else {
                logoView.image = defalutLogoImage
            }
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
        let winSize = bounds.size.width
        let r = winSize / 2
        let cx = bounds.minX + r
        let cy = bounds.minY + r
        layer.cornerRadius = r
        
        if let image = image {
            let size = image.size
            if size.width > 0 && size.height > 0 && r > 0 {
                let b = size.height / size.width
                let dx = CGFloat(sqrtf(Float(pow(r, 2) / (1 + pow(b, 2)))))
                let dy = dx * b
                logoView.frame = CGRect(x: cx - dx, y: cy - dy, width: dx * 2, height: dy * 2)
            } else {
                logoView.frame = CGRect.zero
            }
        }
        
    }
    
}
