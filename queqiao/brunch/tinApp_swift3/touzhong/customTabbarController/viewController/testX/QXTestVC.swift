//
//  QXTestVC.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
import Alamofire
import Charts

class QXTestVc: RootViewController {

    lazy var bannerView: IndexViewBannerView = {
        let one = IndexViewBannerView()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        view.addSubview(bannerView)
        bannerView.IN(view).LEFT.RIGHT.TOP(100).HEIGHT(200).MAKE()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        bannerView.banners = [Banner()]
        
        NewsManager.shareInstance.getIndexDefaultBanner(success: { (code, msg, banner) in
            var a = self.bannerView.banners
            a.append(banner!)
            self.bannerView.banners = a
            
        }) { (_) in
            
        }
        
        
        
        
    
    }
    
}


