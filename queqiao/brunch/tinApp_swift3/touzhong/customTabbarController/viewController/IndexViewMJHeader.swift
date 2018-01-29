//
//  IndexViewMJHeader.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndexViewMJHeader: MJRefreshNormalHeader {
    
    override func prepare() {
        super.prepare()
        self.mj_h = CGFloat(98)
    }
    
    lazy var logoView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "slogn")
        return one
    }()
    
    override func placeSubviews() {
        super.placeSubviews()
        self.lastUpdatedTimeLabel.isHidden = true
        addSubview(logoView)

        self.stateLabel.sizeToFit()
        let stateSize = self.stateLabel.bounds.size
        
        let labelX = (kScreenW - stateSize.width - 10 - 15) / 2 + 10 + 15
        self.stateLabel.frame = CGRect(x: labelX, y: 98 - 50, width: stateSize.width, height: 50)
        self.labelLeftInset = 10
        self.arrowView.frame = CGRect(x: labelX - 10 - 15, y: 98 - 25 - 10, width: 15, height: 20)
        
        self.loadingView.frame = self.arrowView.frame
        logoView.frame = CGRect(x: (kScreenW - 111) / 2, y: 30, width: 111, height: 16)
    }
    
    
//    /** 利用这个block来决定显示的更新时间文字 */
//    @property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);
//    /** 显示上一次刷新时间的label */
//    @property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;
//    
//    #pragma mark - 状态相关
//    /** 文字距离圈圈、箭头的距离 */
//    @property (assign, nonatomic) CGFloat labelLeftInset;
//    /** 显示刷新状态的label */
//    @property (weak, nonatomic, readonly) UILabel *stateLabel;
//    /** 设置state状态下的文字 */
//    - (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
}

//class IndexViewMJHeader: MJRefreshNormalHeader {
//    
//
//}

//class IndexViewMJHeader: MJRefreshStateHeader {
//    
//    override func prepare() {
//        super.prepare()
//        self.mj_h = CGFloat(120)
//    }
//    
//    lazy var imageView: UIImageView = {
//        let one = UIImageView()
//        one.image = UIImage.gifWithName("runHorseFastS")
//        return one
//    }()
//    
//    override func placeSubviews() {
//        super.placeSubviews()
//        self.lastUpdatedTimeLabel.isHidden = true
//        self.stateLabel.isHidden = true
//        self.addSubview(imageView)
//        let w: CGFloat = 440 / 2
//        let h: CGFloat = 200 / 2
//        let x: CGFloat = (self.bounds.size.width - w) / 2
//        let y: CGFloat = 20
//        imageView.frame = CGRect(x: x, y: y, width: w, height: h)
//    }
//}
