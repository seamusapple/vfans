//
//  Service.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation

// 所有Service的派生类都要符合这个protocal
protocol ServiceProtocol: class {
    
    func onlineApiBaseUrl() -> String
    func onlineApiVersion() -> String
    func onlineApiCommonPath() -> String
}

class Service {
    //MARK: ------------------------ Life Cycle --------------------------
    init() {
        if let aChild = self as? ServiceProtocol {
            child = aChild
        }
    }
    
    //MARK: -------------------- Getter and Setter ------------------------
    weak var child: ServiceProtocol?
    
    var apiBaseUrl: String {
        get {
            return (child?.onlineApiBaseUrl())!
        }
    }
    
    var apiVersion: String {
        get {
            return (child?.onlineApiVersion())!
        }
    }
    
    var apiCommonPath: String {
        get {
            return (child?.onlineApiCommonPath())!
        }
    }

}