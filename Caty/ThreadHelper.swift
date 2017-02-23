//
// Created by zhangyun on 23/02/2017.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

extension  DispatchQueue {
    func  safeAsync(_ block: @escaping ()->()){
            if self == DispatchQueue.main && Thread.isMainThread {
                block()
            }else{
                async{ block() }
            }
    }
}
