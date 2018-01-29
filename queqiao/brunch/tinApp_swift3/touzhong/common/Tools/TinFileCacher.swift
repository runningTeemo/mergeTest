//
//  TinFileCacher.swift
//  QXDicArrCacher
//
//  Created by Richard.q.x on 2016/12/26.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import Foundation

class TinFileCacher {
    
    static let sharedOne: TinFileCacher = TinFileCacher()
    
    /// 缓存路径配置
    private static let kTinCachePath: String = PathTool.cache + "/modelCache/"
    
    private let fileMgr = FileManager.default
    
    /// 清除缓存文件
    func cleanCacheInBackgroud(done: (() -> ())? = nil) {
        let path = getPath()
        DispatchQueue.global().async {
            self.deleteFiles(path)
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk(onCompletion: { 
                DispatchQueue.main.async {
                    done?()
                }
            })
        }
    }
    
    /// 获取缓存大小(单位字节)
    func getCacheSizeInBackground(done: ((_ size: UInt64) -> ())?) {
        DispatchQueue.global().async {
            let path = self.getPath()
            var size = self.fileSize(path)
            size += UInt64(SDImageCache.shared().getSize())
            DispatchQueue.main.async {
                done?(size)
            }
        }
    }
    
   
    /// 缓存 dic
    func cacheDic(dic: NSDictionary, url: String?, identifies: String?...) {
        if let path = getCachePath(url: url, identifies: identifies) {
            archive(dic, toPath: path)
        }
    }
    /// 取 dic
    func getDic(url: String?, identifies: String?...) -> NSDictionary? {
        if let path = getCachePath(url: url, identifies: identifies) {
            if let dic = unArchive(path) as? NSDictionary {
                return dic
            }
        }
        return nil
    }
    
    /// 缓存 arr
    func cacheArr(arr: NSArray, url: String?, identifies: String?...) {
        if let path = getCachePath(url: url, identifies: identifies) {
            archive(arr, toPath: path)
        }
    }
    /// 取 arr
    func getArr(url: String?, identifies: String?...) -> NSArray? {
        if let path = getCachePath(url: url, identifies: identifies) {
            if let arr = unArchive(path) as? NSArray {
                return arr
            }
        }
        return nil
    }

    
    
    //MARK: - private
    
    /// 转换存取key
    private func getCachePath(url: String?, identifies: [String?]) -> String? {
        var theKey = ""
        if let url = url {
            theKey += url
        }
        for identify in identifies {
            if let identify = identify {
                theKey += identify
            }
        }
        if theKey.characters.count <= 0 {
            return nil
        }
        
        let data = theKey.data(using: .utf8)
        if let base64Key = data?.base64EncodedString() {
            return getPath() + base64Key
        } else {
            return nil
        }
    }
    
    /// 获取缓存路径
    private func getPath() -> String {
        let path = TinFileCacher.kTinCachePath
        if !fileMgr.fileExists(atPath: path) {
            do {
                try fileMgr.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        return path
    }
    
    /// 获取文件属性
    private func fileAttri(_ path: String?) -> [FileAttributeKey : Any]? {
        if let path = path {
            if fileMgr.fileExists(atPath: path) {
                do {
                    return try fileMgr.attributesOfItem(atPath: path)
                } catch {
                    print(error)
                }
            }
        }
        return nil
    }

    /// 获取文件夹下文件的总大小（不包含子文件夹）
    private func fileSize(_ path: String?) -> UInt64 {
        var size: UInt64 = 0
        if let path = path {
            if let subPaths = fileMgr.subpaths(atPath: path) {
                for subPath in subPaths {
                    let subFullPath = path + subPath
                    if fileMgr.fileExists(atPath: subFullPath) {
                        if let attri = fileAttri(subFullPath) {
                            if let _size = attri[FileAttributeKey(rawValue: "NSFileSize")] as? UInt64 {
                                 size += _size
                            }
                        }
                    }
                }
            }
        }
        return size
    }
    
    /// 清除文件
    private func deleteFiles(_ path: String?) {
        if let path = path {
            if let subPaths = fileMgr.subpaths(atPath: path) {
                for subPath in subPaths {
                    let subFullPath = path + subPath
                    if fileMgr.fileExists(atPath: subFullPath) {
                        do {
                            try fileMgr.removeItem(atPath: subFullPath)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    
    /// 缓存
    private func archive(_ arrOrDic: Any, toPath: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: arrOrDic) as NSData
        data.write(toFile: toPath, atomically: true)
    }
    
    /// 取出
    private func unArchive(_ path: String) -> Any? {
        if let data = NSData(contentsOfFile: path) {
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data)
        }
        return nil
    }
    
    
}
