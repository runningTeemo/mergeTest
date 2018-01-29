//
//  StaticCellBaseViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellBaseViewController: RootTableViewController {
    
    var staticItems: [StaticCellBaseItem] = [StaticCellBaseItem]()
    var editChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(StaticCellSpaceCell.self, forCellReuseIdentifier: "StaticCellSpaceCell")

        tableView.register(StaticCellBaseCell.self, forCellReuseIdentifier: "StaticCellBaseCell")
        tableView.register(StaticCellTextCell.self, forCellReuseIdentifier: "StaticCellTextCell")
        tableView.register(StaticCellArrowCell.self, forCellReuseIdentifier: "StaticCellArrowCell")
        tableView.register(StaticCellSubTitleCell.self, forCellReuseIdentifier: "StaticCellSubTitleCell")
        tableView.register(StaticCellSwitchCell.self, forCellReuseIdentifier: "StaticCellSwitchCell")
        tableView.register(StaticCellTextButtonCell.self, forCellReuseIdentifier: "StaticCellTextButtonCell")

        tableView.register(StaticCellTextInputCell.self, forCellReuseIdentifier: "StaticCellTextInputCell")
        tableView.register(StaticCellWarningCell.self, forCellReuseIdentifier: "StaticCellWarningCell")

        tableView.register(StaticCellButtonCell.self, forCellReuseIdentifier: "StaticCellButtonCell")
        tableView.register(StaticCellLoadingButtonCell.self, forCellReuseIdentifier: "StaticCellLoadingButtonCell")
        
        tableView.register(StaticCellLabelsPickerCell.self, forCellReuseIdentifier: "StaticCellLabelsPickerCell")
        
        tableView.register(StaticCellSelectCell.self, forCellReuseIdentifier: "StaticCellSelectCell")
        
        tableView.register(StaticCellTextViewCell.self, forCellReuseIdentifier: "StaticCellTextViewCell")
        tableView.register(StaticCellCountTextViewCell.self, forCellReuseIdentifier: "StaticCellCountTextViewCell")
        
        tableView.register(StaticCellImagesPickerCell.self, forCellReuseIdentifier: "StaticCellImagesPickerCell")

        
        NotificationCenter.default.addObserver(self, selector: #selector(StaticCellBaseViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StaticCellBaseViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = staticItems[indexPath.row]
        var clsStr = NSStringFromClass(type(of: item)) as NSString
        clsStr = clsStr.components(separatedBy: ".").last! as NSString
        clsStr = clsStr.replacingOccurrences(of: "Item", with: "Cell") as NSString
        let cell = tableView.dequeueReusableCell(withIdentifier: clsStr as String) as! StaticCellBaseCell
        cell.item = item
        cell.tableView = tableView
        cell.indexPath = indexPath
        cell.vc = self
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = staticItems[indexPath.row]
        return item.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return staticItems[indexPath.row].responder != nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        staticItems[indexPath.row].responder?()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -40 && isDragging {
            view.endEditing(true)
        }
    }
    
    //MARK: keyboard
    
    fileprivate var origenFooterView: UIView?
    fileprivate var isSecondShow: Bool = false // 解决第三方键盘的多次弹出问题
    func keyboardWillShow(_ notice: Notification) {
        if (notice as NSNotification).userInfo == nil { return }
        if isSecondShow { return }
        isSecondShow = true
        // 解决第三方键盘的多次弹出问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.isSecondShow = false
        }
        let frame = (notice as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]
        if let f = frame {
            let v = f as! NSValue
            let rect = v.cgRectValue
            // 这里有tabBar则还要-49
            let endHeight = rect.size.height + 20 + 40
            if let footerView = tableView.tableFooterView {
                if !footerView.isKind(of: KeyboardSpaceView.self) {
                    origenFooterView = footerView
                }
            }
            let footerView = KeyboardSpaceView(frame: CGRect(x: 0,y: 0,width: 0,height: endHeight))
            tableView.tableFooterView = footerView
        }
    }
    
    func keyboardWillHide() {
        tableView.tableFooterView = origenFooterView
        origenFooterView = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

class KeyboardSpaceView: UIView { }
