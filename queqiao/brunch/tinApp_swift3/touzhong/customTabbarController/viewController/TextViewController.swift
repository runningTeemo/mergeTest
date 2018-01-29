//
//  TextViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class TextViewController: RootViewController {
    
    var text: String? {
        didSet {
            textView.text = text
        }
    }
    
    lazy var textView: UITextView = {
        let one = UITextView()
        one.font = UIFont.systemFont(ofSize: 15)
        one.textColor = kClrDeepGray
        one.isEditable = false
        one.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        setupNavBackBlackButton(nil)
    }
}
