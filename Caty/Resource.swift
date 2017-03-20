//
//  Resource.swift
//  Caty
//
//  Created by zhangyun on 28/02/2017.
//  Copyright © 2017 zhangyun. All rights reserved.
//

import Foundation


public protocol Resource{
    var downloadURL: URL {get}
}

public struct ImageResource: Resource{
    public let downloadURL: URL
    public init(downloadURL: URL){
        self.downloadURL = downloadURL
    }
}


extension URL: Resource {
    public var downloadURL: URL { return self }
}

