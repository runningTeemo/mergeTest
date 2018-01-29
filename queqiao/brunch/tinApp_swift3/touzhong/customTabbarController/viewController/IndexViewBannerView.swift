//
//  IndexViewBannerView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndexViewBannerView: BannerCycleView {

    override var banners: [Banner] {
        didSet {
            if let img = topBannerDefaultImage {
                placeHolderImage = img
            } else {
                let path = PathTool.cache + "/" + kTopBannerDefaultImageName
                if let img = UIImage(contentsOfFile: path) {
                    placeHolderImage = img
                } else {
                    placeHolderImage = UIImage(named: "loginTopImg")
                }
            }
            super.banners = banners
        }
    }
    
    let firstBanner = Banner()
    
    var viewHeight: CGFloat { return kScreenW * 362 / 750 }
    override init() {
        super.init()
        textLabel.isHidden = true
        bottomView.isHidden = true
        firstPageDelayCount = 1
        placeHolderImage = UIImage(named: "slogn")
        if let banner = topBannerDefaultBanner {
            self.banners = [banner]
        } else {
            self.banners = [firstBanner]
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class IndexViewBannerView: UIView, SDCycleScrollViewDelegate {
//    
//    var respondSelect: ((_ banner: Banner) -> ())?
//    var viewHeight: CGFloat { return kScreenW * 360 / 750 }
//    var banners: [Banner] = [Banner]() {
//        didSet {
//            cycleView.showPageControl = banners.count > 1
//            var urls = [String]()
//            for banner in banners {
//                urls.append(SafeUnwarp(banner.picture, holderForNull: ""))
//            }
//            cycleView.imageURLStringsGroup = urls
//        }
//    }
//    lazy var cycleView: SDCycleScrollView = {
//        let one = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: self.viewHeight), delegate: self, placeholderImage: UIImage(named: "loginTopImg"))!
//        one.delegate = self
//        one.autoScrollTimeInterval = 3
//        one.infiniteLoop = true
//        one.autoScroll = true
//        one.showPageControl = true
////        one.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
//        one.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
//        one.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
//        one.pageControlBottomOffset = 0
//        one.pageControlRightOffset = 15
//        one.pageControlDotSize = CGSize(width: 6, height: 6)
//        one.currentPageDotColor = HEX("#d61f26")
//        one.pageDotColor = UIColor(white: 0, alpha: 0.35)
//        one.localizationImageNamesGroup = ["loginTopImg"]
//        return one
//    }()
//    
//    required init() {
//        super.init(frame: CGRect.zero)
//        addSubview(cycleView)
//        cycleView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
//        if banners.count >= index + 1 {
//            respondSelect?(banners[index])
//        }
//    }
//
//}

class IndexViewBannerCell: UICollectionViewCell {
    lazy var imageView: ImageView = {
        let one = ImageView(type: .report)
        one.image = nil
        return one
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


