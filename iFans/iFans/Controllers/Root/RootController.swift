//
//  RootController.swift
//  iFans
//
//  Created by 潘东 on 16/8/31.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit
import DLPanableWebView
import MBProgressHUD

class RootController: BaseController {

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
    
    //MARK: --------------------------- Controller Settings ------------------------
    func setNavi() {
        setNaviBarTitle("1000", font: UIFont.systemFontOfSize(12), textColor: UIColor.blackColor())
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
        let url = Hybrid.baseUrl + Hybrid.shouye
        let request = NSURLRequest(URL: NSURL(string: url)!)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        return webView
    }()
    
    private lazy var hud: MBProgressHUD = {
        let hud = MBProgressHUD()
        hud.mode = .Indeterminate
        return hud
    }()
}

extension RootController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        hud.show(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        hud.hide(true)
        hud.removeFromSuperViewOnHide = true
    }
}
