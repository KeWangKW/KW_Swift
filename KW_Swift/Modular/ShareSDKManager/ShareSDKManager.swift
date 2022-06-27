//
//  ShareSDKManager.swift
//  Whatever
//
//  Created by 帝云科技 on 2020/7/15.
//  Copyright © 2020 帝云科技. All rights reserved.
//

import Foundation


let WechatAppId = "wx5e18a5d6da3cXXXX"
let WechatAppSecret = "52c889cb0c5c87e9745b545d682eXXXX"
let WechatUniversalLink = "https://XXXXXX.share2dlink.com/"

//let QQAppId = ""
//let QQAppKey = ""
//let QQUniversalLink = ""


struct ShareSDKManager {
    
    static func config() {
        ShareSDK.registPlatforms { (register) in
//            register?.setupQQ(withAppId: QQAppId,
//                              appkey: QQAppKey,
//                              enableUniversalLink: true,
//                              universalLink: QQUniversalLink)
            register?.setupWeChat(withAppId: WechatAppId,
                                  appSecret: WechatAppSecret,
                                  universalLink: WechatUniversalLink)
        }
        WXApi.registerApp(WechatAppId, universalLink: WechatUniversalLink)
    }
    
    static func shareUI(title: String, text: String, images:Any, url: String, completion:(() -> ())? = nil) {
        let parameters = NSMutableDictionary()
        parameters.ssdkSetupShareParams(byText: text, images: images, url: URL(string: url) ?? nil, title: title, type: .auto)
        
        let config = SSUIShareSheetConfiguration()
        config.itemAlignment = .center
        config.cancelButtonTitleColor = .Content
        config.itemTitleColor = .Title
        
        let items: [SSDKPlatformType.RawValue]  = [SSDKPlatformType.subTypeWechatSession.rawValue,
                                                   SSDKPlatformType.subTypeWechatTimeline.rawValue]
        //,SSDKPlatformType.subTypeQQFriend.rawValue
        ShareSDK.showShareActionSheet(nil, customItems: items, shareParams: parameters, sheetConfiguration: config) {
            (state, platformType, userData, contentEntity, error, end) in
            switch state {
            case .success:
                completion?()
            case .fail:
                break
            default:
                break
            }
        }
        
    }
    
    /*
    //自定义图标
    static func shareEditUI(title: String, text: String, images:Any, url: String, completion:(() -> ())? = nil) {
        let parameters = NSMutableDictionary()
        parameters.ssdkSetupShareParams(byText: text, images: images, url: URL(string: url) ?? nil, title: title, type: .auto)
        
        let config = SSUIShareSheetConfiguration()
        config.itemAlignment = .center
        config.cancelButtonTitleColor = .Content
        config.itemTitleColor = .Title
        
        let item = SSUIPlatformItem()
        item.iconNormal = UIImage(named: "tupian")
        item.platformName = "生成海报"
        item.addTarget(self, action: #selector(XDSYLFLMainTableViewCell.GetImgClick()))
        
//        let items: Array  = [
//            SSDKPlatformType.subTypeWechatSession,
//            SSDKPlatformType.subTypeWechatTimeline, item] as [Any]
//        let items: [SSDKPlatformType.RawValue]  = [
//            SSDKPlatformType.subTypeWechatSession.rawValue,
//            SSDKPlatformType.subTypeWechatTimeline.rawValue]
        //,SSDKPlatformType.subTypeQQFriend.rawValue
        ShareSDK.showShareActionSheet(nil, customItems: [item], shareParams: parameters, sheetConfiguration: config) {
            (state, platformType, userData, contentEntity, error, end) in
            switch state {
            case .success:
                completion?()
            case .fail:
                break
            default:
                break
            }
        }
        
    }
    */
    
    
    
}
