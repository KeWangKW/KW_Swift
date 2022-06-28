//
//  DYPayment.swift
//  Whatever
//
//  Created by 帝云科技 on 2020/7/14.
//  Copyright © 2020 帝云科技. All rights reserved.
//

import Foundation

private let AlipayResultKey = "resultStatus"
private let AlipaySuccess = "9000"

class DYPayment: NSObject {
    static let shared = DYPayment()
    
    func application(open url: URL) {
        guard let host = url.host else { return }
        if host == "safepay" {
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (result) in
                self.alipay(callBack: result as NSDictionary?)
            })
        } else if host == "pay" {
            WXApi.handleOpen(url, delegate: self)
        }
    }
    
    func application(open universalLink: NSUserActivity) -> Bool {
        return WXApi.handleOpenUniversalLink(universalLink, delegate: self)
    }
}


extension DYPayment: WXApiDelegate {
    
    func wechat(_ info: NSDictionary) {
        guard WXApi.isWXAppInstalled() else {
            AlertText("当前手机未安装微信")
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            AlertText("当前手机微信版本不支持微信支付")
            return
        }
        let req = PayReq()
//        let timestampStr:String = (info["timestamp"] ?? "") as! String
//        req.timeStamp = UInt32(Int(timestampStr) ?? 0)
        
        req.package = (info["package"] ?? "") as! String
        req.prepayId = (info["prepayid"] ?? "") as! String
        req.sign = (info["sign"] ?? "") as! String
//        req.timeStamp = UInt32((info["timestamp"] ?? 0) as! Int ) ?? 0
        if let timestampStr = info["timestamp"] as? String {
            req.timeStamp = UInt32(timestampStr) ?? 0
        }
        if let timestampInt = info["timestamp"] as? Int {
            req.timeStamp = UInt32(timestampInt)
        }
//        req.timeStamp = UInt32((info["timestamp"] ?? 0) as?)
        req.nonceStr = (info["noncestr"] ?? "") as! String
        req.partnerId = (info["partnerid"] ?? "") as! String
        /*
        req.package = (info["package"] ?? "") as! String
//        req.prepayId = (info["prepay_id"] ?? "") as! String
        req.sign = (info["paySign"] ?? "") as! String
        req.timeStamp = UInt32((info["timeStamp"] ?? 0) as! String ) ?? 0
        req.nonceStr = (info["nonceStr"] ?? "") as! String
        */
        WXApi.send(req)
    }
    
    func onResp(_ resp: BaseResp) {
        guard let resp = resp as? PayResp else { return }
        var res: Bool
        switch WXErrCode(rawValue: resp.errCode) {
        case WXSuccess:
            res = true
        default:
            res = false
        }
        NotificationCenter.post(kw: .wechat, object: res)
    }
}


extension DYPayment {
    
    func alipay(_ order: String) {
        AlipaySDK.defaultService()?.payOrder(order, fromScheme: AlipaySchemeXDSSJ, callback: { result in
            self.alipay(callBack: result as NSDictionary?)
        })
    }
    
    private func alipay(callBack result: NSDictionary?) {
        guard let status = result?[AlipayResultKey]  as? String else { return }
        NotificationCenter.post(kw: .alipay, object: status == AlipaySuccess)
    }
    
    
    //APP跳转微信小程序
    func jumpToWXXCC() {
        let req = WXLaunchMiniProgramReq.object()
        req.userName = "" //待拉起的小程序原始Id
        req.path = "pages/index/index?query='test'" //拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
        req.miniProgramType = .preview
        WXApi.send(req) { (result) in
            
        }
    }
    
}
