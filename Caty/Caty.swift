//
// Created by zhangyun on 22/02/2017.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit



public class  RetriveImageTask {
    public  static  let empty = RetriveImageTask()
    var cancelledBeforeDownloadStarting: Bool = false
//    public var downloadTask: RetriveImageDownloadTask?

}



// 基本类
public final class Caty<Base>{
    public let base: Base
    public init(_ base: Base){
        self.base = base
    }
}

//
public protocol CatyCompatible{
    associatedtype CompatibleType
    var cy: CompatibleType {get}
}

extension UIImageView: CatyCompatible{
}

extension UIImage: CatyCompatible{
}

//  扩展协议 实现 cy,返回Caty
public extension CatyCompatible{
    public var cy: Caty<Self>{
        get { return Caty(self)}
    }
}
