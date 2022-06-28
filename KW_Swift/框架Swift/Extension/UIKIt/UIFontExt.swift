//
//  UIFontExt.swift
//  KW_Swift
//
//  Created by bingxin on 2021/3/24.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation

extension UIFont {
    // 可以通过let names = UIFont.fontNames(forFamilyName: "PingFang SC") 来遍历所有PingFang 的字体名字 iOS9.0 以后支持
    /*
     PingFangSC-Medium
     PingFangSC-Semibold
     PingFangSC-Light
     PingFangSC-Ultralight
     PingFangSC-Regular
     PingFangSC-Thin
     */

    public static func regular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    public static func medium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    public static func bold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Semibold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
