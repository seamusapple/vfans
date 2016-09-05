//
//  RootController.swift
//  iFans
//
//  Created by 潘东 on 16/8/31.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit
import MBProgressHUD
import WebViewJavascriptBridge
import SwiftyJSON

class RootController: BaseController {

    //MARK:----------------------------- Life Cycle -------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavi()
        addPageSubviews()
        layoutPageSubviews()
        setJSBridge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: --------------------------- Controller Settings ------------------------
    func setNavi() {
        setNaviBarBackgroundColor(Color.naviColor)
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
    
    func setJSBridge() {
        jsBridge = WebViewJavascriptBridge(forWebView: webView)
        jsBridge?.setWebViewDelegate(self)
        jsBridge!.registerHandler("AppNativeHandler") { [weak self] (data, responseCallback) in
            let json = JSON(data)
            let action = json["action"].stringValue
            let data = json["data"]
            switch action {
            case "loadPage":
                if let url = data["url"].string {
                    let loadPageController = WebViewController(url: url)
                    self!.navigationController?.pushViewController(loadPageController, animated: true)
                }
                
            default:
                print("无此接口")
            }
        }
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    private var webView: UIWebView = {
        let webView = UIWebView()
        let url = Hybrid.baseUrl + Hybrid.home
        let request = NSURLRequest(URL: NSURL(string: url)!)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        return webView
    }()
    
    private lazy var hud: MBProgressHUD = {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Indeterminate
        return hud
    }()

    private var jsBridge: WebViewJavascriptBridge?
}

//MARK: --------------------------- WebView Delegate --------------------------
extension RootController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        hud.showAnimated(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let isIOS = true
        webView.stringByEvaluatingJavaScriptFromString("isIOS(\(isIOS))")
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        setNaviBarTitle(title!, font: Font.naviTitle, textColor: Color.white)
        hud.hideAnimated(true)
    }
}
