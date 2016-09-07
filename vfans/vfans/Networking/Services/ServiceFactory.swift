//
//  ServiceFactory.swift
//  vfans
//
//  Created by 潘东 on 16/9/7.
//  Copyright © 2016年 潘东. All rights reserved.
//

import Foundation

struct ServiceNameList {
    
    static let vfans = "Servicevfans"
}

class ServiceFactory {
    //MARK: ------------------------ Life Cycle --------------------------
    private init() {}
    
    //MARK:----------------------- Public Methods ------------------------
    func serviceWithId(id: String) -> Service {
        if serviceStorage[id] == nil {
            if let newService = newServiceWithId(id) {
                serviceStorage[id] = newService
            }
        }
        
        return serviceStorage[id]!
    }
    
    //MARK:----------------------- Private Methods -----------------------
    private func newServiceWithId(id: String) -> Service? {
        if id == ServiceNameList.vfans {
            return vfansService()
        }
        
        return nil
    }
    
    //MARK: -------------------- Getter and Setter ------------------------
    static let sharedInstance = ServiceFactory()
    
    var serviceStorage: [String: Service] = {
       let serviceStorage = [String: Service]()
        return serviceStorage
    }()

}