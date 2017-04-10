//
// Created by zhangyun on 10/04/2017.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

/*this file is a lot of funcs for images process */
import Foundation



// Mark: --Image Foramt

private struct ImageHeaderData{
    static var PNG: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
    static var JPEG_SOI: [UInt8] = [0xFF,0xD8]
    static var JPEG_IF: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47,0x49,0x46]
}

enum ImageFormat{
    case unknow,PNG,JPEG,GIF
}


// Mark: - 杂乱的helper misc
public  struct DataProxy{
    fileprivate let base: Data
    init(proxy: Data){
        base = proxy
    }
}

extension Data: CatyCompatible{
    public typealias CompatibleType = DataProxy
    public var cy: DataProxy {
        return DataProxy(proxy: self)
    }
}

extension DataProxy{
    var imageFormat: ImageFormat{
        var buffer = [UInt8](repeating: 0,count: 8)
        (base as NSData).getBytes(&buffer, length: 8)
        if buffer == ImageHeaderData.PNG {
            return .PNG
        }else if buffer[0] == ImageHeaderData.JPEG_SOI[0] &&
        buffer[1] == ImageHeaderData.JPEG_SOI[1] &&
        buffer[2] == ImageHeaderData.JPEG_IF[0]{
            return .JPEG
        }else if buffer[0] == ImageHeaderData.GIF[0] &&
        buffer[1] == ImageHeaderData.GIF[1] &&
        buffer[2] == ImageHeaderData.GIF[2]{
            return .GIF
        }
        return .unknow
    }
}



