//
//  DataSummariseBubbleViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/9.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import Foundation

class DataSummariseBubbleViewController: RootBubbleListViewController {
    
    var titlePrefix: String = "投资"
    var titleSurfix: String?

    var institutions: [TinSummariseInstitution] = [TinSummariseInstitution]() {
        didSet {
            var a: String = titlePrefix
            let b: String? = titleSurfix
            let mAttr = NSMutableAttributedString()

            if let first = institutions.first {
                if first.type == .institution {
                    a +=  "机构Top\(institutions.count)"
                } else {
                    a += "企业Top\(institutions.count)"
                }
            } else {
                a = "投资机构"
            }
            
            let dic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: 16), color: kClrDeepGray)
            let attriA = StringTool.size(a, attriDic: dic).attriStr!
            mAttr.append(attriA)
            if let b = b {
                let spaceAttri = StringTool.size("  ", attriDic: dic).attriStr!
                mAttr.append(spaceAttri)
                let titleBreak = AttributedStringTool.notNullAttributedImage(named: "sx", bounds: CGRect(x: 0, y: 0, width: 1, height: 12))
                mAttr.append(titleBreak)
                let spaceAttri1 = StringTool.size("  ", attriDic: dic).attriStr!
                mAttr.append(spaceAttri1)
                let attriB = StringTool.size(b, attriDic: dic).attriStr!
                mAttr.append(attriB)
            }
            
            headAttriTitle = mAttr
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DataSummariseBubbleInstitutionCell.self, forCellReuseIdentifier: "DataSummariseBubbleInstitutionCell")
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        
        var height: CGFloat = 0
        height += retainHeight
        height += CGFloat(institutions.count) * DataSummariseBubbleInstitutionCell.cellHeight()
        
        updateHeight?(height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return institutions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataSummariseBubbleInstitutionCell") as! DataSummariseBubbleInstitutionCell
        cell.institution = institutions[indexPath.row]
        cell.indexLabel.text = String(format: "%02d", indexPath.row + 1) + " "
        if indexPath.row < 3 {
            cell.indexLabel.textColor = kClrOrange
        } else {
            cell.indexLabel.textColor = kClrBlue
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataSummariseBubbleInstitutionCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let institution = institutions[indexPath.row]
        if institution.type == .institution {
            let vc = InstitutionDetailViewController()
            vc.id = "\(SafeUnwarp(institution.id, holderForNull: 0))"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let vc = EnterpriseDetailViewController()
            vc.id = "\(SafeUnwarp(institution.id, holderForNull: 0))"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}


class DataSummariseBubbleInstitutionCell: RootTableViewCell {
    
    override class func cellHeight() -> CGFloat {
        return 30
    }
    
    var institution: TinSummariseInstitution! {
        didSet {
            titleLabel.text = institution.shortName
            
            if institution.amount <= 0 {
                amountLabel.text = "N/A"
            } else {
                amountLabel.text = "\(StaticCellTools.numberToDecNumber(number: institution.amount))万美元"
            }
            if kScreenW < 330 {
                countLabel.text = "(\(institution.count)次)"
            } else {
                countLabel.text = "\(institution.count)次"
            }
        }
    }
    
    lazy var indexLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.italicSystemFont(ofSize: 15)
        return one
    }()
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrBlue
        return one
    }()
    lazy var amountLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrDeepGray
        return one
    }()
    lazy var countLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrLightGray
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(indexLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(countLabel)
        indexLabel.IN(contentView).LEFT(20).CENTER.WIDTH(30).MAKE()
        
        if kScreenW < 330 {
            titleLabel.RIGHT(indexLabel).CENTER.OFFSET(5).WIDTH(90).MAKE()
            amountLabel.RIGHT(titleLabel).CENTER.OFFSET(5).MAKE()
            countLabel.RIGHT(amountLabel).CENTER.OFFSET(5).MAKE()
        } else {
            titleLabel.RIGHT(indexLabel).CENTER.OFFSET(5).WIDTH(100).MAKE()
            amountLabel.RIGHT(titleLabel).CENTER.OFFSET(5).WIDTH(120).MAKE()
            countLabel.RIGHT(amountLabel).CENTER.OFFSET(5).WIDTH(50).MAKE()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



