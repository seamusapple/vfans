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
        setAlertController()
        setJSBridge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WebViewController.wxPaySuccess(_:)), name: WXPaySuccessNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WebViewController.wxPayFail(_:)), name: WXPayFailNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WXPaySuccessNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WXPayFailNotification, object: nil)
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
    
    func setAlertController() {
        let cancleAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let addTeleAction = UIAlertAction(title: "添加到通讯录", style: .Default, handler: { (UIAlertAction) in
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = .AnnularDeterminate
            hud.label.text = "正在保存..."
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                self.saveToAddressBook(self.personData)
                dispatch_async(dispatch_get_main_queue(), {
                    hud.hideAnimated(true)
                })
            })
        })
        
        let callTeleAction = UIAlertAction(title: "拨打联系电话", style: .Default, handler: { (UIAlertAction) in
            let telePhone = self.personData[0]["phoneNum"].stringValue
            let telURL = NSURL(string: "tel://"+"\(telePhone)")!
            let callWebview = UIWebView()
            callWebview.loadRequest(NSURLRequest(URL: telURL))
            self.view.addSubview(callWebview)
        })
        
        let saveErWeiMaAction = UIAlertAction(title: "保存二维码到相册", style: .Default, handler: { (UIAlertAction) in
            let urlToSave = self.personData[0]["erweima"].stringValue
            print(urlToSave)
            guard urlToSave.characters.count > 0 else {
                let toast = JLToast.makeText("无二维码信息", delay: 0, duration: 1.0)
                toast.show()
                return
            }
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = .AnnularDeterminate
            hud.label.text = "正在保存..."
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                self.saveErWeiMa(urlToSave)
                dispatch_async(dispatch_get_main_queue(), {
                    hud.hideAnimated(true)
                })
            })
        })
        
        addFriendsAlertController.addAction(addTeleAction)
        addFriendsAlertController.addAction(callTeleAction)
        addFriendsAlertController.addAction(saveErWeiMaAction)
        addFriendsAlertController.addAction(cancleAction)
    }
    
    func setJSBridge() {
        jsBridge = WebViewJavascriptBridge(forWebView: webView)
        jsBridge?.setWebViewDelegate(self)
        jsBridge?.registerHandler("AppNativeHandler") { [weak self] (data, responseCallback) in
            let json = JSON(data)
            print(json)
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
                    hud.label.text = "正在保存..."
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { 
                        self?.saveToAddressBook(phoneList)
                            dispatch_async(dispatch_get_main_queue(), {
                            hud.hideAnimated(true)
                        })
                    })
                }
                
            case "delPhoneNum":
                if let phoneList = data["phoneList"].array {
                    let hud = MBProgressHUD.showHUDAddedTo(self!.view, animated: true)
                    hud.mode = .AnnularDeterminate
                    hud.label.text = "正在删除..."
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                        self?.delFromAddressBook(phoneList)
                        dispatch_async(dispatch_get_main_queue(), {
                            hud.hideAnimated(true)
                        })
                    })
                }
                
            case "wxPrePay":
                let result = WXPayService.wxTruePay(data)
                if (result != ErrorDescri.DEFAULT && result != ErrorDescri.TRUEPAY) {
                    let alert = UIAlertView(title: nil, message: result.rawValue, delegate: nil, cancelButtonTitle: "好的")
                    alert.show()
                }
                
            case "addFriends":
                guard let personData = data["phoneList"].array else {
                    let toast = JLToast.makeText("无信息", delay: 0, duration: 1.0)
                    toast.show()
                    return
                }
                
                self?.personData = personData
                
                self?.presentViewController(self!.addFriendsAlertController, animated: true, completion: nil)
                
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
    
    func howToUse() {
        let loadPageController = WebViewController(url: Hybrid.baseUrl + Hybrid.howToUse)
        self.navigationController?.pushViewController(loadPageController, animated: true)
    }
    
    func wxPaySuccess(notification: NSNotification) {
        print("支付成功")
        let responseData = ["pay_status": "success"]
        jsBridge?.callHandler("wxPayStatus", data: responseData)
    }
    
    func wxPayFail(notification: NSNotification) {
        print("支付失败")
        let responseData = ["pay_status": "error"]
        jsBridge?.callHandler("wxPayStatus", data: responseData)
    }
    
    func saveErWeiMa(url: String) {
        if let imageUrl = NSURL(string: url) {
            if let data = NSData(contentsOfURL: imageUrl) {
                if (UIImage(data: data) != nil) {
                    let image = UIImage(data: data)
                    UIImageWriteToSavedPhotosAlbum(image!, self, #selector(WebViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    return
                }
            }
            let toast = JLToast.makeText("二维码格式不对，保存失败", delay: 0, duration: 1.0)
            toast.show()
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            let toast = JLToast.makeText("保存二维码失败", delay: 0, duration: 1.0)
            toast.show()
            
            return
        }
        
        let toast = JLToast.makeText("保存二维码成功", delay: 0, duration: 1.0)
        toast.show()
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
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Indeterminate
        return hud
    }()
    
    private lazy var addFriendsAlertController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: "请选择你要操作的项", preferredStyle: .ActionSheet)
        return alertController
    }()
    
    private var jsBridge: WebViewJavascriptBridge?
    
    private var url: String = ""
    
    private var personData: [JSON] = [JSON]()
}

//MARK: --------------------------- WebView Delegate --------------------------
extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        hud.showAnimated(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let isIOS = true
        webView.stringByEvaluatingJavaScriptFromString("isIOS(\(isIOS))")
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        setNaviBarTitle(title!, font: Font.naviTitle, textColor: Color.white)
        if title == "互粉神器" {
            setNaviBarBtnItemWithTitle("如何使用？", textColor: Color.white, direction: false, style: UIBarButtonItemStyle.Plain, action: #selector(WebViewController.howToUse))
        }
        hud.hideAnimated(true)
    }
}
