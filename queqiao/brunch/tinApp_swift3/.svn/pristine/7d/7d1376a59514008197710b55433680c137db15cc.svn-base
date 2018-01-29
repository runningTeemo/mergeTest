//
//  PresentingAnimator.swift
//  CustomTransitionDemo
//
//  Created by Joey on 2/10/15.
//  Copyright (c) 2015 Joey. All rights reserved.
//

import UIKit

class PresentingAnimator:NSObject, UIViewControllerAnimatedTransitioning
{
    var finalFrame  = CGRect.zero
    var originFrame = CGRect.zero
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.01
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        
        var fromView = fromViewController?.view
        var toView = toViewController?.view
        
        fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
//        if transitionContext.responds(to: #selector(UIViewControllerTransitionCoordinatorContext.view(forKey:)(_:))) {
//            fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
//            toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
//        } else {
//            // Fallback on earlier versions
//        }
        
        fromView?.frame = transitionContext.initialFrame(for: fromViewController!)
        toView?.frame = originFrame
        //transitionContext.finalFrameForViewController(toViewController!)
        
        containerView.addSubview(toView!)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            print(self.finalFrame.width)
            
            toView?.frame = self.finalFrame
            
        }, completion: {
            (finished: Bool) -> Void in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }) 
    }
}

class DismissAnimator:NSObject, UIViewControllerAnimatedTransitioning
{
    var finalFrame  = CGRect.zero
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.01
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var fromView = fromViewController?.view
        
//        if transitionContext.responds(to: #selector(UIViewControllerTransitionCoordinatorContext.view(forKey:)(_:))) {
//            fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
//        }
        fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)

        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            fromView?.frame = self.finalFrame
        }, completion: {
            (finished: Bool) -> Void in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }) 
    }
}





