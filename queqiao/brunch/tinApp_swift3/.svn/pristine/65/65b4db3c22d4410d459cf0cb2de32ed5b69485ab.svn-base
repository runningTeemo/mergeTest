//
//  PersonageTeamMumbersCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionTeamMumbersCell: CommonCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var tapAction:((_ personAgeId:String)->())?
    var viewModel:InstitutionViewModel = InstitutionViewModel(){
        didSet{
           // addModuleAndChangeFrame()
        }
    }
    
    var scrollV:UIScrollView = {
        let scrol = UIScrollView()
        scrol.showsVerticalScrollIndicator = false
        scrol.showsHorizontalScrollIndicator = false
        return scrol
    }()

    override func addModuleAndChangeFrame(){
        if viewModel.model.users == nil {
            return
        }
        
        for i in 0..<viewModel.model.users!.count {
            let dataModel = viewModel.model.users![i]
            let view = TeamMemberView()
            if let imageStr = dataModel.imgUrl {
                view.imageStr = imageStr
            }
            view.name = dataModel.cnName
            view.isQuited = dataModel.quited ?? ""
            scrollV.addSubview(view)
            view.frame = CGRect(x: 20+(54+15)*CGFloat(i), y: 15, width: 54,height: view.height)
            scrollV.contentSize = CGSize(width: 20+(54+15)*CGFloat(i+1),height: view.height)
            viewModel.teamMembersCellHeght = view.frame.maxY+20
            view.isUserInteractionEnabled = true
            view.tag = 100+i
            let tapGes = UITapGestureRecognizer(target: self, action:#selector(InstitutionTeamMumbersCell.tapAction(_:)))
            view.addGestureRecognizer(tapGes)
        }
        scrollV.frame = CGRect(x: 0, y: 0, width: cellWidth, height: viewModel.teamMembersCellHeght)
        
    }
    func tapAction(_ tap:UITapGestureRecognizer){
        let tag = tap.view?.tag
        if tag != nil{
           let model = viewModel.model.users?[tag!-100]
            if model?.userId != nil {
               tapAction?((model?.userId)!)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(scrollV)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}

class TeamMemberView: RootView {
    
    var imageStr:String?{
        didSet{
            if imageStr==nil {
                imageStr = ""
            }
            imageV.sd_setImage(with: URL(string:imageStr!), placeholderImage: UIImage(named: "iconUserImg"))
        }
    }
    var name:String?{
        didSet{
            label.text = name
            label.sizeToFit()
            label.textAlignment = NSTextAlignment.center
            label.isUserInteractionEnabled = false
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: self.imageV.frame.width, height: label.frame.height
            )
        }
    }
    var isQuited:String = ""{
        didSet{
            if isQuited == "1" {
                quitedLabel.isHidden = false
                label.textColor = MyColor.colorWithHexString("#999999")
            }else{
                quitedLabel.isHidden = true
                label.textColor = MyColor.colorWithHexString("#333333")
            }
        }
    }
    /// 头像
    var imageV:UIImageView = {
       let imageV = UIImageView()
        imageV.layer.cornerRadius = 27
        imageV.layer.masksToBounds = true
        imageV.clipsToBounds = true
        imageV.contentMode = UIViewContentMode.scaleAspectFill
        imageV.isUserInteractionEnabled = false
        return imageV
    }()
    
    var quitedLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = MyColor.colorWithHexString("999999")
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "离职"
        label.isHidden = true
        return label
    }()
    
    /// 姓名
    var label:UILabel = {
       let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var height:CGFloat{
        get{
            return 54+6+label.frame.size.height
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageV)
        self.addSubview(label)
        imageV.addSubview(quitedLabel)
        imageV.frame = CGRect(x: 0, y: 0, width: 54, height: 54)
        label.frame = CGRect(x: 0, y: imageV.frame.maxY+6, width: imageV.frame.width, height: label.frame.height)
        quitedLabel.frame = CGRect(x: 0, y: 54-13, width: 54, height: 13)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: label.frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

