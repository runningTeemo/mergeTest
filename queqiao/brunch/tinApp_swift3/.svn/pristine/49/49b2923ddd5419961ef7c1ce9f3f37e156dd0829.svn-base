//
//  AlbumPhotoHelper.swift
//  CRM_demo
//
//  Created by Richard.q.x on 16/6/7.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

// 外部调用
func AlbumPhotoShowSingleSelect(_ inVc: UIViewController, responder: ((_ image: UIImage) -> ())?) {
    let vc = AlbumPhotoMainViewController()
    vc.operateType = .singleSelect
    vc.pixelLimt = 1000 * 1000
    vc.responder = { images in
        responder?(images.first!)
    }
    let nav = RootNavigationController(rootViewController: vc)
    inVc.present(nav, animated: true, completion: nil)
}

func AlbumPhotoShowEdit(_ inVc: UIViewController, responder: ((_ image: UIImage) -> ())?) {
    let vc = AlbumPhotoMainViewController()
    vc.operateType = .singleSelectAndEdit
    vc.pixelLimt = 1000 * 1000
    vc.responder = { images in
        responder?(images.first!)
    }
    let nav = RootNavigationController(rootViewController: vc)
    inVc.present(nav, animated: true, completion: nil)
}

func AlbumPhotoShowMutiSelect(_ inVc: UIViewController, maxCount: Int = 9, responder: ((_ images: [UIImage]) -> ())?) {
    let vc = AlbumPhotoMainViewController()
    vc.operateType = .mutiSelect
    vc.pixelLimt = 1000 * 1000
    vc.maxSelectCount = maxCount
    vc.responder = responder
    let nav = RootNavigationController(rootViewController: vc)
    inVc.present(nav, animated: true, completion: nil)
}

//class AlbumPhoto: NSObject {
//    fileprivate(set) var asset: PHAsset
//    var select: Bool = false
//    required init(asset: PHAsset) {
//        self.asset = asset
//    }
//}

class AlbumPhotoHelper: NSObject {
    
    class func checkAccess(denied d: (() -> ())?) -> Bool {
        return AlbumPhotoOCsolution.checkAccess {
            d?()
        }
//        switch PHPhotoLibrary.authorizationStatus() {
//        case .denied, .restricted:
//            d?()
//            return false
//        case .notDetermined:
//            return true
//        default:
//            return true
//        }
    }
    
//    fileprivate class func checkHasPhoto(_ album: PHFetchResult<NSObject>) -> Bool {
//        if let collection = album.firstObject {
//            if collection.isKind(of: PHAssetCollection.self) {
//                let assetCollection = collection as! PHAssetCollection
//                let result = PHAsset.fetchAssets(in: assetCollection, options: nil)
//                if result.count > 0 {
//                    return true
//                }
//            }
//        }
//        return false
//    }

    class func fetchAlbums(_ closure: ((_ albums: NSArray, _ success: Bool) -> ())?) {
        AlbumPhotoOCsolution.fetchAlbums { (arr, ret) in
            if let a = (arr as NSArray?) {
                closure?(a, ret);
            }
        }
        
//        let fetchResult = NSMutableArray()
//        let success = {
//            DispatchQueue.main.async(execute: {
//                closure?(fetchResult, true)
//            })
//        }
//        let failed = {
//            DispatchQueue.main.async(execute: {
//                closure?(fetchResult, false)
//            })
//        }
//        
//        if checkAccess(denied: {
//            failed()
//        }) {
//
//            PHPhotoLibrary.requestAuthorization({ (auth) in
//                
//                if auth == .authorized {
//                    
//                    // all photos
//                    let allPhoto = PHAsset.fetchAssets(with: nil)
//                    fetchResult.add(allPhoto)
//                    
//                    // each album
//                    let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
//                    if album.count > 0 && checkHasPhoto(album as! PHFetchResult<NSObject>) {
//                        fetchResult.add(album)
//                    }
//                    
//                    // smart favorite
//                    let favorite = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
//                    if (favorite.count > 0 && checkHasPhoto(favorite as! PHFetchResult<NSObject>)) {
//                        fetchResult.add(favorite)
//                    }
//                    success()
//                    
//                } else {
//                    if auth != .notDetermined {
//                        failed()
//                    }
//                }
//            })
//            
//        }
        
    }

    class func asycGetThumbImage(_ model: AlbumPhoto, size: CGSize, done: ((_ image: UIImage?) -> ())?) {
        let asset = model.asset!
        let scale = UIScreen.main.scale
        let width = size.width
        let size = CGSize(width: width * scale, height: width * scale)
        let opt = PHImageRequestOptions()
        opt.isSynchronous = false
        PHCachingImageManager.default().requestImage(for: asset , targetSize: size, contentMode: .aspectFill, options: opt, resultHandler: { (image, info) in
            done?(image)
        })
    }
    
    class func asycGetImage(_ model: AlbumPhoto, limit: CGFloat?, done: ((_ image: UIImage?) -> ())?) {
        let asset = model.asset!
        let opt = PHImageRequestOptions()
        opt.isSynchronous = false
        PHCachingImageManager.default().requestImage(for: asset , targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: opt, resultHandler: { (image, info) in
            done?(image)
        })
    }

    class func getSelectImages(_ photos: [AlbumPhoto], limit: CGFloat?, done: @escaping ((_ images: [UIImage]) -> ())) {

        let selectPhotos = NSMutableArray()
        for photo in photos {
            if photo.select {
                selectPhotos.add(photo)
            }
        }
        var images = [UIImage]()
        
        asycReduce(selectPhotos, action: { (item, done) in
            let opt = PHImageRequestOptions()
            opt.isSynchronous = false
            var isGet: Bool = false
            PHCachingImageManager.default().requestImage(for: (item as! AlbumPhoto).asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: opt, resultHandler: { (image, info) in
                if let image = image {
                    let img = checkOrScaleImage(image, limit: limit)
                    if !isGet {
                        images.append(img)
                        isGet = true
                    }
                }
                done()
            })
            }) {
              done(images)
        }
        
    }
    
    class func asycReduce(_ arr: NSMutableArray, action: @escaping ((_ item: Any, _ done: @escaping (() -> ())) -> ()), done: (() -> ())?) {
        if arr.count > 0 {
            if let obj = arr.firstObject {
                action(obj, {
                    arr.remove(obj)
                    self.asycReduce(arr, action: action, done: done)
                })
            }
        } else {
            done?()
        }
    }
    
//    class func asycReduce<T>(_ arr: inout [T], action: @escaping ((_ item: T, _ done: @escaping (() -> ())) -> ()), done: (() -> ())?) {
//        if arr.count > 0 {
//            if let item = arr.first as T? {
//                action(item, {
//                    arr.removeFirst()
//                    self.asycReduce(&arr, action: action, done: done)
//                })
//            }
//        } else {
//            done?()
//        }
//    }
    
    class func checkOrScaleImage(_ image: UIImage, limit: CGFloat?) -> UIImage {
        if let limit = limit {
            var size = image.size
            let _limit = size.height * size.width
            let rate = sqrt(CGFloat(limit) / CGFloat(_limit))
            if rate < 1 {
                size = CGSize(width: size.width * rate, height: size.height * rate)
                return scaleImage(image, toSize: size)
            }
        }
        return image
    }
    
    class func scaleImage(_ image: UIImage, toSize: CGSize) -> UIImage {
        let intSize = CGSize(width: Int(toSize.width), height: Int(toSize.height))
        UIGraphicsBeginImageContext(intSize)
        let rect = CGRect(x: 0, y: 0, width: intSize.width, height: intSize.height)
        image.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage!;
    }
}



