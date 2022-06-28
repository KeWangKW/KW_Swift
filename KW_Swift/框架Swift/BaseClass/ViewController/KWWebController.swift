//
//  KWWebController.swift
//  Whatever
//
//  Created by  on 2020/7/30.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import WebKit


extension KWWebController {
    
    enum Request {
        case url(String)
        case html(String)
    }
    
    class func show(_ request: Request ,title:String) {
        guard let VC = UIViewController.kw.currentController() else { return }
        VC.navigationController?.pushViewController(KWWebController(request ,title: title), animated: true)
        
    }
}


class KWWebController: KWViewController, WKScriptMessageHandler {
    var navigationTitle:String = ""
    
    private let request: Request
    
    init(_ request: Request ,title:String) {
        self.request = request
        self.navigationTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var rightBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "icon_navigation_web_隐藏"), style: .done, target: self, action: #selector(openUseSafari))
        return view
    }()

    lazy var goBackBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(named: "icon_navigation_back"), style: .done, target: self, action: #selector(goBackAction))
        return view
    }()

//    lazy var goForwardBarButton: UIBarButtonItem = {
//        let view = UIBarButtonItem(image: UIImage(named: "icon_navigation_forward"), style: .done, target: self, action: #selector(goForwardAction))
//        return view
//    }()
//
//    lazy var stopReloadBarButton: UIBarButtonItem = {
//        let view = UIBarButtonItem(image: UIImage(named: "icon_navigation_refresh"), style: .done, target: self, action: #selector(stopReloadAction))
//        return view
//    }()
//
//    let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        var js = "document.documentElement.style.webkitTouchCallout='none';" /// 禁止长按
        js += "document.documentElement.style.webkitUserSelect='none';"  /// 禁止选择
//        js += "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='250%';" ///字体放大
//        let js = ""
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        let web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = self
        return web
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .Base
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 0)
        return view
    }()
    
//    private lazy var toolBar: UIToolbar = {
//        let view = UIToolbar()
//        view.items = [self.goBackBarButton, self.goForwardBarButton, self.spaceBarButton, self.stopReloadBarButton]
//        view.backgroundColor = .custom(.backgroundWhite)
//        view.tintColor = .Title
//        return view
//    }()
    
    deinit {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.backgroundColor = .custom(.backgroundWhite)
        view.addSubview(webView)
//        view.addSubview(toolBar)
        view.addSubview(progressView)
        
//        webView.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.edges.equalTo(view.safeAreaLayoutGuide)
//            } else {
//                make.edges.equalToSuperview()
//            }
//            make.bottom.equalTo(toolBar.snp.top)
//        }
//        toolBar.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(-KHomeIndicatorHeight)
//            make.height.equalTo(36)
//        }
        
        webView.snp.makeConstraints { (make) in
//            make.left.top.right.bottom.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
//        webView.configuration.userContentController.add(self, name: "方法名")
    }
    
    override func kw_requestData() {
        super.kw_requestData()
        switch request {
        case .url(let string):
            guard let url = URL(string: string) else { return }
            webView.load(URLRequest(url: url))
        case .html(let string):
            
            let htmls = """
                    <html>
                    <head>
                    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\">
                    </header>
                    <body>
                    <script type='text/javascript'>
                    window.onload = function(){
                        var $img = document.getElementsByTagName('img');
                        for(var p in  $img){
                            $img[p].style.width =  document.body.clientWidth-18;
                            $img[p].style.height = 'auto'
                        }
                    }
                    </script>
                    \(string)<body>
                    """
            let htmlss = "<html><body><style> img{width: 100%% ! important;}</style> \(htmls) </ body></html>"
            
//            webView.loadHTMLString(htmlss, baseURL: nil)
            let sss = htmlss.replacingOccurrences(of: "figure", with: "div")
            webView.loadHTMLString(sss, baseURL: nil)
        }
        
        
    }
    
    
    private func updateUI() {
        goBackBarButton.isEnabled = webView.canGoBack
//        goForwardBarButton.isEnabled = webView.canGoForward
//        stopReloadBarButton.image = webView.isLoading ? UIImage(named: "icon_navigation_stop") : UIImage(named: "icon_navigation_refresh")
    }
}

extension KWWebController {
    
    @objc private func goBackAction() {
        webView.goBack()
    }
    
    @objc private func goForwardAction() {
        webView.goForward()
    }
    
    @objc private func openUseSafari() {
        guard let url = webView.url else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: .none)
    }
    
    @objc private func stopReloadAction() {
        if webView.isLoading {
            webView.stopLoading()
        } else {
            webView.reload()
        }
    }
}

extension KWWebController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
}


extension KWWebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        updateUI()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateUI()
        
        if self.navigationTitle.count > 0 {
            
            navigationItem.title = self.navigationTitle
        }else{
            
            guard let title = webView.title else { return }
            navigationItem.title = title
        }
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        updateUI()
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
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}


