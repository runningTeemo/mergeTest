//
//  RootTabBarController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    func makeRootViewController(_ vc: UIViewController, title: String, iconName: String) -> UIViewController {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: iconName + "Select")?.withRenderingMode(.alwaysOriginal)
        return vc
    }
    
    func makeNavRootViewController(_ vc: UIViewController, title: String, iconName: String) -> UINavigationController {
        let vc = makeRootViewController(vc, title: title, iconName: iconName)
        let nav = RootNavigationController(rootViewController: vc)
        return nav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cleanImage = UIImage.image(kScreenSize, color: UIColor.clear)
        tabBar.backgroundImage = cleanImage
        tabBar.shadowImage = cleanImage
        tabBar.tintColor = HEX("#d61f26")
        tabBar.backgroundImage = UIImage.image(kScreenSize, render: { (ctx, rect) in
            UIColor.clear.setFill()
            UIRectFill(CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 49))
            UIColor.white.setFill()
            UIRectFill(CGRect(x: 0, y: kScreenH - 49, width: kScreenW, height: 49))
            UIImage(named: "tagTopLine")?.draw(in: CGRect(x: 0, y: kScreenH - 49.5, width: kScreenW, height: 0.5))
        })
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(RootViewController.changeModel), name: NSNotification.Name(rawValue: "changeModel"), object: nil);
        self.tabBar.barTintColor = ChangeModel.changeModelColor()
        self.tabBar.tintColor = kClrOrange
    }
    
    /**
     后面改变tabbar的背景图片
     
     - author: zerlinda
     - date: 16-09-10 11:09:05
     */
    func changeModel(){
        
        self.tabBar.barTintColor = ChangeModel.changeModelColor()
    }

}

extension UITabBar {
    
    func showBadge(idx: Int) {
        
        removeBadge(idx: idx)
        
        let v = BadgeView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        v.tag = idx
        
        let percentageX = (Float(idx) + 0.6) / 5
        let x = ceilf(percentageX * Float(frame.size.width))
        let y = ceilf(0.1 * Float(frame.size.height))
        v.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: 11, height: 11)
        addSubview(v)
    }
    
    func removeBadge(idx: Int) {
        for v in subviews {
            if v.isKind(of: BadgeView.self) {
                if idx == v.tag {
                    v.removeFromSuperview()
                }
            }
        }
    }
    
}

class BadgeView: UIView {
    lazy var dotView: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#ff0000")
        one.layer.cornerRadius = 4
        one.clipsToBounds = true
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(dotView)
        dotView.IN(self).CENTER.SIZE(8, 8).MAKE()
        backgroundColor = kClrWhite
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

