//
//  QxyViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/10/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class UserTest: NSObject {
    var name:String?
    var age:String?
    var desc:String?
    var chengji:[Chengji]?
}
class Chengji: NSObject{
    var kemu:String?
    var score:String?
    var teacher:Teacher?
}

class Teacher: NSObject {
    var name:String?
    var sex:String?
}

class QxyViewController: RootViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
       // testSwitch()
    }
    
    func testSwitch(){
        let sw = ZJSwitch()
        sw.style = ZJSwitchStyle.noBorder
//        sw.tintColor = MyColor.colorWithHexString("#f9f8f8")
//        sw.offTextColor = MyColor.colorWithHexString("#999999")
        sw.onTintColor = MyColor.colorWithHexString("#23c966")
//        sw.onTextColor = MyColor.colorWithHexString("#ffffff")
        sw.textFont = UIFont.systemFont(ofSize: 9)
        sw.onText = "允许"
        sw.offText = "拒绝"
        sw.frame = CGRect(x: 49, y: 100, width: 60, height: 29)
        view.addSubview(sw)

    }
    
    
    func modelToDic(){
        let model = UserTest()
        model.name = "钱"
        model.age = "18"
        model.desc = "详情"
        let c = Chengji()
        c.kemu = "语文"
        c.score = "90"
        let s = Chengji()
        s.kemu = "数学"
        s.score = "60"
        model.chengji = [c,s]
        let dic:[String:AnyObject] = model.keyValues!
        let dicN = dic as NSDictionary
        print(dic)
        print(dicN)
        
    }
    
    func zoomPictures(){
        let imageV = UIImageView()
        view.addSubview(imageV)
        imageV.frame = CGRect(x: 100, y: 100, width: 100, height: 20)
        let image = UIImage(named: "startlogo1")
        //let padding = 25 * (image?.scale)!
        let edge = UIEdgeInsetsMake(1, 1, 99, 99)
        let resizeImage = image?.resizableImage(withCapInsets: edge)
        imageV.image = resizeImage
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell:ApplyCheckCell?
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ApplyCheckCell
        if !(cell != nil) {
            cell = ApplyCheckCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        cell!.cellWidth = self.view.frame.width
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func testLeftLabelAndRightLabel(){
        let arr = ["您好飞啊飞而发生日让果然够vdsf爱上反而 200万","启明投资2 3999","爱测 100万","dettewr 3000万"/*,"测试一个一个非常非常长的投资数字非常非常非常非常长 1000万","啦啦啦 100","二级及覅那里 1993u","定位来烦你了反而离 缴费金额哦啊","挖肺；阿尔据个人日积分"*/]
        let view = LeftAndRightLabel()
        view.textArr = arr
        view.frame = CGRect(x: 12.5, y: 100, width: self.view.frame.width - 25, height: 30)
        view.update()
        view.backgroundColor = UIColor.red
        print(view.frame.height)
    }
    
    var arrow:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconScreenMore")
        return imageView
    }()
    var foldState:Bool = true{
        didSet{
            if foldState == false {
                arrow.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func alertC (){
        let alertController = UIAlertController()
        let cancelAction = UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:nil)
        let deleteAction = UIAlertAction(title:"删除", style: UIAlertActionStyle.destructive, handler: nil)
        let archiveAction = UIAlertAction(title:"保存", style: UIAlertActionStyle.default, handler: nil)
        let archiveAction2 = UIAlertAction(title:"保存", style: UIAlertActionStyle.default, handler: nil)
        let archiveAction3 = UIAlertAction(title:"保存", style: UIAlertActionStyle.default, handler: nil)
        let archiveAction4 = UIAlertAction(title:"保存", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        alertController.addAction(archiveAction2)
        alertController.addAction(archiveAction3)
        alertController.addAction(archiveAction4)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func share(){
        let vc = ShareViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.urlName = "http://www.baidu.com"
        vc.titleName = "你好"
        vc.desc = "详情"
        self.present(vc, animated: true) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
