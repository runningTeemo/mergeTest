//
//  RootBubbleViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

let kBubbleContentWidth: CGFloat = RootBubbleViewController.width

class BubbleHelper {
    class func show(_ vc: RootBubbleListViewController, startPoint: CGPoint?, onVc: UIViewController?) {
        let rootVc = RootBubbleViewController()
        rootVc.startPoint = startPoint
        rootVc.contentVc = vc
        vc.updateHeight = { [unowned rootVc] h in
            rootVc.updateHeight(h)
        }
        vc.prepareHeight = { [unowned rootVc] h in
            rootVc.prepareHeight(h)
        }
        let rootNav = RootNavigationController(rootViewController: rootVc)
        rootNav.modalPresentationStyle = .custom
        onVc?.present(rootNav, animated: false, completion: nil)
    }
}

class RootBubbleViewController: UIViewController {
    
    var respondDismiss: (() -> ())?
    
    var contentVc: UIViewController? {
        didSet {
            if let vc = contentVc {
                view.addSubview(vc.view)
                vc.view.layer.cornerRadius = bubbleView.layer.cornerRadius
                vc.view.clipsToBounds = true
                addChildViewController(vc)
                bubbleView.frame = _startPointToFrame()
                vc.view.frame = self._contentFrameForFrame(bubbleView.frame)
                self.closeBtn.frame = self._closeBtnFrameForFrame(bubbleView.frame)
                vc.view.IN(bubbleView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
            }
        }
    }
    
    private var resizeContent: (() -> ())?
    func updateHeight(_ h: CGFloat) {
        
        if h < RootBubbleViewController.minHeight {
            return
        }
        resizeContent = { [weak self] in
            if let s = self {
                if let view = s.contentVc?.view {
                    UIView.animate(withDuration: RootBubbleViewController.resizeDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2, options: .beginFromCurrentState, animations: {
                        s.bubbleView.frame = s._heightToFrame(s._fitHeightForHeight(h))
                        view.frame = s._contentFrameForFrame(s.bubbleView.frame)
                        s.closeBtn.frame = s._closeBtnFrameForFrame(s.bubbleView.frame)
                    }) { c in
                    }
                }
            }
        }
//        if appearAnimationEnded {
//            resizeContent?()
//        }
        resizeContent?()

    }
    
    private var _preparedHeight: CGFloat?
    func prepareHeight(_ h: CGFloat) {
        _preparedHeight = h
    }
    var startPoint: CGPoint? // 泡泡弹出的位置（为空表示从中间）

    static let duration: TimeInterval = 0.5
    static let resizeDuration: TimeInterval = 0.2
    
    static let cornerRadius: CGFloat = 8
    static let screenLrMargin: CGFloat = 20
    static let minHeight: CGFloat = 200
    static let maxHeight: CGFloat = kScreenH * 0.7
    static var width: CGFloat {
        return kScreenW - RootBubbleViewController.screenLrMargin * 2
    }
    
    private func _heightToFrame(_ h: CGFloat) -> CGRect {
        let x = (kScreenW - RootBubbleViewController.width) / 2
        let y = (kScreenH - h) / 2
        return CGRect(x: x, y: y, width: RootBubbleViewController.width, height: h)
    }
    private func _startPointToFrame() -> CGRect {
        let w = RootBubbleViewController.cornerRadius * 2
        let h = RootBubbleViewController.cornerRadius * 2
        let _startPoint: CGPoint
        if let startPoint = startPoint {
            _startPoint = startPoint
        } else {
            _startPoint = CGPoint(x: kScreenW / 2, y: kScreenH / 2)
        }
        let x = _startPoint.x - w / 2
        let y = _startPoint.y - h / 2
        return CGRect(x: x, y: y, width: w, height: h)
    }
    private func _closeBtnFrameForFrame(_ f: CGRect) -> CGRect {
        return CGRect(x: f.maxX - 40, y: f.minY, width: 40, height: 40)
    }
    private func _contentFrameForFrame(_ f: CGRect) -> CGRect {
        return f
    }
    private func _fitHeightForHeight(_ h: CGFloat) -> CGFloat {
        return min(max(RootBubbleViewController.minHeight, h), RootBubbleViewController.maxHeight)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var closeBtn: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 14, height: 14)
        one.iconView.image = UIImage(named: "newsClose")
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.dismiss(animated: false, completion: { [weak self] c in
                self?.respondDismiss?()
            })
        })
        return one
    }()
    lazy var bubbleView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrWhite
        one.layer.cornerRadius = RootBubbleViewController.cornerRadius
        one.clipsToBounds = true
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBA(0, 0, 0, 0)
        view.addSubview(bubbleView)
        view.addSubview(closeBtn)
    }
    
    private var _isFirstWillAppear = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _isFirstWillAppear {
            _onFirstWillAppear()
            _isFirstWillAppear = false
        }
    }
    
    private var appearAnimationEnded: Bool = false
    private func _onFirstWillAppear() {
        if let view = contentVc?.view {
            view.frame = _startPointToFrame()
            self.closeBtn.frame = self._closeBtnFrameForFrame(self.bubbleView.frame)
            self.view.bringSubview(toFront: self.closeBtn)
            UIView.animate(withDuration: RootBubbleViewController.duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2, options: .beginFromCurrentState, animations: {
                if let h = self._preparedHeight {
                    self.bubbleView.frame = self._heightToFrame(self._fitHeightForHeight(h))
                } else {
                    self.bubbleView.frame = self._heightToFrame(RootBubbleViewController.minHeight)
                }
                view.frame = self._contentFrameForFrame(self.bubbleView.frame)
                self.closeBtn.frame = self._closeBtnFrameForFrame(self.bubbleView.frame)
                self.view.backgroundColor = RGBA(0, 0, 0, 80)
            }) { [weak self] c in
                self?.resizeContent?()
                self?.appearAnimationEnded = true
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: { [weak self] c in
            self?.respondDismiss?()
        })
    }
}
