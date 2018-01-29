//
//  CommonCell.swift
//  touzhong
//
//  Created by zerlinda on 16/8/16.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

typealias ReloadCellClosure = (_ indexPath : IndexPath)->()

class CommonCell: RootTableViewCell {

    var pushVC:((_ vc:UIViewController)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var cellWidth:CGFloat = 0{
        didSet{
           self.addModuleAndChangeFrame()
        }
    }
    
    func addModuleAndChangeFrame(){
        
    }
    /// 自定义cell的分割线
    lazy var cellLine :UIView = {
        let cellLine = UIView()
        cellLine.backgroundColor = cellLineColor
        return cellLine
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ChangeModel.changeModelColor()
        self.textLabel?.textColor = ChangeModel.changeViewModelTextColor(UIColor.black)
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(CommonCell.changeModel), name: NSNotification.Name(rawValue: "changeModel"), object: nil);
        self.contentView.addSubview(cellLine)
        
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func changeModel(){
        
        self.contentView.backgroundColor = ChangeModel.changeModelColor()
        self.textLabel?.textColor = ChangeModel.changeViewModelTextColor(UIColor.black)
    }

//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//       // print(view?.classForCoder)
//        if view == self{
//            return nil
//        }else{
//            return view
//        }
//    }
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        return true
//    }
}
