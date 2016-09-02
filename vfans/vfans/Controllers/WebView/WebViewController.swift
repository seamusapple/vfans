//
//  WebViewController.swift
//  iFans
//
//  Created by 潘东 on 16/8/31.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit
import MBProgressHUD
import WebViewJavascriptBridge
import SwiftyJSON
import JLToast

class WebViewController: BaseController {

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
        setNaviBarBtnItemWithImage(UIImage(named: Icon.back)!, direction: true, style: .Plain, action: #selector(backToUpLevel), hidden: false)
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
        jsBridge?.registerHandler("AppNativeHandler") { [weak self] (data, responseCallback) in
            let json = JSON(data)
            let action = json["action"].stringValue
            let data = json["data"]
            switch action {
            case "loadPage":
                if let url = data["url"].string {
                    let loadPageController = WebViewController(url: url)
                    self!.navigationController?.pushViewController(loadPageController, animated: true)
                }
                
            case "savePhoneNum":
                if let phoneList = data["phoneList"].array {
                    let hud = MBProgressHUD.showHUDAddedTo(self!.view, animated: true)
                    hud.mode = .AnnularDeterminate
                    hud.labelText = "正在保存..."
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { 
                        self?.saveToAddressBook(phoneList)
                            dispatch_async(dispatch_get_main_queue(), {
                            hud.hide(true)
                            hud.removeFromSuperViewOnHide = true
                        })
                    })
                }
                
            case "delPhoneNum":
                if let phoneList = data["phoneList"].array {
                    let hud = MBProgressHUD.showHUDAddedTo(self!.view, animated: true)
                    hud.mode = .AnnularDeterminate
                    hud.labelText = "正在删除..."
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                        self?.delFromAddressBook(phoneList)
                        dispatch_async(dispatch_get_main_queue(), {
                            hud.hide(true)
                            hud.removeFromSuperViewOnHide = true
                        })
                    })
                }
                
            default:
                print("无此接口")
            }
        }
    }
    
    //MARK: --------------------------- Event Response ------------------------
    func backToUpLevel() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func saveToAddressBook(data: [JSON]) {
        ContactsStore.sharedStore.savePhoneData(data, withCallback: {
            if ContactsStore.sharedStore.isSaveSuccess() {
                JLToastView.setDefaultValue(Size.screenHeight / 2, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: UIUserInterfaceIdiom.Phone)
                let toast = JLToast.makeText("保存成功", delay: 0, duration: 1.0)
                toast.show()
            } else {
                let toast = JLToast.makeText("保存失败", delay: 0, duration: 1.0)
                toast.show()
            }
        })
    }
    
    func delFromAddressBook(data: [JSON]) {
        ContactsStore.sharedStore.delPhoneData(data, withCallback: {
            if ContactsStore.sharedStore.isDelSuccess() {
                JLToastView.setDefaultValue(Size.screenHeight / 2, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: UIUserInterfaceIdiom.Phone)
                let toast = JLToast.makeText("删除成功", delay: 0, duration: 1.0)
                toast.show()
            } else {
                let toast = JLToast.makeText("删除失败", delay: 0, duration: 1.0)
                toast.show()
            }
        })
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    private lazy var webView: UIWebView = {
        let webView = UIWebView()
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
    
    private var jsBridge: WebViewJavascriptBridge?
    
    private var url: String = ""
}

//MARK: --------------------------- WebView Delegate --------------------------
extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        hud.show(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        setNaviBarTitle(title!, font: Font.naviTitle, textColor: Color.white)
        hud.hide(true)
        hud.removeFromSuperViewOnHide = true
    }
}
