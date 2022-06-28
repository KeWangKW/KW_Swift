//
//  NotificationConst.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/28.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation


enum KWNotification: String {
    case login, logout
    case homeBannerReload
    case secondClassifyGetId, secondClassifyGetFirstList
    case circleFollow, circleOperate, circleAudit
    case alipay, wechat
    case goodsOnlineRelease, goodsOfflineRelease
    case reloadBusinessInfo
    case webShowPrice
    
    var value: String {
        return "KW" + rawValue
    }
    
    var notificationName: Notification.Name {
        return Notification.Name(value)
    }
    
}


extension NotificationCenter {
    static func addObserver(kw observer: Any, selector: Selector, name: KWNotification, object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name.notificationName, object: object)
    }
    
    static func post(kw name: KWNotification, object: Any? = nil) {
        NotificationCenter.default.post(name: name.notificationName, object: object)
    }
    
    static func removeObserver(kw observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

