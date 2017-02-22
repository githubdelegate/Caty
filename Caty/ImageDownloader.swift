//
// Created by zhangyun on 22/02/2017.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import  UIKit


public  typealias  Image = UIImage
public  typealias DownloadProgressBlock = ((_ receivedSize: Int,_ totalSize: Int) -> ())
public  typealias  CompletionHandler = ((_ image: Image?,_ error:NSError?,_ imageURL: URL?) -> ())
public  typealias  ImageDownloaderProgressBlock = DownloadProgressBlock
public  typealias  ImageDownloaderCompletionHandler = ((_ image: Image?, _ error: NSError?,_ url: URL?,_ originalData: Data?) -> ())

public struct RetriveImageDownloadTask {
    let  internalTask: URLSessionDataTask

    public  private(set) weak  var ownerDownloader: ImageDownloader?

    public  func cancel() {

    }

    public  var url: URL?{
        return  internalTask.originalRequest?.url
    }

    public  var priority: Float{
        get {
            return internalTask.priority
        }

        set {
            internalTask.priority = newValue
        }
    }
}

open class ImageDownloader {

    typealias  CallbackPair = (progressBlock: ImageDownloaderProgressBlock?,completionBlock: ImageDownloaderCompletionHandler?)

    class ImageFetchLoad{
        var contents = [CallbackPair]()
        var responseData =  NSMutableData()
        var downloadTaskCount = 0
        var downloadTask: RetriveImageDownloadTask?
    }

    // MARK: Internal Property
    let  barrierQueue: DispatchQueue
    open weak var delegate: ImageDownloaderDelegate?

 
    public  static let `default` = ImageDownloader(name: "default")

    public  init(name: String){
        if  name.isEmpty{
            fatalError("I need a name")
        }
    }

    open func downloadImage (with url: URL,
                             progressBlock:ImageDownloaderProgressBlock? = nil,
                             completionHandler: ImageDownloaderCompletionHandler? = nil) {
                return downloadImage(with: url, retrieveImageTask: nil, progressBlock: progressBlock, completionHandler: completionHandler)
    }

}


extension ImageDownloader{
   func downloadImage(with url:URL,
                      retrieveImageTask: RetriveImageTask?,
                      progressBlock: ImageDownloaderProgressBlock?,
                      completionHandler: ImageDownloaderCompletionHandler?){
    }
}
// MARK: 代理
public protocol ImageDownloaderDelegate: class {
    func  isValidStatusCode(_ code: Int,for downloader: ImageDownloader) -> Bool
    func  imageDownloader(_ downloader: ImageDownloader,didDownload image: Image, for url: URL, with response: HTTPURLResponse?)
}



class ImageDownloaderSessionHandler: NSObject,URLSessionDataDelegate{
    var downloadHolder: ImageDownloader?

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        guard let downloader = downloadHolder else {
            completionHandler(.cancel)
            return
        }

        if let statusCode = (response as? HTTPURLResponse).statusCode,
           let url =  dataTask.originalRequest?.url,
           !(downloader.delegate ?? downloader).isValidStatusCode(statusCode,downloader){

        }
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard  let downloader = downloadHolder else {
            return
        }



    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

    }




}