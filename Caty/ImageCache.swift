//
//  ImageCache.swift
//  Caty
//
//  Created by zhangyun on 20/03/2017.
//  Copyright © 2017 zhangyun. All rights reserved.
//

import UIKit

public extension NSNotification.Name{
    public static var CatyDIdCleanIDiskCache = NSNotification.Name.init("com.zy.Caty.CatyDidCleanDiskCache")
}

public enum CacheType{
    case none,memory,disk
}

class ImageCache {
    
    fileprivate let memoryCache = NSCache<NSString,AnyObject>(

    open var maxMemoryCost: UInt = 0 {
        didSet {
            self.memoryCache.totalCostLimit = Int(maxMemoryCost)
        }
    }
    
    fileprivate let ioQueue: DispatchQueue
    fileprivate let processQueue: DispatchQueue
    
    open let diskCachePath: String
    open var pathExtension: String?
    open var maxCachePeriodInSecond: TimeInterval = 60 * 60 * 24 * 7
    open var maxDiskCacheSize: UInt = 0
    
    
    public typealias DiskCachePathColsure = (String?,String) -> String
    
    // 返回缓存路径
    public final class func defaultDiskCachePathClosure(path: String?,cacheName: String) -> String{
        let dstPath = path ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return (dstPath as NSString).appending(cacheName)
    }
    
    public static let `default` = ImageCache(name: "default")
    
    fileprivate var fileManger: FileManager!
    
    public init(name: String,
                path: String? = nil,
                diskCachePathClosure: DiskCachePathColsure = ImageCache.defaultDiskCachePathClosure){
        if name.isEmpty{
            fatalError("no name")
        }
        
        let cacheName = "com.zy.Caty.ImageCache.\(name)"
        memoryCache.name = cacheName
        
        diskCachePath = diskCachePathClosure(path,cacheName)
        
        let ioQueueName = "com.zy.caty.ImageCache.ioQUeue.\(name)"
        ioQueue = DispatchQueue(label: ioQueueName)
        
        let processName = "com.zy.caty.ImageCache.processQueue.\(name)"
        processQueue = DispatchQueue(label: processName,attributes: .concurrent)
        
        ioQueue.sync {
            fileManger = FileManager()
        }
        
        #if !os(macOS) && !os(watchOS)
            NotificationCenter.default.addObserver(self, selector: #selector(clearMemoryCache), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(cleanExpiredDiskCache), name: .UIApplicationWillTerminate, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(backgroundCleanExpiredDiskCache), name: .UIApplicationDidEnterBackground, object: nil)
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // Mark: -- 存&删
    func store(_ image: UIImage,
               original: Data?=nil,
               processorIdentifier idenifier:String="",
               cacheSerializer serializer: ) {
        
    }


    // Mark: -- 取
    // Mark: -- clean & clear
    // Mark: -- check cache status
    // Mark: -- 存&删
    // Mark: -- Internal helper



    
    
    @objc public func  clearMemoryCache(){}
    
    @objc public func  cleanExpiredDiskCache(){}
    
    @objc public func  backgroundCleanExpiredDiskCache(){}
    

    

} // ImageCache
