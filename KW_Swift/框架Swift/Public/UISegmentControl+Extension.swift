//
//  UISegmentControl+Extension.swift
//  
//
//  Created by Yinjoy on 2021/4/21.
//

import Foundation

extension UIImage{
    public class func renderImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
        context.setFillColor(color.cgColor);
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
}

extension UISegmentedControl {
    /// - Parameters:
    ///   - normalColor: 普通状态下背景色
    ///   - selectedColor: 选中状态下背景色
    ///   - dividerColor: 选项之间的分割线颜色
    func setSegmentStyle(normalColor: UIColor, selectedColor: UIColor, dividerColor: UIColor) {
        
        let normalColorImage = UIImage.renderImageWithColor(normalColor, size: CGSize(width: 1.0, height: 1.0))
        let selectedColorImage = UIImage.renderImageWithColor(selectedColor, size: CGSize(width: 1.0, height: 1.0))
        let dividerColorImage = UIImage.renderImageWithColor(dividerColor, size: CGSize(width: 1.0, height: 1.0))
        
        setBackgroundImage(normalColorImage, for: .normal, barMetrics: .default)
        setBackgroundImage(selectedColorImage, for: .selected, barMetrics: .default)
        setDividerImage(dividerColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        let segAttributesNormal: NSDictionary = [NSAttributedString.Key.foregroundColor: selectedColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let segAttributesSeleted: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
        // 文字在两种状态下的颜色
        setTitleTextAttributes(segAttributesNormal as? [NSAttributedString.Key : Any], for: UIControl.State.normal)
        setTitleTextAttributes(segAttributesSeleted as? [NSAttributedString.Key : Any], for: UIControl.State.selected)
        
        // 边界颜色、圆角
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = dividerColor.cgColor
        self.layer.masksToBounds = true
    }
}
