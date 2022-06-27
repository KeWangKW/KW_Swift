//
//  UIColorExt.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/19.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit




// MARK: - Enum
public extension UIColor {
    
    enum Custom {
        case title, content, assist
        case section, line
        case backgroundWhite, backgroundBlack
        case base
        case orage
        
        func style() -> Style {
            switch self {
            case .title: return Style(light: 0x1A1919, dark: 0x1A1919)
            case .content: return Style(light: 0x6F7172, dark: 0x6F7172)
            case .assist: return Style(light: 0x9A9B9D, dark: 0x9A9B9D)
                
            case .section: return Style(light: 0xF8F8F8, dark: 0xF8F8F8)
            case .line: return Style(light: 0xDDDDDD, dark: 0xDDDDDD)
//            case .line: return Style(light: 0xF5F5F5, dark: 0xF5F5F5)
                
            case .backgroundBlack: return Style(light: 0x000000, dark: 0x000000)
            case .backgroundWhite: return Style(light: 0xFFFFFF, dark: 0xFFFFFF)
            
            case .base: return Style(light: 0x0069B7, dark: 0x0069B7)
                
            case .orage: return Style(light: 0xFF6633, dark: 0xFF6633)
            }
        }
    }
    
    struct Style {
        let light: UInt64
        let dark: UInt64
    }
}

public extension UIColor {
    
    /// 自定义色值
    /// - Parameter custom: 枚举
    /// - Returns: 颜色
    static func custom(_ custom: Custom) -> UIColor {
        let style = custom.style()
        guard #available(iOS 13.0, *) else { return UIColor(hex: style.light) }
        return UIColor(light: UIColor(hex: style.light), dark: UIColor(hex: style.dark))
    }
    
    static var Title: UIColor {
        return .custom(.title)
    }
    
    static var Content: UIColor {
        return .custom(.content)
    }
    
    static var Assist: UIColor {
        return .custom(.assist)
    }
    
    static var Base: UIColor {
        return .custom(.base)
    }
    
    static var Section: UIColor {
        return .custom(.section)
    }
    
    static var Orange: UIColor {
        return .custom(.orage)
    }
    
    /// 随机色值
    static var random: UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)),
                       g: CGFloat(arc4random_uniform(256)),
                       b: CGFloat(arc4random_uniform(256)))
    }
    
    static var backGround: UIColor {
        return UIColor(hexString: "#F4F4F4")
    }
    
    static var shenHuangColor: UIColor {
        return UIColor(hexString: "#FAD189")
    }
    
    static var danHuangColor: UIColor {
        return UIColor(hexString: "#FCE0B0")
    }
}


// MARK: - Convenience
public extension UIColor {
    
    /// 通过字符串数值初始化颜色
    /// - Parameters:
    ///   - sHex: 字符串色值 (eg: "#FFFFFF", "##FFFFFF", "0xFFFFFF")
    ///   - alpha: 透明度 默认1
    convenience init?(sHex: String, alpha: CGFloat = 1.0) {
        if sHex.isEmpty { return nil }
        
        var value = sHex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if value.count == 0 { return nil }
        
        if value.hasPrefix("##") || value.hasPrefix("0x") {
            value = String(value.suffix(value.count - 2))
        }
        
        if value.hasPrefix("#") {
            value = String(value.suffix(value.count - 1))
        }
        
        guard value.count == 6 else { return nil }
        
        let scanner = Scanner(string: "\(value)")
        var hex: UInt64 = 0
        guard scanner.scanHexInt64(&hex) else { return nil }
        
        self.init(hex: hex, alpha: alpha)
    }
    
    
    /// 通过16进制初始化颜色
    /// - Parameters:
    ///   - hex: 16进制色值 (eg: 0xFFFFFF)
    ///   - alpha: 透明度
    convenience init(hex: UInt64, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0xFF00) >> 8)
        let blue = CGFloat(hex & 0xFF)
        self.init(r: red, g: green, b: blue, alpha: alpha)
    }
    
    
    /// 使用RGB快捷初始化色值
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    
    /// 快捷初始化两种模式颜色
    /// - Parameters:
    ///   - light: 正常模式下的颜色
    ///   - dark: 深色模式下的颜色
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            //self.init(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
            self.init(dynamicProvider: { $0.userInterfaceStyle == .dark ? light : light })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
}

// MARK: - Convenience
public extension UIColor {
     
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

