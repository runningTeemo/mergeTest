//
//  RootFilterShower.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RootFilterShower: NSObject, UIViewControllerTransitioningDelegate {
    
    static let shareOne: RootFilterShower = RootFilterShower()
    weak var vc: UIViewController!
    weak var inVc: UIViewController!
    fileprivate(set) var onLeft: Bool!
    let filterVcWidthRatio: CGFloat = 0.8
    
    func show(onLeft: Bool, vc: UIViewController, inVc: UIViewController, complete: (() -> Void)?) {
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.vc = vc
        self.inVc = inVc
        self.onLeft = onLeft
        inVc.present(vc, animated: true, completion: complete)
    }
    //MARK: UIViewControllerTransitioningDelegate
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented == self.vc {
            let c = RootFilterPresentController(presentedViewController: presented, presenting: presenting)
            c.respondClickMaskBtn = { [unowned self] in
                self.vc.dismiss(animated: true, completion: nil)
            }
            return c
        }
        return nil
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self.vc {
            let w = UIScreen.main.bounds.size.width * filterVcWidthRatio
            return RootFilterAnimaitonController(isPresenting: true, onLeft: onLeft, width: w)
        }
        return nil
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self.vc {
            let w = UIScreen.main.bounds.size.width * filterVcWidthRatio
            return RootFilterAnimaitonController(isPresenting: false, onLeft: onLeft, width: w)
        }
        return nil
    }
    
}

class RootFilterAnimaitonController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    let duration: TimeInterval
    let onLeft: Bool
    let width: CGFloat
    
    required init(isPresenting: Bool, onLeft: Bool, width: CGFloat) {
        self.isPresenting = isPresenting
        self.duration = 0.5
        self.onLeft = onLeft
        self.width = width
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresent(transitionContext)
        } else {
            animateDismiss(transitionContext)
        }
    }
    func animatePresent(_ ctx: UIViewControllerContextTransitioning) {
        let presentedViewController = ctx.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let presentedView = ctx.view(forKey: UITransitionContextViewKey.to)!
        let containerView = ctx.containerView
        presentedView.frame = ctx.finalFrame(for: presentedViewController)
        containerView.addSubview(presentedView)
        let W = UIScreen.main.bounds.size.width
        let H = UIScreen.main.bounds.size.height - 20
        var beginFrame: CGRect
        var endFrame: CGRect
        if onLeft {
            beginFrame = CGRect(x: -self.width, y: 20, width: self.width, height: H)
            endFrame = CGRect(x: 0, y: 20, width: self.width, height: H)
        } else {
            beginFrame = CGRect(x: W + self.width, y: 20, width: W, height: H)
            endFrame = CGRect(x: W - self.width, y: 20, width: self.width, height: H)
        }
        presentedView.frame = beginFrame
        UIView.animate(withDuration: duration, animations: {
            presentedView.frame = endFrame
        }, completion: { (complete) in
            ctx.completeTransition(complete)
        }) 
    }
    func animateDismiss(_ ctx: UIViewControllerContextTransitioning) {
        let presentedView = ctx.view(forKey: UITransitionContextViewKey.from)!
        let W = UIScreen.main.bounds.size.width
        let H = UIScreen.main.bounds.size.height - 20
        var beginFrame: CGRect
        var endFrame: CGRect
        if onLeft {
            endFrame = CGRect(x: -self.width, y: 20, width: self.width, height: H)
            beginFrame = CGRect(x: 0, y: 20, width: self.width, height: H)
        } else {
            beginFrame = CGRect(x: W - self.width, y: 20, width: self.width, height: H)
            endFrame = CGRect(x: W + self.width, y: 20, width: W, height: H)
        }
        presentedView.frame = beginFrame
        UIView.animate(withDuration: duration, animations: {
            presentedView.frame = endFrame
        }, completion: { (complete) in
            ctx.completeTransition(complete)
        }) 
    }
}
class RootFilterPresentController: UIPresentationController {
    
    var respondClickMaskBtn: (() -> ())?
    
    lazy var maskBtn: UIButton = {
        let one = UIButton()
        one.backgroundColor = UIColor.black
        one.alpha = 0.5
        one.addTarget(self, action: #selector(RootFilterPresentController.maskBtnClick), for: .touchUpInside)
        return one
    }()
    func maskBtnClick() {
        respondClickMaskBtn?()
    }
    
    override func presentationTransitionWillBegin() {
        maskBtn.frame = UIScreen.main.bounds
        self.containerView!.addSubview(maskBtn)
        maskBtn.alpha = 0
        self.containerView!.addSubview(self.presentedView!)
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (ctx) in
            self?.maskBtn.alpha = 0.5
            }, completion: { (ctx) in
        })
    }
    override func presentationTransitionDidEnd(_ completed: Bool) { }
    override func dismissalTransitionWillBegin() {
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (ctx) in
            self?.maskBtn.alpha = 0
            }, completion: { (ctx) in
        })
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        maskBtn.removeFromSuperview()
    }
    override var frameOfPresentedViewInContainerView : CGRect {
        return UIScreen.main.bounds
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (ctx) in
        }) { (ctx) in
        }
    }
}


