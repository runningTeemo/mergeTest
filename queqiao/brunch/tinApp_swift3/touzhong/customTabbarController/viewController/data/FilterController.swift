//
//  FilterController.swift
//  touzhong
//
//  Created by zerlinda on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit


class FilterController: RootViewController {
    
    var bgView = UIView()
    let tabView:UIView = UIView()
    var originFrame:CGRect = CGRect.zero
    var finalFrame:CGRect = CGRect.zero
    var hightProportion:CGFloat = 1
    var widthProportion:CGFloat = 0.7
    /// 设置侧滑出来的方向
    var entranceDirection:EntranceDirection = EntranceDirection.left{
        didSet{
            if entranceDirection == .right{
                originFrame = CGRect(x: self.view.bounds.size.width*(1+widthProportion), y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
                finalFrame = CGRect(x: self.view.bounds.size.width*(1-widthProportion), y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
            }else{
                originFrame = CGRect(x: -self.view.bounds.size.width*widthProportion, y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
                finalFrame = CGRect(x: self.view.bounds.size.width*widthProportion, y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
        createBgView()
        addGesForBgView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showFilter()
    }
    /**
     创建灰色背景
     
     - author: zerlinda
     - date: 16-08-31 22:08:41
     */
    func createBgView(){
        self.view.addSubview(bgView)
        bgView.frame = self.view.frame
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0
        self.tabView.backgroundColor = UIColor.white
        self.view.addSubview(tabView)
        
        
    }
    /**
     侧滑出场动画
     
     - author: zerlinda
     - date: 16-08-31 22:08:27
     */
    func showFilter(){
        self.tabView.frame = originFrame
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.alpha = 0.5
            self.tabView.frame = self.finalFrame
        }) 
    }
    
    /**
     给背景加手势
     
     - author: zerlinda
     - date: 16-08-31 22:08:52
     */
    func addGesForBgView(){
        bgView.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(FilterController.tapAction))
        bgView.addGestureRecognizer(tapGes)
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(FilterController.panAction(_:)))
        bgView.addGestureRecognizer(panGes)
    }
    
    /**
     点击手势
     
     - author: zerlinda
     - date: 16-08-31 22:08:06
     */
    func tapAction(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.alpha = 0
            self.tabView.frame = self.originFrame
        }, completion: { (com) in
            if com{
                self.dismiss(animated: true, completion: nil)
            }
        }) 
    }
    
    /**
     滑动手势
     
     - author: zerlinda
     - date: 16-08-31 22:08:40
     
     - parameter ges: <#ges description#>
     */
    func  swipAction(_ ges:UISwipeGestureRecognizer){
        
        if ges.direction == UISwipeGestureRecognizerDirection.left {
            print("左滑了")
        }
        if ges.direction == UISwipeGestureRecognizerDirection.right {
            print("右滑了")
        }
        
    }
    /**
     滑动手势
     
     - author: zerlinda
     - date: 16-08-31 22:08:52
     
     - parameter ges:
     */
    func panAction(_ ges:UIPanGestureRecognizer){
      //  var panX = ges.translation(in: self.view).x
        if entranceDirection == .right {
            
        }
        if entranceDirection == .left {
            
        }
        print(ges.translation(in: self.view).x)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
