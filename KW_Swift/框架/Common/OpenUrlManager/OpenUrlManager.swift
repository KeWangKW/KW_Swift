//
//  OpenUrlManager.swift
//  Whatever
//
//  Created by 渴望 on 2020/7/23.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation


struct OpenUrlManager {
    
    static func open(url: URL) {
        if BrowserOpen.canOpen(url: url) {
            BrowserOpen.open(url: url)
        }
    }
}


/// 浏览器跳转操作
struct BrowserOpen {
    static let scheme = "WhateverFromBrowser"
    static let shopInfo = "info?store_id="
    static let releasseInfo = "info?id="
    static func canOpen(url: URL) -> Bool {
        return url.absoluteString.hasPrefix(scheme.lowercased())
    }
    
    static func open(url: URL) {
        guard let suffix = url.absoluteString.components(separatedBy: "/").last else { return }
//        if suffix.hasPrefix(shopInfo) {
//            let storeId = suffix.kw.substring(from: shopInfo.count)
//            UIViewController.kw.currentController()?.navigationController?.pushViewController(dyBusinessDetailsVC(storeId: storeId), animated: true)
//        } else if suffix.hasPrefix(releasseInfo) {
//            let goodsId = suffix.kw.substring(from: releasseInfo.count)
//            UIViewController.kw.currentController()?.navigationController?.pushViewController(dyGoodsDetailsVC(goodsId: goodsId), animated: true)
//        }
    }
}
