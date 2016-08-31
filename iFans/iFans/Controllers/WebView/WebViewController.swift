//
//  WebViewController.swift
//  iFans
//
//  Created by 潘东 on 16/8/31.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit
import MBProgressHUD
import DLPanableWebView
import WebViewJavascriptBridge

class WebViewController: BaseController {

    //MARK:----------------------------- Life Cycle -------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavi()
        addPageSubviews()
        layoutPageSubviews()
        setDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:----------------------------- Init Methods -------------------------------
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --------------------------- Controller Settings ------------------------
    func setNavi() {
        
    }
    
    func addPageSubviews() {
        self.view.addSubview(webView)
        self.view.addSubview(hud)
    }
    
    func layoutPageSubviews() {
        webView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func setDelegate() {
        webView.delegate = self
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    private lazy var webView: DLPanableWebView = {
        let webView = DLPanableWebView()
        let request = NSURLRequest(URL: NSURL(string: self.url)!)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        return webView
    }()
    
    private lazy var hud: MBProgressHUD = {
        let hud = MBProgressHUD()
        hud.mode = .Indeterminate
        return hud
    }()
    
    private lazy var jsBridge: WebViewJavascriptBridge = {
        let jsBridge = WebViewJavascriptBridge(forWebView: self.webView)
        jsBridge.registerHandler("AppNativeHandler") { [weak self] (data, responseCallback) in
//            let json = JSON(data)
//            let action = json["action"].stringValue
//            let data = json["data"]
//            switch action {
//            case "loadPage":
//                if let url = data["url"].string {
//                    let loadPageController = WebViewController(url: url)
//                    self.navigationController?.pushViewController(loadPageController, animated: true)
//                }
//            
//            case "getPhoneNum":
//                
//                
//            default:
//                print("无此接口")
        }
        return jsBridge
    }()
    
    private var url: String = ""
}

//MARK: --------------------------- WebView Delegate --------------------------
extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        hud.show(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        setNaviBarTitle(title!, font: Font.naviTitle, textColor: Color.black)
        hud.hide(true)
        hud.removeFromSuperViewOnHide = true
    }
}
