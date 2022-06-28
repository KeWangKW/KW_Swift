

import UIKit

//MARK: 常用导航栏样式
extension UIViewController {
    ///不调用 nav_color_xxx 时
    ///默认背景白色，文字按钮黑色
    
    //设置导航栏背景图：
    //kw_backgroundImage = image
    //kw_backgroundImage = nil
    
    //纯透明
    //title 白色
    //barButtonItem 白色
    //self.edgesForExtendedLayout = .top //同时调用此方法 顶部填充上去
    @objc func nav_color_clear() {
        /* 效果差，有闪动
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            UIViewController.kw.currentController()?.edgesForExtendedLayout = .top
        }*/
        kw_backgroundColor = .clear
        kw_tintColor = .white
        kw_titleColor = .white
        kw_barStyle = .default
        kw_barAlpha = 0
        kw_shadowHidden = true
        
        nav_clear_defult = true
    }
    
    //透明渐变成深色（适用于展示VC中的背景图）
    //title保持白色
    //barButtonItem保持白色 (渐变处理时 设置leftBarButtonItem.tintColor 不会触发修改)
    //self.edgesForExtendedLayout = .top //同时调用此方法 顶部填充上去
    @objc func nav_color_gradient(_ color:UIColor) {
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            UIViewController.kw.currentController()?.edgesForExtendedLayout = .top
        }*/
        kw_backgroundColor = color
        kw_barAlpha = 0
        kw_tintColor = .white
        kw_titleColor = UIColor(white: 1, alpha: 1)
        kw_shadowHidden = true
        
        nav_color_gradient_scroll = true
        nav_clear_defult = true
    }
    @objc var nav_color_gradient_scroll:Bool {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.gradient_scroll) as? Bool ?? false
        } set{
            objc_setAssociatedObject(self, &KWNavigationBarKeys.gradient_scroll, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var nav_clear_defult:Bool {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.clear_defult) as? Bool ?? false
        } set{
            objc_setAssociatedObject(self, &KWNavigationBarKeys.clear_defult, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /*
     子类实现
     override func scrollViewDidScroll(_ scrollView: UIScrollView) {}
     方法会覆盖现有方法
     
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if nav_color_gradient_scroll {
            let contentOffsetY = scrollView.contentOffset.y
            let progress = min(1, max(0, contentOffsetY / 60))
            if progress < 0.1 {
                kw_barStyle = .default
                kw_tintColor = .white
                kw_titleColor = UIColor(white: 1, alpha: 0)
            } else {
                kw_barStyle = .black
                kw_tintColor = UIColor(white: 0, alpha: progress)
                kw_titleColor = UIColor(white: 1, alpha: progress)
            }
            kw_barAlpha = progress
        }
     }
     */
}


// MARK: -  自定义导航栏相关的属性, 支持UINavigationBar.appearance()
extension UIViewController {
    
    // MARK: -  属性
    
    /// keys
    private struct KWNavigationBarKeys {
        static var barStyle = "KWNavigationBarKeys_barStyle"
        static var backgroundColor = "KWNavigationBarKeys_backgroundColor"
        static var backgroundImage = "KWNavigationBarKeys_backgroundImage"
        static var tintColor = "KWNavigationBarKeys_tintColor"
        static var barAlpha = "KWNavigationBarKeys_barAlpha"
        static var titleColor = "KWNavigationBarKeys_titleColor"
        static var titleFont = "KWNavigationBarKeys_titleFont"
        static var shadowHidden = "KWNavigationBarKeys_shadowHidden"
        static var shadowColor = "KWNavigationBarKeys_shadowColor"
        static var enablePopGesture = "KWNavigationBarKeys_enablePopGesture"
        
        static var clear_defult = "KWNavigationBarKeys_nav_clear_defult"
        static var gradient_scroll = "KWNavigationBarKeys_nav_color_gradient_scroll"
    }

    //MARK: 导航栏样式，默认样式
    var kw_barStyle: UIBarStyle {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.barStyle) as? UIBarStyle ?? UINavigationBar.appearance().barStyle
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.barStyle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            kw_setNeedsNavigationBarTintUpdate()
        }
    }
    
    //MARK: 导航栏前景色（item的文字图标颜色），默认黑色
    var kw_tintColor: UIColor {
        get {
            if let tintColor = objc_getAssociatedObject(self, &KWNavigationBarKeys.tintColor) as? UIColor {
                return tintColor
            }
            if let tintColor = UINavigationBar.appearance().tintColor {
                return tintColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.tintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            kw_setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    //MARK: 导航栏标题文字颜色，默认黑色
    var kw_titleColor: UIColor {
        get {
            if let titleColor = objc_getAssociatedObject(self, &KWNavigationBarKeys.titleColor) as? UIColor {
                return titleColor
            }
            if let titleColor = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor {
                return titleColor
            }
            return .black
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            kw_setNeedsNavigationBarTintUpdate()
        }
    }
    
    //MARK: 导航栏标题文字字体，默认17号粗体
    var kw_titleFont: UIFont {
        get {
            if let titleFont = objc_getAssociatedObject(self, &KWNavigationBarKeys.titleFont) as? UIFont {
                return titleFont
            }
            if let titleFont = UINavigationBar.appearance().titleTextAttributes?[NSAttributedString.Key.font] as? UIFont {
                return titleFont
            }
            return UIFont.boldSystemFont(ofSize: 17)
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.titleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            kw_setNeedsNavigationBarTintUpdate()
        }
    }
    
    
    //MARK: 导航栏背景色，默认白色
    var kw_backgroundColor: UIColor {
        get {
            if let backgroundColor = objc_getAssociatedObject(self, &KWNavigationBarKeys.backgroundColor) as? UIColor {
                return backgroundColor
            }
            if let backgroundColor = UINavigationBar.appearance().barTintColor {
                return backgroundColor
            }
            return .white
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            kw_setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    //MARK: 导航栏背景图片
    var kw_backgroundImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.backgroundImage) as? UIImage ?? UINavigationBar.appearance().backgroundImage(for: .default)
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.backgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            kw_setNeedsNavigationBarBackgroundUpdate()
        }
    }
    
    //MARK: 导航栏背景透明度，默认1
    var kw_barAlpha: CGFloat {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.barAlpha) as? CGFloat ?? 1
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.barAlpha, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            kw_setNeedsNavigationBarBackgroundUpdate()
        }
    }

    //MARK: 导航栏底部分割线是否隐藏，默认不隐藏
    var kw_shadowHidden: Bool {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.shadowHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.shadowHidden, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            kw_setNeedsNavigationBarShadowUpdate()
        }
    }
    
    //MARK: 导航栏底部分割线颜色
    var kw_shadowColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.shadowColor) as? UIColor ?? UIColor(white: 0, alpha: 0.3)
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.shadowColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            kw_setNeedsNavigationBarShadowUpdate()
        }
    }
    
    //MARK: 是否开启手势返回，默认开启
    var kw_enablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &KWNavigationBarKeys.enablePopGesture) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &KWNavigationBarKeys.enablePopGesture, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    // MARK: -  更新UI

    // 整体更新
    func kw_setNeedsNavigationBarUpdate() {
        guard let naviController = navigationController as? KWNavigationController else { return }
        naviController.kw_updateNavigationBar(for: self)
    }
    
    // 更新文字、title颜色
    func kw_setNeedsNavigationBarTintUpdate() {
        guard let naviController = navigationController as? KWNavigationController else { return }
        naviController.kw_updateNavigationBarTint(for: self)
    }

    // 更新背景
    func kw_setNeedsNavigationBarBackgroundUpdate() {
        guard let naviController = navigationController as? KWNavigationController else { return }
        naviController.kw_updateNavigationBarBackground(for: self)
    }
    
    // 更新shadow
    func kw_setNeedsNavigationBarShadowUpdate() {
        guard let naviController = navigationController as? KWNavigationController else { return }
        naviController.kw_updateNavigationBarShadow(for: self)
    }
    
}

