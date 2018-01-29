//
//  AlbumPhotoMainViewController.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/7.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

enum AlbumPhotoOperateType {
    case mutiSelect
    case singleSelect
    case singleSelectAndEdit
}

class AlbumPhotoMainViewController: RootTableViewController {
    
    //MARK: bussiness
    var responder: ((_ images: [UIImage]) -> ())?
    var maxSelectCount: Int = 9
    var operateType: AlbumPhotoOperateType = .mutiSelect
    var pixelLimt: CGFloat?
    
    func cancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    override func onFirstWillAppear() {
        
        AlbumPhotoHelper.fetchAlbums { [weak self] (albums, success) in
            if success {
                if let s = self {
                    if let arr = albums as? [AlbumReslut] {
                        s.models = arr
                        s.tableView.reloadData()
                        if s.models.count > 0 {
                            s.didTouchCell(IndexPath(row: 0, section: 0))
                        }
                    }
                }
                self?.tableView.reloadData()
                
            } else {
                print("failed")
                self?.cancelBtnClick()
            }
        }
    }
    
    fileprivate func didTouchCell(_ indexPath: IndexPath) {
        
        let vc = AlbumPhotoPickerViewController()
        vc.responder = responder
        vc.maxSelectCount = maxSelectCount
        vc.operateType = operateType
        vc.pixelLimt = pixelLimt
        let cell = tableView(tableView, cellForRowAt: indexPath) as! AlbumPhotoMainViewCell
        vc.title = cell.name
        
        let albumResult = models[indexPath.section]
        if indexPath.section == 0 {
            vc.albumResult = albumResult
        } else {
            vc.albumResult = albumResult.getAlbumForIdx(indexPath.row)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: setup views
    fileprivate var models: [AlbumReslut] = [AlbumReslut]()
    fileprivate lazy var cancelBtn: UIButton = {
        let attriStr = NSAttributedString(string: "取消", attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: UIColor.black
            ])
        let one = UIButton(type: .system)
        one.setAttributedTitle(attriStr, for: UIControlState())
        one.addTarget(self, action: #selector(AlbumPhotoMainViewController.cancelBtnClick), for: .touchUpInside)
        one.sizeToFit()
        return one
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择图片"
        tableView.register(AlbumPhotoMainViewCell.self, forCellReuseIdentifier: "AlbumPhotoMainViewCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelBtn)
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return models.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return models[section].getPhotoCount()
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumPhotoMainViewCell") as! AlbumPhotoMainViewCell
        let albumReslut = models[indexPath.section]
        if indexPath.section == 0 {
            cell.name = "相机胶卷"
            albumReslut.asycGetFirstImage { (image) in
                cell.icon = image
            }
        } else {
            cell.name = albumReslut.getTitleForIdx(indexPath.row)
            let subAlbumReslut = albumReslut.getAlbumForIdx(indexPath.row)!
            subAlbumReslut.asycGetFirstImage { (image) in
                cell.icon = image
            }
        }
        let count = albumReslut.getPhotoCount()
        cell.showBottomLine = (indexPath.row < count - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.didTouchCell(indexPath)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

class AlbumPhotoMainViewCell: RootTableViewCell {
    
    //MARK: bussiness
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    var icon: UIImage? {
        didSet {
            iconView.image = icon
        }
    }
    
    //MARK: setup views
    fileprivate lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        one.image = nil
        one.backgroundColor = UIColor.gray
        one.contentMode = .scaleAspectFill
        return one
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.black
        one.font = UIFont.systemFont(ofSize: 18)
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconView)
        setupRightArrow()
        
        iconView.IN(contentView).LEFT(10).CENTER.SIZE(40, 40).MAKE()
        nameLabel.RIGHT(iconView).OFFSET(10).CENTER.MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-rightMargin).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
