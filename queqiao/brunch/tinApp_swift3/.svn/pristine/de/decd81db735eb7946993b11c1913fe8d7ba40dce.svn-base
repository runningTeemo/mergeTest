//
//  CommonTabBarController.swift
//  NewProject
//
//  Created by Zerlinda on 16/6/17.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit

class CommonTabBarController: UITabBarController ,UITabBarControllerDelegate{

    var itemArr:[UIViewController] = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(RootViewController.changeModel), name: NSNotification.Name(rawValue: "changeModel"), object: nil);
        self.tabBar.barTintColor = ChangeModel.changeModelColor()
        self.tabBar.tintColor = mainColor
        
    }
    
    func changeModel(){
    
        self.tabBar.barTintColor = ChangeModel.changeModelColor()
    }
    
    
    func appendChildViewController(_ controller:UIViewController,navigation:Bool?=true,title:NSString ,imageName:NSString!,selectImage:NSString?,tag:Int){
        
        controller.title = title as String
        var vc = UIViewController()
        if (navigation==true) {
            vc = CustomNavigationController(rootViewController: controller)
        }else{
            vc = controller
        }
        let tabbarItem = UITabBarItem(title: title as String, image: UIImage(named:imageName! as String), tag: tag)
        tabbarItem.selectedImage = UIImage(named: selectImage! as String)
        vc.tabBarItem = tabbarItem
        self.itemArr.append(vc)
        self.viewControllers = self.itemArr
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
