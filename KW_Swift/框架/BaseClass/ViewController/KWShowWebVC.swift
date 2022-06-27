//
//  KWShowWebVC.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/2/25.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit
import WebKit


extension KWShowWebVC {

    enum Request {
        case url(String)
        case html(String)
    }

    class func show(_ request:[String],index:Int ,title:String) {
        guard let VC = UIViewController.kw.currentController() else { return }
        VC.navigationController?.pushViewController(KWShowWebVC(request ,idx:index ,title: title), animated: true)
        
    }


}


class KWShowWebVC: KWViewController {
    var navigationTitle:String = ""
    
    var urlArr:[String] = []
    
    var idx:Int = 0 //默认展示第几个
    
    init(_ request:[String] , idx:Int ,title:String) {
        self.urlArr = request
        self.idx = idx
        self.navigationTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var leftBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(sHex: "#000000", alpha: 0.4)
        btn.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        btn.setImage(UIImage(named: "kw_left"), for: .normal)
        return btn
    }()
    private lazy var rightBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(sHex: "#000000", alpha: 0.4)
        btn.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        btn.setImage(UIImage(named: "kw_right"), for: .normal)
        return btn
    }()
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        var js = "document.documentElement.style.webkitTouchCallout='none';" /// 禁止长按
        js += "document.documentElement.style.webkitUserSelect='none';"  /// 禁止选择
        js += "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='250%';" ///字体放大
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
    
    
    deinit {
        webView.navigationDelegate = nil
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        
        view.backgroundColor = .custom(.backgroundWhite)
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(leftBtn)
        view.addSubview(rightBtn)
        
        webView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
            make.bottom.equalTo(-KHomeIndicatorHeight)
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        leftBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 100))
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        rightBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 100))
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func leftClick() {
        if idx == 0 {
            idx = urlArr.count - 1
        }else{
            idx = idx - 1
        }
        self.kw_requestData()
    }
    
    @objc func rightClick() {
        if idx == urlArr.count - 1 {
            idx = 0
        }else{
            idx = idx + 1
        }
        self.kw_requestData()
    }
    
    override func kw_requestData() {
        super.kw_requestData()

        let urlStr = self.urlArr[idx]
        guard let url = URL(string: urlStr) else { return }
        webView.load(URLRequest(url: url))
        
    }
    
    
}

extension KWShowWebVC {
    
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

extension KWShowWebVC {
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


extension KWShowWebVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
//        if self.navigationTitle.count > 0 {
//
//            navigationItem.title = self.navigationTitle
//        }else{
//
//            guard let title = webView.title else { return }
//            navigationItem.title = title
//        }
        navigationItem.title = "预览"
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}


