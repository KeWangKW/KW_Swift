//
//  IPickerViewMacro.swift
//  IPickerView
//
//  Created by Leblanc on 2021/2/26.
//

import Foundation
import UIKit

struct IPickerViewMacro {
    
    // MARK: ------------- 获取keyWindow -------------
    static func keyWindow() -> UIWindow {
        var window = UIWindow()
        if #available(iOS 13.0, *) {
            for item in UIApplication.shared.connectedScenes {
                if item.activationState == .foregroundActive && (item .isKind(of: UIWindowScene.self)) {
                    let tempWindow: UIWindowScene = item as! UIWindowScene
                    for itm in tempWindow.windows {
                        if itm.isKeyWindow == true {
                            window = itm
                            break
                        }
                    }
                }
            }
        } else {
            window = UIApplication.shared.keyWindow!
        }
        return window
    }
    
    // MARK: --------------- UI适配 ---------------
    /// 判断设备是否有刘海儿
    static var isX : Bool {
        var isX = false
        if #available(iOS 11.0, *) {
            let bottom : CGFloat = keyWindow().safeAreaInsets.bottom
            isX = bottom > 0.0
        }
        return isX
    }
    /// TableBar距底部区域高度
    static var safeBottomHeight : CGFloat {
        var bottomH : CGFloat = 0.0
        if isX {
            bottomH = 34.0
        }
        return bottomH
    }
    
    
    // MARK: ------------- 打印 -------------
    static func log(_ items: Any...,
                    separator: String = " ",
                    terminator: String = "\n",
                    file: String = #file,
                    line: Int = #line,
                    method: String = #function)
    {
        #if DEBUG
        //如果不怕打印结果有大括号[4, "abc", [1, 2, 3]]，可以直接一句话
//        print("\((file as NSString).lastPathComponent)[\(line)], \(method):", items)
        print("\((file as NSString).lastPathComponent)[\(line)], \(method)", terminator: separator)
        var i = 0
        let j = items.count
        for a in items {
            i += 1
            print(" ",a, terminator:i == j ? terminator: separator)
        }
        #endif
    }

}
