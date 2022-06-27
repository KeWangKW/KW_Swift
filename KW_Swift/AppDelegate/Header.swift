//
//  Header.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/1.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import UIKit

import SnapKit
import FDFullscreenPopGesture
@_exported import Kingfisher
@_exported import Moya
//@_exported import RxSwift
//@_exported import RxCocoa



let CellPadding: CGFloat = 12

let AlipaySchemeXDSSJ = "AlipaySchemeXDSSJ"

public typealias VoidClosure = (() -> Void)

//typealias RString = R.string.localizable
//typealias RImage = R.image


let AppCacheDictionaryPathKey = "AppCacheDictionaryPath"

func AppCacheDictionaryPath()-> String? {
    let documents = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    
    let path = (documents as NSString).appendingPathComponent(AppCacheDictionaryPathKey)
    if !FileManager.default.fileExists(atPath: path) {
        guard (try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)) != nil else {
            print("缓存文件夹创建失败")
            return nil
        }
    }
    return path
}


/*
#if DEBUG
let AppIsInAudit = false
#else
//let AppIsInAudit = false

let OutOfPresetTime = "2020-09-10 06:00:00"
var AppIsInAudit: Bool {
    let date = Date.KW.date(fromString: OutOfPresetTime, format: "yyyy-MM-dd HH:mm:ss")!
    return date > Date()
}
#endif
*/
