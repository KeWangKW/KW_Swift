//
//  Alert.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/19.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import Foundation


/// 文本提醒框， 单个按钮无响应事件
/// - Parameters:
///   - title: 标题
///   - message: 内容
public func AlertText(_ title: String?, _ message: String? = nil) {
    AlertOnly(title, message, "确定", enterHandle: .none)
}

/// 文本提醒框，单个按钮带响应事件
/// - Parameters:
///   - title: 标题
///   - message: 内容
///   - enter: 响应文字
///   - enterHandle: 响应事件回调
public func AlertOnly(_ title: String?, _ message: String?, _ enter: String, enterHandle: (() -> Void)?) {
    AlertSingle(title, message, enter, nil, enterHandle)
}

/// 文本提醒框，双按钮，单个响应事件
/// - Parameters:
///   - title: 标题
///   - message: 内容
///   - enter: 响应事件文字
///   - cancel: 非响应事件文字
///   - enterHandle: 响应事件回调
public func AlertSingle(_ title: String?, _ message: String?, _ enter: String, _ cancel: String?, _ enterHandle: (() -> Void)?) {
    AlertDouble(title, message, enter, cancel, enterHandle, .none)
}

/// 文本提醒框，双按钮响应事件
/// - Parameters:
///   - title: 标题
///   - message: 内容
///   - enter: 响应事件文字1
///   - cancel: 响应事件文字2
///   - enterHandle: 响应事件回调1
///   - cancelHandle: 响应事件回调2
public func AlertDouble(_ title: String?, _ message: String?, _ enter: String, _ cancel: String?, _ enterHandle: (() -> Void)?, _ cancelHandle: (() -> Void)?) {
    let alert = AlertController(title: title, message: message, cancel: cancel, enter: enter, completion: enterHandle, cancelAction: cancelHandle)
    let controller = UIViewController.kw.currentController()
    controller?.present(alert, animated: true, completion: .none)
}



/// 自定义初始化UIAlertController
/// - Parameters:
///   - title: 标题
///   - message: 内容
///   - cancel: 取消按钮文字
///   - enter: 确认按钮文字
///   - completion: 确认回调
///   - cancelAction: 取消回调
/// - Returns: UIAlertController
@discardableResult
public func AlertController(title: String?, message: String?, cancel: String?, enter: String, completion: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) -> UIAlertController {
    return AlertController(title: title, message: message, cancel: cancel, buttonTitles: [enter], completion: { (_) in
        completion?()
    }, cancelAction: cancelAction)!
}


/// 自定义初始化UIAlertController <多按钮>
/// - Parameters:
///   - title: 标题
///   - message: 内容
///   - cancel: 取消按钮文字
///   - buttonTitles: 其他按钮文字组
///   - completion: 按钮事件回调
///   - cancelAction: 取消回调
/// - Returns: UIAlertController
@discardableResult
public func AlertController(title: String?, message: String?, cancel: String?, buttonTitles: [String]?, completion: ((Int) -> Void)? = nil, cancelAction: (() -> Void)? = nil) -> UIAlertController? {
    guard let buttons = buttonTitles, buttons.count > 0 else { return nil}
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for idx in 0..<buttons.count {
        let action = UIAlertAction(title: buttons[idx], style: .default) { (_) in
            completion?(idx)
        }
        action.setValue(AlertEnterTitleColor, forKey: "_titleTextColor")
        alert.addAction(action)
    }
    if let cancelTitle = cancel {
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            cancelAction?()
        }
        cancelAction.setValue(AlertCancelTitleColor, forKey: "_titleTextColor")
        alert.addAction(cancelAction)
    }
    return alert
}

/// 自定义初始化UIAlertController <多按钮>
/// - Parameters:
///   - title: 标题
///   - message: 内容
///   - cancel: 取消按钮文字
///   - buttonTitles: 其他按钮文字组
///   - completion: 按钮事件回调
///   - cancelAction: 取消回调
/// - Returns: UIAlertController
@discardableResult
public func AlertControllerSheet(title: String?, message: String?, cancel: String?, buttonTitles: [String]?, completion: ((Int) -> Void)? = nil, cancelAction: (() -> Void)? = nil) -> UIAlertController? {
    guard let buttons = buttonTitles, buttons.count > 0 else { return nil}
    let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for idx in 0..<buttons.count {
        let action = UIAlertAction(title: buttons[idx], style: .default) { (_) in
            completion?(idx)
        }
        action.setValue(AlertEnterTitleColor, forKey: "_titleTextColor")
        alert.addAction(action)
    }
    if let cancelTitle = cancel {
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            cancelAction?()
        }
        cancelAction.setValue(AlertCancelTitleColor, forKey: "_titleTextColor")
        alert.addAction(cancelAction)
    }
    return alert
}


private let AlertCancelTitleColor = UIColor.Content
private let AlertEnterTitleColor = UIColor.Base
