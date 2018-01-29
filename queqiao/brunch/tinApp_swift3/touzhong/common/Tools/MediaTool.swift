//
//  MediaTool.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/5/27.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit
import AVFoundation

class MediaTool: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let sharedOne = MediaTool()
    func showCamera(edit e: Bool = false, inVc: UIViewController) {
        showMedia(.camera, edit: e, inVc: inVc)
    }
    func showAlbum(edit e: Bool = false, inVc: UIViewController) {
        showMedia(.photoLibrary, edit: e, inVc: inVc)
    }
    
    var respondImage: ((_ image: UIImage) -> ())?
    var vc: UIViewController?
    
    // 当大于这个像素数的时候，进行压缩，nil不进行压缩
    var pixelLimt: CGFloat?
    
    func showMedia(_ type: UIImagePickerControllerSourceType, edit: Bool, inVc: UIViewController) {
        vc = inVc

        func showPicker() {
            let vc = UIImagePickerController()
            vc.delegate = self;
            vc.allowsEditing = edit;
            vc.sourceType = type;
            vc.modalPresentationStyle = .overCurrentContext
            inVc.present(vc, animated: true, completion: {
                
            })
        }
        
        if type == .camera {
            
            if !UIImagePickerController.isSourceTypeAvailable(type) {
                print("该设备不支持摄像头")
                Confirmer.show("提示", message: "该设备不支持摄像头", confirmHandler: nil, inVc: inVc)
                return
            }
            
            switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
            case .restricted:
                print("访问受限制")
                Confirmer.show("提示", message: "访问受限制", confirmHandler: nil, inVc: inVc)
            case .denied:
                Confirmer.show("提示", message: "请在设备的\"设置-隐私-相机\"中允许访问相机。", confirmHandler: nil, inVc: inVc)
                print("请在设备的\"设置-隐私-相机\"中允许访问相机。")
            case .authorized:
                showPicker()
            case .notDetermined:
                
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                    
                    if granted {
                        showPicker()
                    } else {
                        Confirmer.show("提示", message: "授权失败" + AVMediaTypeVideo, confirmHandler: nil, inVc: inVc)
                        print("授权失败" + AVMediaTypeVideo)
                    }
                    
                })
                
            }
            

        } else {
            
            if !UIImagePickerController.isSourceTypeAvailable(type) {
                print("请在设备的\"设置-图片库\"中允许访问图片库。")
                Confirmer.show("提示", message: "请在设备的\"设置-隐私-相机\"中允许访问相机。", confirmHandler: nil, inVc: inVc)

            } else {
                showPicker()
            }
            
        }
 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let fixImage = MediaTool.getFixOrientationImage(image)
            if let c = respondImage {
                if let p = pixelLimt {
                    var size = fixImage.size
                    let _p = size.height * size.width
                    let rate = sqrt(CGFloat(p) / CGFloat(_p))
                    if rate > 1 {
                        c(fixImage)
                    } else {
                        size = CGSize(width: size.width * rate, height: size.height * rate)
                        let scaleImage = MediaTool.scaleImage(fixImage, toSize: size)
                        c(scaleImage)
                    }
                } else {
                    c(fixImage)
                }
            }
            
        }
        
        vc?.dismiss(animated: true) { }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        vc?.dismiss(animated: true) { }
    }
    
    fileprivate class func getFixOrientationImage(_ image: UIImage) -> UIImage {
        
        if image.imageOrientation == .up { return image }
        
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: -CGFloat(M_PI_2))
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1);
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1);
        default:
            break
        }
        
        let ctx = CGContext(data: nil,
                                        width: Int(image.size.width), height: Int(image.size.height),
                                        bitsPerComponent: (image.cgImage?.bitsPerComponent)!,
                                        bytesPerRow: 0,
                                        space: (image.cgImage?.colorSpace!)!,
                                        bitmapInfo: (image.cgImage?.bitmapInfo.rawValue)!);
        ctx?.concatenate(transform);
        switch (image.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(image.cgImage!, in: CGRect(x: 0,y: 0,width: image.size.height,height: image.size.width));
            break;
            
        default:
            ctx?.draw(image.cgImage!, in: CGRect(x: 0,y: 0,width: image.size.width,height: image.size.height));
            break;
        }
        let cgImg = ctx?.makeImage()!
        let img = UIImage(cgImage: cgImg!)
        
        return img
    }
    
    class func scaleImage(_ image: UIImage, toSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(toSize)
        image.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage!;
    }

}
