//
//  UILabelExt.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/26.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit


public extension UILabel {
    convenience init(textColor: UIColor, font: UIFont, text: String?) {
        self.init()
        self.textColor = textColor
        self.font = font
        self.text = text
    }
}

public extension KWSwiftWrapper where Base: UILabel {
    
    /// 文字尺寸
    var textSize: CGSize {
        if base.frame.width == 0 {
            base.layoutIfNeeded()
            guard base.frame.width > 0 else { return .zero }
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: base.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = base.font
        label.text = base.text
        label.sizeToFit()
        return label.frame.size
    }
    
    
    /// 添加富文本
    /// - Parameters:
    ///   - attributes: 富文本格式
    ///   - range: 区间
    func set(attributes: [NSAttributedString.Key: Any], range: NSRange) {
        guard attributes.count > 0, range.location != NSNotFound else { return }
        guard base.attributedText != nil || base.text != nil else { return }
        let attributeText = base.attributedText?.mutableCopy() as? NSMutableAttributedString ?? NSMutableAttributedString(string: base.text!)
        attributeText.setAttributes(attributes, range: range)
        base.attributedText = attributeText
    }
    
    
    /// 设置行间距、字间距、段落间距
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - wordSpace: 字间距
    ///   - paragraphSpace: 段落间距
    func set(lineSpacing: CGFloat = 0, wordSpacing: CGFloat = 0, paragraphSpacing: CGFloat = 0) {
        guard lineSpacing > 0 || wordSpacing > 0 || paragraphSpacing > 0 else { return }
        guard base.attributedText != nil || base.text != nil else { return }
        let attributeText = base.attributedText?.mutableCopy() as? NSMutableAttributedString ?? NSMutableAttributedString(string: base.text!)
        let range = NSMakeRange(0, attributeText.length)
        
        if wordSpacing > 0 {
            attributeText.addAttribute(NSAttributedString.Key.kern, value: wordSpacing, range: range)
        }
        
        if lineSpacing > 0 {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = lineSpacing
            attributeText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: range)
        }
        
        if paragraphSpacing > 0 {
            let paragraph = NSMutableParagraphStyle()
            paragraph.paragraphSpacing = paragraphSpacing
            attributeText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: range)
        }
        
        base.attributedText = attributeText
        base.sizeToFit()
    }
    
    
    func adjustsSpacingToFitWidth() {
        guard let text = base.text, text.count > 0 else { return }
        
        let length = text.count + 1
        let textWidth = self.textSize.width
        let labelWidth = base.frame.width
        
        let margin = (labelWidth - textWidth) / CGFloat(length)
        self.set(wordSpacing: margin)
    }
}




extension String {

    ///根据宽度跟字体，计算文字的高度
    
    func textAutoHeight(width:CGFloat, font:UIFont) ->CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics
        let rect = string.boundingRect(with:CGSize(width: width, height:0), options: [origin,lead,ssss], attributes: [NSAttributedString.Key.font:font], context:nil)
        return rect.height
      }
    ///根据高度跟字体，计算文字的宽度
    func textAutoWidth(height:CGFloat, font:UIFont) ->CGFloat{
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let rect = string.boundingRect(with:CGSize(width:0, height: height), options: [origin,lead], attributes: [NSAttributedString.Key.font:font], context:nil)
        return rect.width
    }
}
