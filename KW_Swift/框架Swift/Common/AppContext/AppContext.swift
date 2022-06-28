//
//  AppContext.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/19.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import UIKit
//import ObjectMapper


extension ApiResponse {

    func isLogout() {
        guard tokenExpired else { return }
        AppContext.shared.logout()
        HUD.showInfo(text: ApiError.tokenExpired.localizedDescription)
        let VC = UIViewController.kw.currentController()
        GCD.delay(0.5) {
            AppContext.showLoginControllerWhenLogout()
            GCD.delay(0.5) {
                VC?.tabBarController?.selectedViewController = VC?.tabBarController?.viewControllers?.first
                VC?.navigationController?.popToRootViewController(animated: false)
            }
        }
    }


}

final class AppContext {
    static let shared = AppContext()
    
    private(set) var isLogin: Bool = false
    
    //var appuserModel = AppUser() //登录时的用户数据
    
    
    var appUser: AppUser {
        return unarchiveObject()
    }
    
    
    func checkLogin() {
        let token = UserDefaults.LoginInfo.value(forKey: .tokenXDS_B) as? String
        self.isLogin = token != nil
        reloadUserInfo()
    }
    
    func login(_ token: String, _ phone: String, _ pwd: String ) {
        isLogin = true
        
        UserDefaults.LoginInfo.set(value: token, forKey: .tokenXDS_B)
        UserDefaults.LoginInfo.set(value: phone, forKey: .phone)
        UserDefaults.LoginInfo.set(value: pwd, forKey: .password)
        reloadUserInfo()
        NotificationCenter.post(kw: .login, object: nil)
    }
    
    func logout() {
        isLogin = false
        UserDefaults.LoginInfo.remove(forKey: .tokenXDS_B)
        NotificationCenter.post(kw: .logout, object: nil)
        
        
    }
    
}


// MARK: - Login
extension AppContext {
    /// 未登录状态下显示登录窗口
    /// - Parameter completion: 登录成功回调
    /// - Returns: 是否已经登录 true or false
    @discardableResult
    static func showLoginControllerWhenLogout(_ completion: VoidClosure? = nil) -> Bool {
        guard !AppContext.shared.isLogin else {
            completion?()
            return true
        }
        let currentVC = UIViewController.kw.currentController()
        
        /*
        //let login = KWLogInPwdVC()
        let login = BSelectedTradeVC()
//        login.loginCompletion(completion)
        let navLogin = KWNavigationController(rootViewController: login)
//        currentVC?.present(navLogin, animated: true, completion: .none)
//        UIApplication.shared.windows.first?.rootViewController = navLogin
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.rootViewController = navLogin
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            UIApplication.shared.keyWindow?.rootViewController = navLogin
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        } */
        return false
    }
}

// MARK: - Reload User Info
extension AppContext {
    func reloadUserInfo(completion: (() -> Void)? = nil) {
//        guard self.isLogin else {
//            //completion?()
//            return
//        }
        //重走登录或者 本地存储
        
//        let json = self.appuserModel.toJSON()
        let json = ["user_id": UserDefaults.standard.string(forKey: "B_user_id"),
                    "accountId": UserDefaults.standard.string(forKey: "B_accountId"),
                    "token": UserDefaults.standard.string(forKey: "B_token"),
                    "nick_name": UserDefaults.standard.string(forKey: "B_nick_name"),
                    "head_img_url": UserDefaults.standard.string(forKey: "B_head_img_url"),
//                    "level": UserDefaults.standard.string(forKey: "B_level"),
//                    "level_title": UserDefaults.standard.string(forKey: "B_level_title"),
                    "userType": UserDefaults.standard.string(forKey: "B_userType"),
                    "isTrialAgent": UserDefaults.standard.string(forKey: "B_isTrialAgent"),
                    "spmUserId": UserDefaults.standard.string(forKey: "B_spmUserId"),
                    "spmUserLevel": UserDefaults.standard.string(forKey: "B_spmUserLevel"),
//                    "authority": UserDefaults.standard.string(forKey: "B_authority"),
                    "userIdentity": UserDefaults.standard.string(forKey: "B_userIdentity"),
                    "userIdentityTitle": UserDefaults.standard.string(forKey: "B_userIdentityTitle"),
                    "isGift": UserDefaults.standard.string(forKey: "B_isGift"),
                    "isSpm": UserDefaults.standard.string(forKey: "B_isSpm"),
                    "is_expired":UserDefaults.standard.string(forKey: "B_expired"),
                    "gmt_expired":UserDefaults.standard.string(forKey: "B_gmtExpired")
//                    "isNew": UserDefaults.standard.string(forKey: "B_isNew")
        ]
        self.archiveObject(json as NSDictionary)
        
        completion?()
//        LoginRegisterProvider.rx.request(.userssLogin).mapObject(BaseResponse<AppUser>.self).subscribe { (res) in
//            if res.code == 0 {
//
//                completion?()
//                let appUserModel = res.data
//                let appUserJSON = appUserModel?.toJSON()
//                //Cache 不能存储NSObject
//                self.archiveObject(appUserJSON! as NSDictionary)
//
//
////                if self.isFirstRegMiPush == true {
//                    //注册通知
//                    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
//                    appDelegate.regMiNotifications()
////                    self.isFirstRegMiPush = false
////                }
//
//
//            }else{  }
//        } onError: { (error) in  }//.disposed(by: DisposeBag())
    }
    
    
}




private let AppUserInfoCacheFileKey = "AppUserInfoFile.Cache"
// MARK: - Cache 数据存储删除
extension AppContext {
    
    func clearUserCache() {
        guard let path = userInfoCachePath() else {
            return
        }
        try? FileManager.default.removeItem(atPath: path)
    }
    
    private func archiveObject(_ user: NSDictionary) {
        guard let path = userInfoCachePath() else {
            return
        }
        NSKeyedArchiver.archiveRootObject(user, toFile: path)
    }
    
    private func unarchiveObject() -> AppUser {
        guard let path = userInfoCachePath() else {
            return AppUser()
        }
        guard let info = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? NSDictionary else {
            return AppUser()
        }
        return AppUser.toModel(info) ?? AppUser()
//        return AppUser(JSON: info as! [String : Any]) ?? AppUser()
    }
    
    
    
    private func userInfoCachePath() -> String? {
        guard let path = AppCacheDictionaryPath() else { return nil }
        let filePath = (path as NSString).appendingPathComponent(AppUserInfoCacheFileKey)
        return filePath
    }
}



final class AppUser: KWModel {
    var parent_mobile:String = "" //上级电话
    
}
