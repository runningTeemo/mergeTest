//
//  QXActionSheet.swift
//  QXActionSheetDemo
//
//  Created by Richard.q.x on 2016/11/16.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

func QXActionSheetShow(onVc: UIViewController?, cancelBtn: Bool, actions: (title: String?, responder: (() -> ())?)...) {
    if let onVc = onVc {
        var items = [QXActionSheetItem]()
        for i in 0..<actions.count {
            let action = actions[i]
            let item = QXActionSheetItem(title: action.title, responder: action.responder)
            items.append(item)
            if i == actions.count - 1 {
                if cancelBtn {
                    let space = QXActionSheetItem(spaceHeight: 5)
                    items.append(space)
                    let cancel = QXActionSheetItem(cancelTitle: "取消")
                    items.append(cancel)
                }
            } else {
                let breakLine = QXActionSheetItem(breakLineHeight: 0.5)
                breakLine.backColor = kClrBreak
                items.append(breakLine)
            }
        }
        let vc = QXActionSheetViewController(items: items)
        onVc.present(vc, animated: false, completion: nil)
    }
}


class QXActionSheetItem {
    
    convenience init(title: String?, responder: (() -> ())?) {
        self.init(isBreakLine: false, isCancel: false, isSpace: false)
        self.title = title
        self.responder = responder
    }
    convenience init(cancelTitle: String?) {
        self.init(isBreakLine: false, isCancel: true, isSpace: false)
        self.title = cancelTitle
        self.responder = nil
    }
    convenience init(breakLineHeight: CGFloat, color: UIColor = UIColor.gray) {
        self.init(isBreakLine: true, isCancel: false, isSpace: false)
        self.title = nil
        self.responder = nil
        self.customView = nil
        self.backColor = color
        self.height = breakLineHeight
    }
    convenience init(spaceHeight: CGFloat) {
        self.init(isBreakLine: false, isCancel: false, isSpace: true)
        self.title = nil
        self.responder = nil
        self.customView = nil
        self.height = spaceHeight
    }
    
    let isBreakLine: Bool
    let isCancel: Bool
    let isSpace: Bool
    required init(isBreakLine: Bool, isCancel: Bool, isSpace: Bool) {
        self.isBreakLine = isBreakLine
        self.isCancel = isCancel
        self.isSpace = isSpace
    }
    
    var title: String?
    var responder: (() -> ())?
    var customView: UIView?
    
    var height: CGFloat = 45
    var titleAttriDic: [String: AnyObject] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16),
        NSForegroundColorAttributeName: UIColor.black
    ]
    var backColor: UIColor = UIColor.white
    var highlightBackColor: UIColor = UIColor.lightGray
}

class QXActionSheetViewController: UIViewController {
    
    let items: [QXActionSheetItem]
    
    lazy var sheetBack: UIView = {
        let one = UIView()
        return one
    }()
    
    private var sheetFrame: CGRect!
    private var sheetOrigenFrame: CGRect!

    required init(items: [QXActionSheetItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom

        let W = UIScreen.main.bounds.size.width
        let H = UIScreen.main.bounds.size.height

        var totalHeight: CGFloat = 0
        var tag: Int = 0
        
        for item in items {
            let btn = QXActionSheetButton()
            btn.item = item
            btn.frame = CGRect(x: 0, y: totalHeight, width: W, height: item.height)
            btn.tag = tag
            if item.isCancel {
                btn.addTarget(self, action: #selector(QXActionSheetViewController.cancel), for: .touchUpInside)
            } else {
                if !item.isSpace && !item.isBreakLine {
                    btn.addTarget(self, action: #selector(QXActionSheetViewController.btnClick(sender:)), for: .touchUpInside)
                }
            }
            sheetBack.addSubview(btn)
            totalHeight += item.height
            tag += 1
        }
        sheetFrame = CGRect(x: 0, y: H - totalHeight, width: W, height: totalHeight)
        sheetOrigenFrame = CGRect(x: 0, y: H, width: W, height: totalHeight)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.addSubview(sheetBack)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        sheetBack.frame = sheetOrigenFrame
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.sheetBack.frame = self.sheetFrame
        })
    }
    
    func btnClick(sender: QXActionSheetButton) {
        let idx = sender.tag
        let item = items[idx]
        item.responder?()
        cancel()
    }
    func cancel() {
        UIView.animate(withDuration: 0.2, animations: {
            self.sheetBack.frame = self.sheetOrigenFrame
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancel()
    }
    
}

class QXActionSheetButton: UIButton {
    
    var item: QXActionSheetItem? {
        didSet {
            if let item = item {
                if item.isBreakLine {
                    self.isUserInteractionEnabled = false
                    self.setBackgroundImage(image(forColor: item.backColor), for: .normal)
                } else if item.isSpace {
                    self.isUserInteractionEnabled = false
                    self.setBackgroundImage(image(forColor: UIColor.clear), for: .normal)
                } else {
                    self.isUserInteractionEnabled = true
                    var title: String = ""
                    if let t = item.title {
                        title = t
                    }
                    let attri = NSAttributedString(string: title, attributes: item.titleAttriDic)
                    self.setAttributedTitle(attri, for: .normal)
                    self.setBackgroundImage(image(forColor: item.backColor), for: .normal)
                    self.setBackgroundImage(image(forColor: item.highlightBackColor), for: .highlighted)
                }
            }
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func image(forColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0);
        let ctx = UIGraphicsGetCurrentContext()!;
        forColor.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
}
