//
//  AutoFit.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/21.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import UIKit

fileprivate let ScreenW: CGFloat = UIScreen.main.bounds.size.width
fileprivate let ReferenceW: CGFloat = 375

/**
 前缀操作符：prefix operator
 中缀操作符：infix operator
 后缀操作符：postfix operator
 */

// MARK: ~ 自适应尺寸
postfix operator ~

public postfix func ~ (value: CGFloat) -> CGFloat {
    return value / ReferenceW * ScreenW
}

public postfix func ~ (font: UIFont) -> UIFont {
    return font.withSize(font.pointSize~)
}

public postfix func ~ (size: CGSize) -> CGSize {
    return CGSize(width: size.width~, height: size.height~)
}

public postfix func ~ (point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x~, y: point.y~)
}

public postfix func ~ (rect: CGRect) -> CGRect {
    return CGRect(origin: rect.origin~, size: rect.size~)
}

public postfix func ~ (edge: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: edge.top~, left: edge.left~, bottom: edge.bottom~, right: edge.right~)
}

