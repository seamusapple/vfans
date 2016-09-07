//
//  AppContext.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation
import Alamofire

class AppContext {
    //MARK: ------------------------ Life Cycle --------------------------
    private init() {}
    
    //MARK: -------------------- Getter and Setter ------------------------
    static let sharedInstance = AppContext()
    
    private let networkReachabilityManager: NetworkReachabilityManager = {
        let networkReachabilityManager = NetworkReachabilityManager()
        return networkReachabilityManager!
    }()
    
    // 设备信息
    var type: String {
        get {
            return "ios"
        }
    }
    
    var devName: String {
        get {
            return UIDevice.currentDevice().name
        }
    }
    
    var os: String {
        get {
            return UIDevice.currentDevice().systemName + " " + UIDevice.currentDevice().systemVersion
        }
    }
    
    var devModel: String {
        get {
            return UIDevice.currentDevice().model
        }
    }
    
    var uuid: String {
        get {
            return UIDevice.currentDevice().identifierForVendor!.UUIDString
        }
    }
    
    // 运行环境相关
    var isReachable: Bool {
        get {
            return networkReachabilityManager.isReachable
        }
    }
    
    // app信息
    var appVersion: String {
        get {
            return NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        }
    }
}