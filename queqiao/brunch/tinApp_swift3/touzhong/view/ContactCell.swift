//
//  ContactCell.swift
//  touzhong
//
//  Created by zerlinda on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ContactCell: CommonCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var viewModel:ContactViewModel = ContactViewModel(){
        didSet{
            fillData()
            addModuleAndChangeFrame()
        }
    }
    var viewController:UIViewController?
    var contact:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.numberOfLines = 0
        return label
    }()
    
    var phoneLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.numberOfLines = 0
        label.tag = 101
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var emailLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.numberOfLines = 0
        label.tag = 102
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var address:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#666666")
        label.numberOfLines = 0
        return label
    }()
    
    func fillData(){
        contact.text = "联系人: \(SafeUnwarp(viewModel.model.contacter, holderForNull: ""))"
        contact.sizeToFit()
        phoneLabel.text = "联系方式: \(SafeUnwarp(viewModel.model.tel, holderForNull: ""))"
        phoneLabel.sizeToFit()
        emailLabel.text = "电子邮箱: \(SafeUnwarp(viewModel.model.email, holderForNull: ""))"
        emailLabel.sizeToFit()
        address.text = "地址: \(SafeUnwarp(viewModel.model.address, holderForNull: ""))"
        address.sizeToFit()
    }
    
    override func addModuleAndChangeFrame(){
        if cellWidth==0 {
            return
        }
        WordWrap()
        fillData()
        WordWrap()
        Tools.setAttibuteColor(contact, divisionStr: " ", attributeColor: MyColor.colorWithHexString("#333333"))
        Tools.setAttibuteColor(phoneLabel, divisionStr: " ", attributeColor: mainBlueColor)
        Tools.setAttibuteColor(emailLabel, divisionStr: " ", attributeColor: mainBlueColor)
        Tools.setAttibuteColor(address, divisionStr: " ", attributeColor: MyColor.colorWithHexString("#333333"))
        viewModel.cellHeight = address.frame.maxY+20
        cellLine.frame = CGRect(x: 0, y: viewModel.cellHeight!-0.5, width: cellWidth-leftStartX*2, height: 0.5)
    }
    func WordWrap(){
        contact.frame = CGRect(x: leftStartX, y: 15, width: cellWidth-leftStartX*2, height: contact.frame.size.height)
        phoneLabel.frame = CGRect(x: leftStartX, y: contact.frame.maxY+6, width: cellWidth-leftStartX*2, height: phoneLabel.frame.size.height)
        emailLabel.frame = CGRect(x: leftStartX, y: phoneLabel.frame.maxY+6, width: cellWidth, height: emailLabel.frame.size.height)
        address.frame = CGRect(x: leftStartX, y: emailLabel.frame.maxY+6, width: cellWidth-leftStartX*2, height: address.frame.size.height)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(contact)
        self.contentView.addSubview(phoneLabel)
        self.contentView.addSubview(emailLabel)
        self.contentView.addSubview(address)
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(ContactCell.sureAction(tapGes:)))
        phoneLabel.addGestureRecognizer(phoneTap)
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(ContactCell.sureAction(tapGes:)))
        emailLabel.addGestureRecognizer(emailTap)
        
    }
    func phoneAction(){
        print("拨打电话")
    //拨打电话
        let url = NSURL(string: "tel://\(SafeUnwarp(viewModel.model.tel, holderForNull: ""))")
        if  url != nil{
            UIApplication.shared.openURL(url as! URL)
        }
    }
    func emailAction(){
        print("发送邮件")
        //发送邮件
        UIApplication.shared.openURL(NSURL(string: "mailto://\(SafeUnwarp(viewModel.model.email, holderForNull: ""))") as! URL)
    }
    
    func sureAction(tapGes:UITapGestureRecognizer){
        if viewController == nil {
            return
        }
        weak var ws = self
        if tapGes.view?.tag == 101 {
            Confirmer.show("提示", message: "是否拨打该号码", confirm: "确定", confirmHandler: {
                //拨打电话
                let url = NSURL(string: "tel://\(SafeUnwarp(ws?.viewModel.model.tel, holderForNull: ""))")
                if  url != nil{
                    UIApplication.shared.openURL(url as! URL)
                }
            }, cancel: "取消", cancelHandler: {
                
            }, inVc: viewController)
        }
        if tapGes.view?.tag == 102 {
            Confirmer.show("提示", message: "是否发送邮件", confirm: "确定", confirmHandler: {
                //发送邮件
                UIApplication.shared.openURL(NSURL(string: "mailto://\(SafeUnwarp(ws?.viewModel.model.email, holderForNull: ""))") as! URL)
            }, cancel: "取消", cancelHandler: {
                
            }, inVc: viewController)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
