//
//  File.swift
//  KW_Swift
//
//  Created by Yinjoy on 2021/4/19.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation

///  格式： 已有   100   家新店商
public func stringToAttributeding(firstStr: String, centerStr: String, endStr: String) -> (NSAttributedString) {
    
    //定义富文本即有格式的字符串
    let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
    
    //
    let qiuxuewei : NSAttributedString = NSAttributedString(string: firstStr, attributes: [ NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 8)])
    //
    let shi : NSAttributedString = NSAttributedString(string: centerStr, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#B88A30"), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
    //
    let dashuaige : NSAttributedString = NSAttributedString(string: endStr, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 8)])
    
    attributedStrM.append(qiuxuewei)
    attributedStrM.append(shi)
    
    attributedStrM.append(dashuaige)
    
    return attributedStrM
}

/// 计算字符串的宽度，高度
public func textSizeWith(textStr: String?, width: CGFloat, textFont: CGFloat) -> (Float) {
    
    let string:String = textStr ?? ""
    let font:UIFont! = .systemFont(ofSize: textFont)
    let attributes = [NSAttributedString.Key.font:font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect:CGRect = string.boundingRect(with: CGSize(width: Double(width), height: 999.9), options: option, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
    return (Float)(rect.width)
}

///文字宽
public func get_widthForComment(fontSize: CGFloat, height: CGFloat = 20, str: String) -> CGFloat {
    let font = UIFont.systemFont(ofSize: fontSize)
    let rect = str.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return ceil(rect.width)
}
