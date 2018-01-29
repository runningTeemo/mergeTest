//
//  AlbumPhotoEditViewController.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/7.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

private let W = UIScreen.main.bounds.size.width
private let H = UIScreen.main.bounds.size.height - 64
private let rectSize: CGSize = CGSize(width: W - 10, height: W - 10)
private let A: CGPoint = CGPoint(x: (W - rectSize.width) / 2, y: (H - rectSize.height) / 2)
private let B: CGPoint = CGPoint(x: A.x + rectSize.width, y: A.y)
private let C: CGPoint = CGPoint(x: A.x, y: B.y + rectSize.height)
private let D: CGPoint = CGPoint(x: B.x, y: C.y)

class AlbumPhotoEditViewController: RootViewController, UIGestureRecognizerDelegate {
    
    //MARK: business
    
    var image: UIImage?
    var model: AlbumPhoto!
    var responder: ((_ images: [UIImage]) -> ())?
    var pixelLimt: CGFloat?
    
    func cancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    func confirmBtnClick() {
        if let image = image {
            var img = cutImage(image)
            img = AlbumPhotoHelper.checkOrScaleImage(img, limit: pixelLimt)
            responder?([img])
        }
        cancelBtnClick()
    }
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        view.isUserInteractionEnabled = false
        bottomView.confirmBtn.isEnabled = false
        bottomView.confirmBtn.alpha = 0.5
        AlbumPhotoHelper.asycGetImage(model, limit: pixelLimt, done: { [weak self] (image) in
            self?.view.isUserInteractionEnabled = true
            self?.image = image
            self?.resetImageView()
            if let _ = image {
                self?.bottomView.confirmBtn.isEnabled = true
                self?.bottomView.confirmBtn.alpha = 1.0
            }
            })
    }
    
    //MARK: setup views
    fileprivate lazy var bottomView: AlbumPhotoEditBottomView = {
        let one = AlbumPhotoEditBottomView()
        one.confirmBtn.addTarget(self, action: #selector(AlbumPhotoEditViewController.confirmBtnClick), for: .touchUpInside)
        one.confirmBtn.isEnabled = true
        one.confirmBtn.alpha = 1.0
        return one
    }()
    fileprivate lazy var imageView: UIImageView = {
        let one = UIImageView()
        one.isUserInteractionEnabled = true
        return one
    }()
    fileprivate lazy var coverView: AlbumPhotoEditCoverView = {
        let one = AlbumPhotoEditCoverView()
        one.A = A
        one.B = B
        one.C = C
        one.D = D
        return one
    }()
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
        title = "编辑图片"
        view.backgroundColor = UIColor.black
        view.addSubview(imageView)
        view.addSubview(coverView)
        view.addSubview(bottomView)
        coverView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        bottomView.IN(view).LEFT.RIGHT.BOTTOM.HEIGHT(44).MAKE()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelBtn)
        setupGestures()
        setupNavBackBlackButton(nil)
    }

    
    //MARK: gestures
    fileprivate func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AlbumPhotoEditViewController.tap(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(AlbumPhotoEditViewController.pan(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(AlbumPhotoEditViewController.pinch(_:)))
        pinch.delegate = self
        imageView.addGestureRecognizer(tap)
        imageView.addGestureRecognizer(pan)
        imageView.addGestureRecognizer(pinch)
    }
    func tap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            // for ext use
        }
    }
    func pan(_ recognizer: UIPanGestureRecognizer) {
        let trans = recognizer.translation(in: recognizer.view)
        imageView.transform = imageView.transform.translatedBy(x: trans.x, y: trans.y)
        recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
        if recognizer.state == .ended {
            bottomView.confirmBtn.isEnabled = false
            bottomView.confirmBtn.alpha = 0.5
            UIView.animate(withDuration: 0.5, animations: {
                self.adaptImageView()
                }, completion: { ( _ ) in
                    self.bottomView.confirmBtn.isEnabled = true
                    self.bottomView.confirmBtn.alpha = 1.0
            })
        }
    }
    func pinch(_ recognizer: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
        if recognizer.state == .ended {
            bottomView.confirmBtn.isEnabled = false
            bottomView.confirmBtn.alpha = 0.5
            UIView.animate(withDuration: 0.5, animations: { 
                self.adaptImageView()
                }, completion: { ( _ ) in
                    self.bottomView.confirmBtn.isEnabled = true
                    self.bottomView.confirmBtn.alpha = 1.0
            })
        }
    }
    fileprivate func resetImageView() {
        if let image = image {
            if image.size.width == 0 || image.size.height == 0 { return }
            imageView.image = image
            if rectSize.width / rectSize.height > image.size.width / image.size.height {
                let w = rectSize.width
                let h = w * image.size.height / image.size.width
                let x = A.x
                let y = A.y - (h - rectSize.height) / 2
                imageView.frame = CGRect(x: x, y: y, width: w, height: h)
            } else {
                let h = rectSize.height
                let w = h * image.size.width / image.size.height
                let y = A.y
                let x = A.x - (w - rectSize.width) / 2
                imageView.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        }
    }
    fileprivate func adaptImageView() {
        
        let imageSize = imageView.frame.size
        let imageOrigen = imageView.frame.origin

        if imageSize.width < rectSize.width || imageSize.height < rectSize.height {
            self.resetImageView()
            
        } else {
            if imageOrigen.x > A.x {
                let y = self.imageView.frame.origin.y
                self.imageView.frame = CGRect(x: A.x, y: y, width: imageSize.width, height: imageSize.height)
            }
            if imageView.frame.maxX < B.x {
                let y = self.imageView.frame.origin.y
                self.imageView.frame = CGRect(x: B.x - imageSize.width, y: y, width: imageSize.width, height: imageSize.height)
            }
            if imageOrigen.y > A.y {
                let x = self.imageView.frame.origin.x
                self.imageView.frame = CGRect(x: x, y: A.y, width: imageSize.width, height: imageSize.height)
            }
            if imageView.frame.maxY < D.y {
                let x = self.imageView.frame.origin.x
                self.imageView.frame = CGRect(x: x, y: D.y - imageSize.height, width: imageSize.width, height: imageSize.height)
            }
        }

    }
    
    //MARK: edit
    fileprivate func cutImage(_ image: UIImage) -> UIImage {
        // get rect
        let scaleRect = CGRect(x: A.x - imageView.frame.origin.x, y: A.y - imageView.frame.origin.y, width: rectSize.width, height: rectSize.height)
        let scale = imageView.frame.size.width / image.size.width;
        let rect = CGRect(x: scaleRect.origin.x / scale, y: scaleRect.origin.y / scale, width: scaleRect.size.width / scale, height: scaleRect.size.height / scale)
        // new image
        let source = image.cgImage
        let imgRef = source?.cropping(to: rect)!
        return UIImage(cgImage: imgRef!)
    }
    
}

class AlbumPhotoEditCoverView: UIView {
    
    var A: CGPoint = CGPoint(x: 0, y: 0)
    var B: CGPoint = CGPoint(x: 0, y: 0)
    var C: CGPoint = CGPoint(x: 0, y: 0)
    var D: CGPoint = CGPoint(x: 0, y: 0)

    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let throughRect = CGRect(x: A.x, y: A.y, width: B.x - A.x, height: D.y - B.y);
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).setFill()
        UIRectFill(rect)
        
        UIRectFillUsingBlendMode(throughRect, .clear);
        
        UIColor.white.setStroke()
        
        ctx?.setLineWidth(1)
        ctx?.move(to: CGPoint(x: A.x, y: A.y))
        ctx?.addLine(to: CGPoint(x: B.x, y: B.y))
        ctx?.addLine(to: CGPoint(x: D.x, y: D.y))
        ctx?.addLine(to: CGPoint(x: C.x, y: C.y))
        ctx?.closePath()
        ctx?.strokePath()
    }
    
}
