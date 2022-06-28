//
//  AppConst.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/20.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import UIKit


public let KScreenSize: CGSize = UIScreen.main.bounds.size

public let KScreenWidth: CGFloat = KScreenSize.width

public let KScreenHeight: CGFloat = KScreenSize.height

public let KNavigationBarHeight: CGFloat = 44

//public let StatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//public let KStatusBarHeight: CGFloat = isIPhoneX ? 44 : 20
public var KStatusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

public let KNavigationStatusHeight: CGFloat = (KNavigationBarHeight + KStatusBarHeight)

public let KHomeIndicatorHeight: CGFloat = isIPhoneX ? 34 : 0

public let KTabBarHeight: CGFloat = (49 + KHomeIndicatorHeight)



public var isIPhoneX: Bool {
//    guard UIDevice.current.userInterfaceIdiom == .phone else { return false }
//    guard #available(iOS 11.0, *) else { return false }
//    guard let window = UIApplication.shared.delegate?.window else { return false }
//    return window!.safeAreaInsets.bottom > 0
    
    guard UIDevice.current.userInterfaceIdiom == .phone else { return false }
    if #available(iOS 11.0, *) {
        let isX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
        return isX
    } else {
        // Fallback on earlier versions
        return false
    }
    
}

public var isIPhone5SE: Bool {
    guard UIDevice.current.userInterfaceIdiom == .phone else { return false }
    return (KScreenWidth == 320 && KScreenHeight == 568)
}

public var isIOS13: Bool {
    if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0)) {
         //如果大于13.0.0版本需要做的事
        return true
    }
    return false
}


public struct App {
    
    public static let infoDictionary = Bundle.main.infoDictionary
    
    public static let bundleId: String = Bundle.main.bundleIdentifier!
    
    public static let name: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    
    public static let version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    public static let bulidVersion: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
}

public struct Device {
    
    public static let name: String = UIDevice.current.systemName
    
    public static let version: String = UIDevice.current.systemVersion
}


