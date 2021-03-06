//
//  UIViewExt.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/22.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

public extension KWSwiftWrapper where Base: UIView {
    
    var x: CGFloat {
        get { return base.frame.minX }
        set { base.frame.origin.x = newValue}
    }
    
    var y: CGFloat {
        get { return base.frame.minY }
        set { base.frame.origin.y = newValue }
    }
    
    var width: CGFloat {
        get { return base.frame.width }
        set { base.frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return base.frame.height }
        set { base.frame.size.height = newValue }
    }
    
    var centerX: CGFloat {
        get { return base.center.x }
        set { base.center.x = newValue }
    }
    
    var centerY: CGFloat {
        get { return base.center.y }
        set { base.center.y = newValue }
    }
    
    var size: CGSize {
        get { return base.frame.size }
        set { base.frame.size = newValue }
    }
    
    var origin: CGPoint {
        get { return base.frame.origin }
        set { base.frame.origin = newValue }
    }
    
    var right: CGFloat {
        get { return base.frame.maxX }
        set { x = newValue - width }
    }
    
    var bottom: CGFloat {
        get { return base.frame.maxY}
        set { y = newValue - height }
    }
    
    var cornerRadius: CGFloat {
        get { return base.layer.cornerRadius }
        set {
            base.layer.cornerRadius = newValue
            base.layer.masksToBounds = newValue > 0
        }
    }
    
    var borderWidth: CGFloat {
        get { return base.layer.borderWidth }
        set { base.layer.borderWidth = newValue }
    }
    
    var borderColor: UIColor? {
        get { return UIColor(cgColor: base.layer.borderColor!) }
        set { base.layer.borderColor = newValue?.cgColor }
    }
    
}


public extension KWSwiftWrapper where Base: UIView {
    
    //MARK: 当前所在控制器
    var currentController: UIViewController? {
        weak var next: UIResponder? = base
        while next != nil {
            next = next?.next ?? nil
            if let controller = next as? UIViewController {
                return controller
            }
        }
        return nil
    }
    
    //MARK: 添加视图
    ///
    ///     view.kw.add(UIView(), UILabel(), UIImageView())
    ///
    /// - Parameter subviews: 子view
    func add(_ subviews: UIView...) {
        subviews.forEach(base.addSubview)
    }
}


public extension KWSwiftWrapper where Base: UIView {
    
    //MARK: 设置边框
    /// - Parameters:
    ///   - width: 宽
    ///   - color: 色值
    func border(width: CGFloat, color: UIColor?) {
        base.layer.borderColor = color?.cgColor
        base.layer.borderWidth = width
    }
    
    //MARK: 设置圆角（贝塞尔曲线，自定义每个角）
    /// - Parameters:
    ///   - corners: 位置
    ///   - radius: 角度
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        base.layer.mask = mask
    }
    
    //MARK: 设置渐变色
    /// - Parameter colors: 渐变颜色
    func gradient(colors: [UIColor], start: CGPoint = CGPoint(x: 0, y: 0.5), end: CGPoint = CGPoint(x: 1, y: 0.5)) {
        guard colors.count > 0 else { return }
        if base.frame.size == .zero {
            base.layoutIfNeeded()
        }
        guard base.frame.size != .zero else { return }
        let gLayer = CAGradientLayer()
        gLayer.frame = base.bounds
        gLayer.startPoint = start
        gLayer.endPoint = end
        gLayer.colors = colors.map{$0.cgColor}
        base.layer.insertSublayer(gLayer, at: 0)
    }
}

//public extension UIView {
public extension KWSwiftWrapper where Base: UIView {
    //MARK: 阴影
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
        base.layer.masksToBounds = false;//必须要等于NO否则会把阴影切割隐藏掉
        base.layer.shadowColor = color.cgColor;// 阴影颜色
        base.layer.shadowOpacity = opactiy;// 阴影透明度，默认0
        base.layer.shadowOffset = .zero;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        base.layer.shadowRadius = 3 //阴影半径，默认3
        var shadowRect: CGRect?
        switch type {
        case .all:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: base.bounds.size.width + 2 * shadowSize, height: base.bounds.size.height + 2 * shadowSize)
        case .top:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: base.bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .bottom:
            shadowRect = CGRect.init(x: -shadowSize, y: base.bounds.size.height - shadowSize, width: base.bounds.size.width + 2 * shadowSize, height: 2 * shadowSize)
        case .left:
            shadowRect = CGRect.init(x: -shadowSize, y: -shadowSize, width: 2 * shadowSize, height: base.bounds.size.height + 2 * shadowSize)
        case .right:
            shadowRect = CGRect.init(x: base.bounds.size.width - shadowSize, y: -shadowSize, width: 2 * shadowSize, height: base.bounds.size.height + 2 * shadowSize)
        }
        base.layer.shadowPath = UIBezierPath.init(rect: shadowRect!).cgPath
    }
    
}


public extension KWSwiftWrapper where Base: UIView {
    //MARK: 单击手势
    typealias GestureAction = (UITapGestureRecognizer) -> ()
    
    func tapAtion(_ tap: @escaping GestureAction)  {
        base.tapRecognizer(tap)
    }
}

private extension UIView {
    
    typealias gestureAction = (UITapGestureRecognizer) -> ()
    
    struct AssociatedKeys {
        static var actionKey = "actionKey"
    }
    
    var action: gestureAction? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? gestureAction ?? nil }
        set {objc_setAssociatedObject(self, &AssociatedKeys.actionKey, newValue, .OBJC_ASSOCIATION_COPY) }
    }
    
    func tapRecognizer(_ action: @escaping gestureAction)  {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        self.action = action
    }
    
    @objc func tapAction(tap: UITapGestureRecognizer) {
        action?(tap)
    }
}






//MARK: XIB
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




