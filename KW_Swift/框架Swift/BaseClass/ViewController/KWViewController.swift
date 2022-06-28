//
//  KWViewController.swift
//  BaseSwift
//
//  Created by 渴望 on 2019/6/5.
//  Copyright © 2019 渴望. All rights reserved.
//


import UIKit
import Moya
import Alamofire

public class KWViewController: UIViewController { //,LifetimeTrackable
    
    public var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    public var isStatusBarHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    deinit {
        debugPrint(#function + ": " + String(describing: type(of: self)))
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        kw_shadowHidden = true
        //不做任何扩展,如果有navigationBar和tabBar时,self.view显示区域在二者之间
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        kw_setupData()
        kw_setupUI()
        kw_requestData()
        
    }
    

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.defaultNavigationBar()
        if #available(iOS 14, *) { //导航栏返回按钮长按
            self.navigationItem.backButtonDisplayMode = .minimal
        }else{
            navigationItem.backBarButtonItem = backBarButton
        }
        
        kw_reloadData()
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    public func kw_setupData() -> Void {
//        kw.emptyDataSetTitle = "暂无数据"
    }
    
    public func kw_setupUI() -> Void {
//        navigationItem.backBarButtonItem = backBarButton
        view.backgroundColor = .custom(.section)
        
        if nav_clear_defult {
            /*
             导航栏默认透明时处理
             */
            self.edgesForExtendedLayout = .top
        }
        
    }
    
    public func kw_requestData() -> Void {}
    
    public func kw_reloadData() {}
}



public extension KWViewController {
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    
}


