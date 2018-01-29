//
//  NewsOrderViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsOrderViewController: RootViewController, UICollectionViewDataSource, UICollectionViewDelegate, LewReorderableLayoutDelegate, LewReorderableLayoutDataSource {
    
    var items: [NewsVcItem] = [NewsVcItem]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var respondUpdate: ((_ items: [NewsVcItem]) -> ())?
    
    lazy var topWhiteView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrWhite
        return one
    }()
    
    lazy var btnClose: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 14, height: 14)
        one.iconView.image = UIImage(named: "newsClose")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUpdate?(self.items)
            self.dismiss(animated: true) {
            }
            })
        return one
    }()
    
    lazy var breakLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBreak
        return one
    }()
    lazy var tipLabel: UILabel = {
        let one = UILabel()
        let attri1 = StringTool.makeAttributeString("切换栏目", dic: [
            NSForegroundColorAttributeName: kClrDeepGray,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])!
        let attri2 = StringTool.makeAttributeString("(拖动排序)", dic: [
            NSForegroundColorAttributeName: kClrDarkGray,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])!
        let mAttri = NSMutableAttributedString()
        mAttri.append(attri1)
        mAttri.append(attri2)
        one.attributedText = mAttri
        return one
    }()
    required init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.backgroundColor = RGBA(255, 255, 255, 244)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var flowLayout: LewReorderableLayout = {
        let one = LewReorderableLayout()
        var w: CGFloat = 0
        if kScreenW < 330 {
            w = (kScreenW - 12.5 * 2 - 10 * 2) / 3
        } else {
            w = (kScreenW - 12.5 * 2 - 10 * 3) / 4
        }
        one.itemSize = CGSize(width: w, height: 35)
        one.minimumInteritemSpacing = 10
        one.minimumLineSpacing = 10
        one.scrollDirection = .vertical
        one.sectionInset = UIEdgeInsetsMake(20, 12.5, 20, 12.5)
        one.delegate = self
        one.dataSource = self
        return one
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.backgroundColor = UIColor.clear
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = true
        one.bounces = false
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        //let lng = UILongPressGestureRecognizer(target: self, action: #selector(NewsOrderViewController.lng(_:)))
        //one.addGestureRecognizer(lng)
        //lng.minimumPressDuration = 0.1
        one.register(NewsOrderCell.self, forCellWithReuseIdentifier: "NewsOrderCell")
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topWhiteView)
        view.addSubview(tipLabel)
        view.addSubview(btnClose)
        view.addSubview(breakLine)
        view.addSubview(collectionView)
        topWhiteView.IN(view).LEFT.RIGHT.TOP.HEIGHT(64).MAKE()
        tipLabel.IN(view).LEFT(15).TOP(20).HEIGHT(44).RIGHT(80).MAKE()
        btnClose.IN(view).RIGHT.TOP(20).HEIGHT(44).WIDTH(50).MAKE()
        breakLine.IN(view).LEFT.RIGHT.TOP(64).HEIGHT(0.5).MAKE()
        collectionView.IN(view).LEFT.RIGHT.TOP(64).BOTTOM.MAKE()
        
    }
// 官方，需要9.0支持
//    func lng(recognizer: UILongPressGestureRecognizer) {
//        switch recognizer.state {
//        case .Began:
//            let point = recognizer.locationInView(recognizer.view!)
//            if let indexPath = collectionView.indexPathForItemAtPoint(point) {
//                if #available(iOS 9.0, *) {
//                    collectionView.beginInteractiveMovementForItemAtIndexPath(indexPath)
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        case .Changed:
//            let point = recognizer.locationInView(recognizer.view!)
//            if #available(iOS 9.0, *) {
//                collectionView.updateInteractiveMovementTargetPosition(point)
//            } else {
//                // Fallback on earlier versions
//            }
//        case .Ended:
//            if #available(iOS 9.0, *) {
//                collectionView.endInteractiveMovement()
//            } else {
//                // Fallback on earlier versions
//            }
//        default:
//            if #available(iOS 9.0, *) {
//                collectionView.cancelInteractiveMovement()
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }
    
    //MARK: UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsOrderCell", for: indexPath) as! NewsOrderCell
        cell.item = items[indexPath.item]
        return cell
    }
//    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return indexPath.item > 0
//    }
//    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        let item = items[sourceIndexPath.item]
//        items.removeAtIndex(sourceIndexPath.item)
//        items.insert(item, atIndex: destinationIndexPath.item)
//    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt fromIndexPath: IndexPath!, canMoveTo toIndexPath: IndexPath!) -> Bool {
        if fromIndexPath.item == 0 || toIndexPath.item == 0 {
            return false
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView!, itemAt fromIndexPath: IndexPath!, didMoveTo toIndexPath: IndexPath!) {
        let item = items[fromIndexPath.item]
        items.remove(at: fromIndexPath.item)
        items.insert(item, at: toIndexPath.item)
        NewsVcItem.saveToLocal(items: items)
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(_ presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        if presented == self {
            return NewsOrderPresentController(presentedViewController: presented, presenting: presenting)
        }
        return nil
    }
    override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            return NewsOrderAnimaitonController(isPresenting: true)
        }
        return nil
    }
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return NewsOrderAnimaitonController(isPresenting: false)
        }
        return nil
    }
}

class NewsOrderCell: UICollectionViewCell {
    var item: NewsVcItem! {
        didSet {
            label.text = item.title
        }
    }
    lazy var bgView: UIView = {
        let one = UIView()
        one.layer.cornerRadius = 2
        one.layer.borderColor = kClrLightGray.cgColor
        one.layer.borderWidth = 0.5
        return one
    }()
    lazy var label: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#666666")
        return one
    }()
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        contentView.addSubview(bgView)
        contentView.addSubview(label)
        bgView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        label.IN(contentView).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewsOrderAnimaitonController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    let duration: TimeInterval
    
    required init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        self.duration = 0.5
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
        presentedView.frame = UIScreen.main.bounds
        presentedView.alpha = 0
        UIView.animate(withDuration: duration, animations: { 
            presentedView.frame = UIScreen.main.bounds
            presentedView.alpha = 1
            }, completion: { (complete) in
                ctx.completeTransition(complete)
        }) 
    }
    func animateDismiss(_ ctx: UIViewControllerContextTransitioning) {
        let presentedView = ctx.view(forKey: UITransitionContextViewKey.from)!
        presentedView.frame = UIScreen.main.bounds
        UIView.animate(withDuration: duration, animations: {
            presentedView.frame = UIScreen.main.bounds
            presentedView.alpha = 0
            }, completion: { (complete) in
                ctx.completeTransition(complete)
        }) 
    }
    
}

class NewsOrderPresentController: UIPresentationController {
    override func presentationTransitionWillBegin() {
        self.containerView!.addSubview(self.presentedView!)
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
            }, completion: { (ctx) in
        })
    }
    override func presentationTransitionDidEnd(_ completed: Bool) { }
    override func dismissalTransitionWillBegin() {
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
            }, completion: { (ctx) in
        })
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) { }
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
