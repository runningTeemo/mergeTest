//
//  MeetingBannerView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeetingBannerView: BannerCycleView {
    var viewHeight: CGFloat { return kScreenW * 320 / 750 }
    override init() {
        super.init()
        placeHolderImage = UIImage(named: "newsBannerImage")
        banners = [Banner()]
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class MeetingBannerView: UIView, SDCycleScrollViewDelegate {
//    
//    var viewHeight: CGFloat { return kScreenW * 320 / 750 }
//    
//    var respondSelect: ((_ banner: Banner) -> ())?
//    var banners: [Banner] = [Banner]() {
//        didSet {
//            cycleView.showPageControl = banners.count > 1
//            var urls = [String]()
//            var texts = [String]()
//            for banner in banners {
//                urls.append(SafeUnwarp(banner.picture, holderForNull: ""))
//                texts.append(SafeUnwarp(banner.desc, holderForNull: ""))
//            }
//            cycleView.imageURLStringsGroup = urls
//            cycleView.titlesGroup = texts
//        }
//    }
//    lazy var cycleView: SDCycleScrollView = {
//        let one = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: self.viewHeight), delegate: self, placeholderImage: UIImage(named: "newsBannerImage"))!
//        one.delegate = self
//        one.autoScrollTimeInterval = 3
//        one.infiniteLoop = true
//        one.autoScroll = true
//        one.showPageControl = true
//        one.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
//        one.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
//        one.pageControlBottomOffset = 0
//        one.pageControlRightOffset = 15
//        one.pageControlDotSize = CGSize(width: 6, height: 6)
//        one.currentPageDotColor = kClrOrange
//        one.pageDotColor = kClrGray
//        one.titleLabelTextFont = UIFont.systemFont(ofSize: 14)
//        one.localizationImageNamesGroup = ["loginTopImg"]
//        return one
//    }()
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
