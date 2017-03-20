//
//  ImageView+Caty.swift
//  Caty
//
//  Created by zhangyun on 28/02/2017.
//  Copyright © 2017 zhangyun. All rights reserved.
//

import Foundation
import UIKit

extension Caty where Base: UIImageView {
    
    // download image and set image
    public func setImage(with resource: URL?,
                         placeholder: UIImage? = nil,
                         progressBlock:DownloadProgressBlock? = nil,
                         completionHandler: DownloadCompletionBlock? = nil){
        
        guard resource != nil else {
            completionHandler?(nil,nil,nil)
            return;
        }
        
        ImageDownloader.default.downloadImage(with: resource!, progressBlock: progressBlock, completionHandler:{[weak base] image,error, url in
            
            guard base != nil else{
                return;
            }
            
            guard image != nil else{
                completionHandler!(nil,error,url)
                return;
            }
            
            base?.image = image
            completionHandler!(image,error,url)
        });
    }
}

extension UIImageView {
    
    
}
