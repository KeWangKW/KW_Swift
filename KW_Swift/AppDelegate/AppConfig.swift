//
//  AppConfig.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/1.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import ObjectMapper


final class AppConfig {
    static let shared = AppConfig()
    
    var window: UIWindow?
    
    
    private init() {
        AppContext.shared.checkLogin()
        
        
        self.configKeyboard()
    }
    
    //MARK: 新！启动逻辑
    /*
     新下载-启动页-引导页-登录-首页
     未登录-启动页-引导页-登录-首页
     已登录-启动页-广告页-首页
     */
    public func NewShowInitialController(in window: UIWindow?) {
        guard window != nil else { return }
        self.window = window
        
        self.window?.rootViewController = KWTabBarController()
        self.window?.makeKeyAndVisible()
        
    }
    
    
    
    public func config() {
        configKeyboard()
        
    }
    
    private func configKeyboard() {
        let shared = IQKeyboardManager.shared
        shared.enable = true
        shared.shouldResignOnTouchOutside = true
        shared.shouldShowToolbarPlaceholder = false
        shared.toolbarTintColor = .Title
        shared.previousNextDisplayMode = .alwaysHide
        
        ShareSDKManager.config()
    }
    
}
