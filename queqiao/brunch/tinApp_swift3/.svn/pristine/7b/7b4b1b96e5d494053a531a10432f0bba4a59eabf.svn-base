//
//  ImageView.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/18.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

enum IconType {
    case user
    case image
    case rectangleImage
    //case iconNewsImgSquare
    case report
    case card
    case news
    case none
}

class RoundIconView: ImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
    }
}

class ImageView: UIImageView {
    
    var url: URL? {
        didSet {
            image = nil
        }
    }
    
    var fullPath: String? {
        didSet {
            self.image = nil
            if let str = fullPath {
                if let url = URL(string: str) {
                    //self.qx_setThumbImage(url)
                    self.sd_setImage(with: url)
                }
            }
        }
    }
    
    func setFullPath(_ path: String?, done: @escaping (() -> ())) {
        self.image = nil
        if let str = path {
            if let url = URL(string: str) {
                // self.qx_setThumbImage(url)
                self.sd_setImage(with: url, completed: { (_, _, _, _) in
                    done()
                })
            }
        }
    }
    
    var appSubPath: String? {
        didSet {
            
        }
    }
    
    fileprivate var type: IconType
    override var image: UIImage? {
        didSet {
            super.image = image
            if image == nil {
                switch type {
                case .user:
                    image = userImage
                case .rectangleImage:
                    image = rectangleImage
                case .report:
                    image = reportImage
                case .card:
                    image = cardImage
                case .news:
                    image = newsImage
                case .none:
                    break
                default:
                    image = defalutImage
                }
            }
        }
    }
    
    lazy fileprivate var userImage = UIImage(named: "iconUserImg")
    lazy fileprivate var defalutImage = UIImage(named: "iconNewsImgSquare")
    lazy fileprivate var rectangleImage = UIImage(named: "iconNewsImg")
    lazy fileprivate var reportImage = UIImage(named: "iconReportImg")
    lazy fileprivate var cardImage = UIImage(named: "MyCardImg")
    lazy fileprivate var newsImage = UIImage(named: "newsListImage")

    required init(type: IconType = .image) {
        self.type = type
        super.init(frame: CGRect.zero)
        clipsToBounds = true
        switch type {
        case .user:
            image = userImage
        case .rectangleImage:
            image = rectangleImage
        case .report:
            image = reportImage
        case .card:
            image = cardImage
        case .news:
            image = newsImage
        case .none:
            image = nil
        default:
            image = defalutImage
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TurnImageView: UIImageView {
    var origenAngle: CGFloat = CGFloat(M_PI)
    var turn: Bool = false {
        didSet {
            fixAngle()
        }
    }
    
    func fixAngle() {
        if turn {
            transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) + origenAngle)
        } else {
            transform = CGAffineTransform(rotationAngle: origenAngle)
        }
    }
    
    override var image: UIImage? {
        didSet {
            super.image = image
            fixAngle()
        }
    }
}
