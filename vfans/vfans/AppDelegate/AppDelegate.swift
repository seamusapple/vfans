//
//  AppDelegate.swift
//  iFans
//
//  Created by 潘东 on 16/8/31.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    let WX_APPID = "wx4aecdc07bd5a7514"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let launchController = LaunchController()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = launchController
        self.window?.makeKeyAndVisible()
        
        // 微信支付
        WXApi.registerApp(WX_APPID, withDescription: "vfans")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("openURL:\(url.absoluteString)")
        
        if url.scheme == WX_APPID {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        return true
    }

    func onResp(resp: BaseResp!) {
        let strTitle = "支付结果"
        var strMsg = "\(resp.errCode)"
        print("resp: \(resp)")
        print("respError: \(resp.errCode)")
        if resp.isKindOfClass(PayResp) {
            switch resp.errCode {
            case 0 :
                NSNotificationCenter.defaultCenter().postNotificationName(WXPaySuccessNotification, object: nil)
//                strMsg = "支付成功!"
            default:
                NSNotificationCenter.defaultCenter().postNotificationName(WXPayFailNotification, object: nil)
                strMsg = "支付失败，请您重新支付!"
                print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
                let alert = UIAlertView(title: strTitle, message: strMsg, delegate: nil, cancelButtonTitle: "好的")
                alert.show()
            }
        }
    }

}

