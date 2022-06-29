//
//  kwTabBarController.swift
//  BaseSwift
//
//  Created by 渴望 on 2019/6/5.
//  Copyright © 2019 渴望. All rights reserved.
//

import UIKit
import Foundation


private let tabbar_title_1 = "首页"
private let tabbar_title_2 = "分类"
private let tabbar_title_3 = "购物车"
private let tabbar_title_4 = "商家中心"
private let tabbar_title_5 = "商学院"

enum KWTabBarItem {
    case one, two, three, four, five
    
    var title: String {
        switch self {
        case .one:
            return tabbar_title_1
        case .two:
            return tabbar_title_2
        case .three:
            return tabbar_title_3
        case .four:
            return tabbar_title_4
        case .five:
            return tabbar_title_5
        }
        
    }
    
    var image: UIImage? {
        switch self {
        case .one:
            return UIImage(named: "icon_guanli01")
//            return UIImage(named: "ic_tabbar_rui")
        case .two:
            return UIImage(named: "icon_gongzuotai01")
//            return UIImage(named: "ic_tabbar_hu")
        case .three:
            return UIImage(named: "icon_xiaoxi01")
//            return UIImage(named: "ic_tabbar_yun")
        case .four:
            return UIImage(named: "icon_wode01")
//            return UIImage(named: "ic_tabbar_cai")
        case .five:
            return UIImage(named: "icon_shangxueyuan01")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .one:
            return UIImage(named: "icon_guanli02")
//            return UIImage(named: "ic_tabbar_rui")
        case .two:
            return UIImage(named: "icon_gongzuotai02")
//            return UIImage(named: "ic_tabbar_hu")
        case .three:
            return UIImage(named: "icon_xiaoxi02")
//            return UIImage(named: "ic_tabbar_yun")
        case .four:
            return UIImage(named: "icon_wode02")
//            return UIImage(named: "ic_tabbar_cai")
        case .five:
            return UIImage(named: "icon_shangxueyuan02")
        }
    }
    
    var controller: UIViewController {
        var VC: UIViewController
        switch self {
        case .one:
            VC = BHomePageVC()
        case .two:
            VC = BClassifyVC()
        case .three:
//            VC = BShoppingCartVC()
            VC = CartListPageVC()
        case .four:
            VC = ShopCenterVC()
        case .five:
            VC = ShopCenterVC()
        }
        VC.title = title
        return KWNavigationController(rootViewController: VC)
    }
    
    func getController() -> UIViewController {
        let VC = controller
        let item = UITabBarItem(title: title, image: image?.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
//        if title == "商学院" {
//            item.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
//        }
//        //修改位置
        item.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        if #available(iOS 15.0, *) {
            
        }else{
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        }
        
        VC.tabBarItem = item
        return VC
    }
}


class KWTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kw_initialize()
        
        self.delegate = self
        let tabBarItems: [KWTabBarItem] = [.one, .two, .five, .three, .four]
        tabBarItems.forEach {
            addChild($0.getController())
        }
    }
    
    private func kw_initialize() -> Void {
        let tabbar: UITabBar = UITabBar.appearance()
        tabbar.isTranslucent = false
        tabbar.barTintColor = .custom(.backgroundWhite)
        
//        if AppContext.shared.appUser.level == "9" {
//            let bezier = UIBezierPath()
//            bezier.move(to: CGPoint.zero)
//            bezier.addLine(to: CGPoint(x: KScreenWidth * 0.5 - 22, y: 0))
//            bezier.append(UIBezierPath(arcCenter: CGPoint(x: KScreenWidth * 0.5, y: 5), radius: 22, startAngle: CGFloat.pi * -0.06, endAngle: CGFloat.pi * -0.94, clockwise: false))
//            bezier.move(to: CGPoint(x: KScreenWidth * 0.5 + 22, y: 0))
//            bezier.addLine(to: CGPoint(x: KScreenWidth, y: 0))
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = bezier.cgPath
//            shapeLayer.lineWidth = 1
//            shapeLayer.fillColor = UIColor.white.cgColor
//            shapeLayer.strokeColor = UIColor.Section.cgColor
//            tabBar.backgroundColor = .white
//            tabBar.layer.insertSublayer(shapeLayer, at: 0)
//            tabBar.shadowImage = UIImage()
//            tabBar.backgroundImage = UIImage()
//        }
        
        
        var normalAttributes = [NSAttributedString.Key: Any]()
        normalAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 12)
        normalAttributes[NSAttributedString.Key.foregroundColor] = UIColor.Assist
        
        var selectedAttributes = [NSAttributedString.Key: Any]()
        selectedAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 12)
        //selectedAttributes[NSAttributedString.Key.foregroundColor] = UIColor.init(hexStr:"E62424")
        selectedAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
        
        let item: UITabBarItem = UITabBarItem.appearance()
        item.setTitleTextAttributes(normalAttributes, for: .normal)
        item.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            
            //修改文字位置
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            
            tabbar.standardAppearance = appearance
            tabbar.scrollEdgeAppearance = appearance
        }
    }
    
}

extension KWTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) //点击位置

//        if AppContext.shared.isLogin == false {
//            present(KWNavigationController(rootViewController: KWLogInPwdVC()), animated: true)
//            return false
//        }
        
//        print(AppContext.shared.appUser.id)
//        print(AppContext.shared.appUser.companyId)
//        print(AppContext.shared.appUser.companyName)

//        if selectedIndex == 2 {
//            let vc = ConstructionMessageVC()
////            let vc = ConstructionMessageVC.init(.url(String(format: "http://localhost:8080/constructionMessage?userId=%@&companyId=%@&companyName=%@", AppContext.shared.appUser.id, AppContext.shared.appUser.companyId, AppContext.shared.appUser.companyName)), title: "施工信息")
//            let controller = UIViewController.kw.currentController()
//            controller?.navigationController?.pushViewController(vc, animated: false)
//            return false
//        }
        
        return true
    }
}
