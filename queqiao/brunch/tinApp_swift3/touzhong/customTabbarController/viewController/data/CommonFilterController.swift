//
//  FilterController.swift
//  touzhong
//
//  Created by zerlinda on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum EntranceDirection{
    case left
    case right
}

class CommonFilterController: RootViewController {
    
    var bgView = UIView()
    let mainView:UIView = UIView()
    var originFrame:CGRect = CGRect.zero
    var finalFrame:CGRect = CGRect.zero
    var hightProportion:CGFloat = 1
    var hiddenBtn:Bool = false{
        didSet{
            for i in 0..<2{
                let btn = self.mainView.viewWithTag(100+i)
                btn?.isHidden = hiddenBtn
            }
        }
    }
    var widthProportion:CGFloat = 0.7{
        didSet{
        }
    }
    /// 设置侧滑出来的方向
    var entranceDirection:EntranceDirection = EntranceDirection.left{
        didSet{
            if entranceDirection == .right{
                originFrame = CGRect(x: self.view.bounds.size.width*(1+widthProportion), y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
                finalFrame = CGRect(x: self.view.bounds.size.width*(1-widthProportion), y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
            }else{
                originFrame = CGRect(x: -self.view.bounds.size.width*widthProportion, y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
                finalFrame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width*widthProportion, height: self.view.bounds.size.height*hightProportion)
            }
            self.mainView.frame = self.originFrame
            self.createModule()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showFilter()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
        createBgView()
        addGesForBgView()
        
    }
    /**
     创建控件
     
     - author: zerlinda
     - date: 16-09-12 16:09:10
     */
    func createModule(){
        createBtn()
        createLine()
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
        self.view.addSubview(mainView)        
    }
    
    func createLine(){
        let line = UIView()
        line.backgroundColor = cellLineColor
        mainView.addSubview(line)
        line.frame = CGRect(x: 0, y: self.view.frame.height-50, width: mainView.frame.width, height: 0.5)
    }
    
    func createBtn(){
        
        let titleArr = ["重置","完成"]
        
        for i in 0..<titleArr.count {
            
            let btn = UIButton(type: UIButtonType.custom)
            
            btn.setTitle(titleArr[i], for: UIControlState())
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            
            btn.tag = 100+i
            
            btn.addTarget(self, action: #selector(DataFilterController.btnAction), for: UIControlEvents.touchUpInside)
            
            self.mainView.addSubview(btn)
            
            if i==0 {
                
                btn.setTitleColor(MyColor.colorWithHexString("#666666"), for: UIControlState())
                btn.backgroundColor = HEX("#ffffff")
                
            }else{
                
                btn.setTitleColor(UIColor.white, for: UIControlState())
                btn.backgroundColor = MyColor.colorWithHexString("#d61f26")
            }
        }
        
        if let btn = self.mainView.viewWithTag(100)  {
            btn.frame = CGRect(x: 0, y: self.view.frame.height-50, width: self.mainView.frame.size.width/2, height: 50)
        }
        if let btn = self.mainView.viewWithTag(101)  {
            btn.frame = CGRect(x: self.mainView.frame.size.width/2, y: self.view.frame.height-50, width: self.mainView.frame.size.width/2, height: 50)
        }
        
    }
    
    func btnAction(_ btn:UIButton){
        
        if btn.tag == 100 {
            
        }else{
            
        }
    }    
    
    /**
     侧滑出场动画
     
     - author: zerlinda
     - date: 16-08-31 22:08:27
     */
    func showFilter(){
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.alpha = 0.5
            self.mainView.frame = self.finalFrame
        }) 
    }
    
    /**
     给背景加手势
     
     - author: zerlinda
     - date: 16-08-31 22:08:52
     */
    func addGesForBgView(){
        bgView.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(CommonFilterController.tapAction))
        bgView.addGestureRecognizer(tapGes)
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(CommonFilterController.panAction(_:)))
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
            self.mainView.frame = self.originFrame
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
            
        }
        if ges.direction == UISwipeGestureRecognizerDirection.right {
            
        }
        
    }
    /**
     滑动手势
     
     - author: zerlinda
     - date: 16-08-31 22:08:52
     
     - parameter ges:
     */
    func panAction(_ ges:UIPanGestureRecognizer){
        _ = ges.translation(in: self.view).x
        if entranceDirection == .right {
            
        }
        if entranceDirection == .left {
            
        }
        
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
