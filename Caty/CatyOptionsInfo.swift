//
// Created by zhangyun on 10/04/2017.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation


public typealias CatyOptionsInfo = [CatyOptionsInfoItem]
let CatyOptionEmptyOptionsInfo = [CatyOptionsInfoItem]()

public  enum CatyOptionsInfoItem{
    case targetCache(ImageCache)
}