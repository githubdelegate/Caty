//MARK: - ImageDownload

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public typealias ImageDownloadProgressBlock = ((_ receivedSize: Int64, _ totoalSize:Int64) -> ())
public typealias ImageDownloadCompletionBlock = ((_ image: UIImage?, _ error: NSError?, _ imageURL: URL?) -> ())

public typealias DownloadProgressBlock = ImageDownloadProgressBlock
public typealias DownloadCompletionBlock = ImageDownloadCompletionBlock

class ImageDownloader {
    
    // 回调对
    typealias CallbackPair = (progressBlock: ImageDownloadProgressBlock?,completionHandler: ImageDownloadCompletionBlock?)
    
    // 一个下载任务，包括block和下载数据，一个image 下载任务可以有很多progessBlock completionBlock
    class ImageFetchLoad {
        var contents = [CallbackPair]()
        var responseData = NSMutableData()
    }
    
    // 一个map 下载地址key 对应下载任务value
    var fetchLoads = [URL: ImageFetchLoad]()
    
    
    fileprivate let sessionHandler: ImageDownloadSessionHandler
    fileprivate var session: URLSession?
    open var sessionConfigure = URLSessionConfiguration.ephemeral{
        didSet {
           session  = URLSession(configuration: sessionConfigure, delegate: sessionHandler, delegateQueue: OperationQueue.main)
        }
    }
    
    //MARK: - init
    public static let `default` = ImageDownloader(name: "default")
    
    public init(name: String) {
        if name.isEmpty {
            fatalError("you should set name ")
        }
        
        sessionHandler = ImageDownloadSessionHandler()
        sessionHandler.imageDownloader = self
        session  = URLSession(configuration: sessionConfigure, delegate: sessionHandler, delegateQueue: .main)
    }
    
    //MARK: - download
    func downloadImage(with url: URL,progressBlock:ImageDownloadProgressBlock?,completionHandler: ImageDownloadCompletionBlock?) -> () {
        
        let loadObjectForURL = fetchLoads[url] ?? ImageFetchLoad()
        let callbackPair = (progressBlock: progressBlock, completionHandler: completionHandler)
        loadObjectForURL.contents.append(callbackPair)
        fetchLoads[url] = loadObjectForURL
        
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let dataTask = session?.dataTask(with: request)
        dataTask?.resume()
    }
}

// 为什么要创建一个类单独除了回调方法，而不用downloader 本身,是因为
class ImageDownloadSessionHandler: NSObject,URLSessionDataDelegate{
    
    var imageDownloader: ImageDownloader?
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
            let url = dataTask.originalRequest?.url
        {
            NSLog("status code = \(statusCode)--url--\(url)")
        }
        // begin download
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        // 把下载下来的数据添加到fetchLoad 里面
        
        if let url = dataTask.originalRequest?.url {
            
            let fetchload = imageDownloader?.fetchLoads[url]
            fetchload?.responseData.append(data)
            
            if let expectedLength = dataTask.response?.expectedContentLength {
                for callbackpaie in (fetchload?.contents)! {
                    DispatchQueue.main.async {
                        callbackpaie.progressBlock?(Int64((fetchload?.responseData.length)!),expectedLength)
                    }
                }
            }

            
        }
        
//        if let url = dataTask.originalRequest?.url, let fetchload = imageDownloader?.fetchLoads[url] {
//            fetchload.responseData.append(data)
//            
//            if let expectedLength = dataTask.response?.expectedContentLength {
//                for callbackpaie in fetchload.contents {
//                    DispatchQueue.main.async {
//                        callbackpaie.progressBlock?(Int64(fetchload.responseData.length),expectedLength)
//                    }
//                }
//            }
//        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = (task.originalRequest?.url) else {
            return
        }
        
        guard error == nil else {
            NSLog("error=\(error)")
            
            let fetchload = imageDownloader?.fetchLoads[url]
            for callbackpair in (fetchload?.contents)! {
                callbackpair.completionHandler?(nil,error as NSError?,url)
            }
            return
        }
        
        guard let fetchload = imageDownloader?.fetchLoads[url] else {
            return
        }
        
        let imageData = fetchload.responseData as Data
        let image = UIImage(data: imageData)
        for callbackpair in (fetchload.contents) {
            callbackpair.completionHandler?(image,nil,url)
        }
    }
}



