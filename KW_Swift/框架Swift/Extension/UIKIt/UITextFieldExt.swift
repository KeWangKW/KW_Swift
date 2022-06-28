//
//  UITextFieldExt.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/27.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit


// MARK: - Methods
public extension KWSwiftWrapper where Base: UITextField {
    
    
    
    /// 添加输入框左测间距
    /// - Parameter padding: 宽度
    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: base.frame.width))
        base.leftView = paddingView
        base.leftViewMode = .always
    }
    
    /// 添加带图片的输入框左侧间距
    /// - Parameters:
    ///   - image: 图片
    ///   - padding: 宽度
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        base.leftView = imageView
        base.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        base.leftViewMode = .always
    }
    
    
    /// 金额输入格式限制
    /// textField(_: shouldChangeCharactersIn: replacementString:) 里面调用
    func isMoneyFomat(range: NSRange, string: String) -> Bool {
        let text = base.text ?? ""
        if text == "0." && string.count == 0 {
            base.text = ""
            return false
        }
        if (string == "." || string == "0"), text.count == 0 {
            base.text = "0."
            return false
        }
        if text.range(of: ".") != nil, string == "." {
            return false
        }
        let wholeString = (text as NSString).replacingCharacters(in: range, with: string)
        if text.range(of: ".") != nil, wholeString.components(separatedBy: ".").count > 1, wholeString.components(separatedBy: ".").last?.count ?? 0 > 2 {
            return false
        }
        return true
    }
    
    /// 输入字符长度限制
    /// （不是判断字符个数）
    func limit(length: Int, range: NSRange, string: String) -> Bool {
        guard let text = base.text else { return true }
        let inLength = text.count + string.count - range.length
        return inLength <= length
    }
}
