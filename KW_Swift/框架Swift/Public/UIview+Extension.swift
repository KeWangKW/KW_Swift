//
//  UIview+Extension.swift
//  KW_Swift
//
//  Created by Yinjoy on 2021/4/16.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

///阴影
public extension UIView {
    enum ShadowType: Int {
        case all = 0 ///四周
        case top  = 1 ///上方
        case left = 2///左边
        case right = 3///右边
        case bottom = 4///下方
    }
    ///默认设置：黑色阴影, 阴影所占视图的比例
    ///默认设置：黑色阴影
    func shadow(_ type: ShadowType) {
        shadow(type: type, color: .black, opactiy: 0.1, shadowSize: 2)
    }
    ///常规设置
    func shadow(type: ShadowType, color: UIColor,  opactiy: Float, shadowSize: CGFloat) -> Void {
        layer.masksToBounds = false;//必须要等于NO否则会把阴影切割隐藏掉
        layer.shadowColor = color.cgColor;// 阴影颜色
        layer.shadowOpacity = opactiy;// 阴影透明度，默认0
        layer.shadowOffset = .zero;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        layer.shadowRadius = 3 //阴影半径，默认3
        var shadowRect: CGRect?
        switch type {
        case .all:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: bounds.size.width + 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        case .top:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .bottom:
            shadowRect = CGRect.init(x: -shadowSize, y: bounds.size.height - shadowSize, width: bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .left:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        case .right:
            shadowRect = CGRect.init(x: bounds.size.width - shadowSize, y: -shadowSize, width: 2 * shadowSize, height: bounds.size.height + 2 * shadowSize)
        }
        layer.shadowPath = UIBezierPath.init(rect: shadowRect!).cgPath
    }
    
    
}

///XIB
public extension UIView {
    
    class func viewFromXIB(_ xibName: String, owner: Any? = nil, index: Int? = 0, frame: CGRect? = nil) -> UIView {
        let nib = UINib(nibName: xibName, bundle: nil)
        let xibView = nib.instantiate(withOwner: owner, options: nil)[index ?? 0] as! UIView
        xibView.autoresizingMask = UIView.AutoresizingMask(rawValue: 0)
        if frame != nil {
            xibView.frame = frame!
        }
        
        return xibView
    }
    
}

///圆角
extension UIView {
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

//button
extension UIButton {
    func titleImageEdgeInsets() {
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.frame.size.width)! , bottom: 0, right: (self.imageView?.frame.size.width)!)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.titleLabel?.frame.size.width)!, bottom: 0, right: -(self.titleLabel?.frame.size.width)!)
    }
}
