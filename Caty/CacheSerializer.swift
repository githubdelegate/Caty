//
// Created by zhangyun on 10/04/2017.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

public protocol  CacheSerializer {
    // Mark: 取
    func data(with image: Image,original: Data?) -> Data?

    // Mark: 存
    func image(with data: Data,options:CatyOptionsInfo?) -> Image?
}


public  struct  DefaultCacheSerializer: CacheSerializer{

    public  static  let `default` = DefaultCacheSerializer()

    public func data(with image: Image,original: Data?) -> Data?{
        
    }

}
