//
//  BSCZNFangAnWebVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/10/9.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit
import WebKit

class BSCZNFangAnWebVC: KWViewController , WKScriptMessageHandler ,WKUIDelegate ,WKNavigationDelegate {
    var urlStr:String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: JS调用原生注册
        webView.configuration.userContentController.add(WeakScriptMessageDelegate.init(self), name: "navigateBack")
        webView.configuration.userContentController.add(WeakScriptMessageDelegate.init(self), name: "logonFailure")
        webView.configuration.userContentController.add(WeakScriptMessageDelegate.init(self), name: "packageClip")
        webView.configuration.userContentController.add(WeakScriptMessageDelegate.init(self), name: "makePhoneCall")
        webView.configuration.userContentController.add(WeakScriptMessageDelegate.init(self), name: "aliPay")
        
        NotificationCenter.removeObserver(kw: self)
        NotificationCenter.addObserver(kw: self, selector: #selector(alipayNotification(_:)), name: .alipay, object: nil)
        NotificationCenter.addObserver(kw: self, selector: #selector(wechatNotification(_:)), name: .wechat, object: nil)
        NotificationCenter.addObserver(kw: self, selector: #selector(showPriceNotification(_:)), name: .webShowPrice, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.removeObserver(kw: self)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "navigateBack")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "logonFailure")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "packageClip")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "makePhoneCall")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "aliPay")
        
        NotificationCenter.removeObserver(kw: self)
    }
    
    @objc private func showPriceNotification(_ noti: Notification) {
        self.webView.evaluateJavaScript("isUpdateAuth('\(CheckPriceStatus.isNotAuthWeb)')") { data, error in
            print(data as Any)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.removeObserver(kw: self)
        NotificationCenter.addObserver(kw: self, selector: #selector(alipayNotification(_:)), name: .alipay, object: nil)
        NotificationCenter.addObserver(kw: self, selector: #selector(wechatNotification(_:)), name: .wechat, object: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_blackreturn"), style: .plain, target: self, action: #selector(goBack))
        
        self.fd_prefersNavigationBarHidden = true
    }
    

    //MARK: kw_setupData
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    //MARK: kw_setupUI
    override func kw_setupUI() {
        super.kw_setupUI()
        view.backgroundColor = .custom(.backgroundWhite)
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
    }
    
//    override func observeValue(forKeyPath keyPath: String?,
//                                        of object: Any?,
//                                        change: [NSKeyValueChangeKey: Any]?,
//                                        context: UnsafeMutableRawPointer?) {
//        guard let theKeyPath = keyPath, object as? WKWebView == webView else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        if theKeyPath == "canGoBack"{
//            if let newValue = change?[NSKeyValueChangeKey.newKey]{
//                let newV = newValue as! Bool
//                if newV == true{
//                    self.fd_interactivePopDisabled = true
//                }else{
//                    self.fd_interactivePopDisabled = false
//                }
//            }
//        }
//    }
    
    
    //MARK: kw_requestData
    override func kw_requestData() {
        super.kw_requestData()
        
        webView.load(URLRequest(url: URL(string: urlStr)!))
        
    }

    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        var js = "document.documentElement.style.webkitTouchCallout='none';" /// 禁止长按
        js += "document.documentElement.style.webkitUserSelect='none';"  /// 禁止选择
//        let js = ""
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        let web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = self
        web.uiDelegate = self
        return web
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .init(hexStr: "E5B16D")
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 0)
        return view
    }()
    
    deinit {
        webView.navigationDelegate = nil
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "canGoBack" )
    }
    
    //MARK: 返回按钮处理
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        //MARK: 原生调用js方法
//        self.webView.evaluateJavaScript("testObject('xds123123123','22')") { data, error in
//            print(data as Any)
//        }
        
    }
    
}


extension BSCZNFangAnWebVC {
    //MARK: 代理 接收到JS消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        print(message.body)
        
        if message.name == "navigateBack" {
            self.navigationController?.popViewController(animated: true)
        }else if message.name == "logonFailure" {
            
            AppContext.shared.logout()
            let login = KWLogInPwdVC()
            let navLogin = KWNavigationController(rootViewController: login)
            UIApplication.shared.windows.first?.rootViewController = navLogin
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }else if message.name == "packageClip" {
            UIViewController.kw.currentController()?.navigationController?.popToRootViewController(animated: false)
            UIViewController.kw.currentController()?.tabBarController?.selectedIndex = 2
            
            GCD.delay(0.5) {
                let vc = UIViewController.kw.currentController() as! CartListPageVC
                vc.defaultSelectedIndex(0)
//                vc.vcTypeNow = 0
//                vc.changeVC1()
            }
        }else if message.name == "makePhoneCall" {
            
            let phoneNum = message.body as! String
            let url = URL(string: "tel://" + phoneNum)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }else if message.name == "aliPay" {
            let sss = message.body as! String
            DYPayment.shared.alipay(sss)
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if self.title?.count ?? 0 > 0 {

            navigationItem.title = self.title
        }else{

            guard let title = webView.title else { return }
            navigationItem.title = title
        }
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        let scheme: String = navigationAction.request.url!.scheme!
//        let urlString: String = navigationAction.request.url!.absoluteString
//        print(scheme)
//        print(urlString)
//
//        if (scheme.contains("jshandlers")) {
//            [self.handleCustomAction(with: urlString)];
//            decisionHandler(.cancel);
//            return;
//        }
        decisionHandler(.allow);
    }

//    @objc func handleCustomAction(with urlString: String) {
//
//    }
    
}

extension BSCZNFangAnWebVC {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //返回处理
        guard let theKeyPath = keyPath, object as? WKWebView == webView else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if theKeyPath == "canGoBack"{
            if let newValue = change?[NSKeyValueChangeKey.newKey]{
                let newV = newValue as! Bool
                if newV == true{
                    self.fd_interactivePopDisabled = true
                }else{
                    self.fd_interactivePopDisabled = false
                }
            }
        }
        
        //进度条
        guard let _ = object as? WKWebView else { return }
        guard let path = keyPath, path == "estimatedProgress" else { return }
        guard let progress = change?[NSKeyValueChangeKey.newKey] as? NSNumber  else { return }
        if progress == 1 {
            progressView.isHidden = true
            progressView.setProgress(0, animated: false)
        } else {
            progressView.isHidden = false
            progressView.setProgress(Float(truncating: progress), animated: true)
        }
        

    }
    
    //js弹框处理
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVicwController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        alertVicwController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (alertAction) in
                    completionHandler(false)
                }))
        alertVicwController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (alertAction) in
                    completionHandler(true)
                }))
        self.present(alertVicwController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertViewController = UIAlertController(title: "提示", message:message, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (action) in
                    completionHandler()
                }))
        self.present(alertViewController, animated: true, completion: nil)
    }
}



//MARK: 支付回调
extension BSCZNFangAnWebVC {
//    DYPayment.shared.alipay(ss ?? "")
    
    @objc private func alipayNotification(_ noti: Notification) {
        guard let success = noti.object as? Bool else { return }
        result(success)
    }
    
    @objc private func wechatNotification(_ noti: Notification) {
        guard let success = noti.object as? Bool else { return }
        result(success)
    }
    
    private func result(_ res: Bool) {
        if res {
            AlertOnly("升级成功", "需重新登录", "确定") {
                AppContext.shared.logout()
                let login = KWLogInPwdVC()
                let navLogin = KWNavigationController(rootViewController: login)
                UIApplication.shared.windows.first?.rootViewController = navLogin
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        } else {
            AlertText("支付失败")
        }
    }
    
}
